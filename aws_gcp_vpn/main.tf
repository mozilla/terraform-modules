locals {
  aws_external_gateway_ips = {
    0 = {
      aws_external_ip_address = aws_vpn_connection.default["0"].tunnel1_address,
      aws_internal_ip_address = aws_vpn_connection.default["0"].tunnel1_vgw_inside_address
      gcp_gateway_id          = 0,
      gcp_internal_ip_address = aws_vpn_connection.default["0"].tunnel1_cgw_inside_address
      internal_ip_range       = aws_vpn_connection.default["0"].tunnel1_inside_cidr
      preshared_key           = aws_vpn_connection.default["0"].tunnel1_preshared_key,
    },
    1 = {
      aws_external_ip_address = aws_vpn_connection.default["0"].tunnel2_address,
      aws_internal_ip_address = aws_vpn_connection.default["0"].tunnel2_vgw_inside_address
      gcp_gateway_id          = 0,
      gcp_internal_ip_address = aws_vpn_connection.default["0"].tunnel2_cgw_inside_address
      internal_ip_range       = aws_vpn_connection.default["0"].tunnel2_inside_cidr
      preshared_key           = aws_vpn_connection.default["0"].tunnel2_preshared_key,
    },
    2 = {
      aws_external_ip_address = aws_vpn_connection.default["1"].tunnel1_address,
      aws_internal_ip_address = aws_vpn_connection.default["1"].tunnel1_vgw_inside_address
      gcp_gateway_id          = 1,
      gcp_internal_ip_address = aws_vpn_connection.default["1"].tunnel1_cgw_inside_address
      internal_ip_range       = aws_vpn_connection.default["1"].tunnel1_inside_cidr
      preshared_key           = aws_vpn_connection.default["1"].tunnel1_preshared_key,
    },
    3 = {
      aws_external_ip_address = aws_vpn_connection.default["1"].tunnel2_address,
      aws_internal_ip_address = aws_vpn_connection.default["1"].tunnel2_vgw_inside_address
      gcp_gateway_id          = 1,
      gcp_internal_ip_address = aws_vpn_connection.default["1"].tunnel2_cgw_inside_address
      internal_ip_range       = aws_vpn_connection.default["1"].tunnel2_inside_cidr
      preshared_key           = aws_vpn_connection.default["1"].tunnel2_preshared_key,
    },
  }
  gcp_external_gateway_ips = {
    0 = google_compute_ha_vpn_gateway.default.vpn_interfaces[0],
    1 = google_compute_ha_vpn_gateway.default.vpn_interfaces[1],
  }
  # List of supported ciphers
  # https://cloud.google.com/network-connectivity/docs/vpn/concepts/supported-ike-ciphers#ikev2_ciphers_that_use_aead
  # Note that GCP requires AWS to advertise fewer configuration options for the VPN rekeying to work
  # https://cloud.google.com/network-connectivity/docs/vpn/how-to/creating-ha-vpn#create_ha_vpn_to_aws_peer_gateways
  vpn_dh_group_numbers      = [21] # ecp521
  vpn_encryption_algorithms = ["AES256-GCM-16"]
  vpn_ike_versions          = ["ikev2"]
  vpn_integrity_algorithms  = ["SHA2-512"]
}

resource "google_compute_router" "default" {
  name    = "gcp-to-aws-cloud-router"
  network = var.gcp_network_name

  description = "GCP to AWS Cloud Router"

  bgp {
    asn = var.gcp_private_asn

    advertise_mode    = length(var.gcp_advertised_ip_ranges) > 0 ? "CUSTOM" : "DEFAULT"
    advertised_groups = length(var.gcp_advertised_ip_ranges) > 0 ? ["ALL_SUBNETS"] : []

    dynamic "advertised_ip_ranges" {
      for_each = var.gcp_advertised_ip_ranges

      content {
        description = advertised_ip_ranges.value.description
        range       = advertised_ip_ranges.value.range
      }
    }
  }
}

resource "google_compute_ha_vpn_gateway" "default" {
  name    = "gcp-to-aws-vpn-gateway"
  network = var.gcp_network_name
}

resource "aws_customer_gateway" "default" {
  for_each = local.gcp_external_gateway_ips

  bgp_asn    = var.gcp_private_asn
  ip_address = each.value.ip_address
  type       = "ipsec.1"

  tags = {
    Name = "gcp-${var.gcp_project_id}-to-aws-cg${each.value.id}"
  }
}

resource "aws_vpn_connection" "default" {
  for_each = aws_customer_gateway.default

  customer_gateway_id = each.value.id
  type                = "ipsec.1"
  vpn_gateway_id      = var.aws_vpn_gateway_id

  tunnel1_phase1_encryption_algorithms = local.vpn_encryption_algorithms
  tunnel1_phase2_encryption_algorithms = local.vpn_encryption_algorithms
  tunnel1_phase1_integrity_algorithms  = local.vpn_integrity_algorithms
  tunnel1_phase2_integrity_algorithms  = local.vpn_integrity_algorithms
  tunnel1_phase1_dh_group_numbers      = local.vpn_dh_group_numbers
  tunnel1_phase2_dh_group_numbers      = local.vpn_dh_group_numbers
  tunnel1_ike_versions                 = local.vpn_ike_versions

  tunnel2_phase1_encryption_algorithms = local.vpn_encryption_algorithms
  tunnel2_phase2_encryption_algorithms = local.vpn_encryption_algorithms
  tunnel2_phase1_integrity_algorithms  = local.vpn_integrity_algorithms
  tunnel2_phase2_integrity_algorithms  = local.vpn_integrity_algorithms
  tunnel2_phase1_dh_group_numbers      = local.vpn_dh_group_numbers
  tunnel2_phase2_dh_group_numbers      = local.vpn_dh_group_numbers
  tunnel2_ike_versions                 = local.vpn_ike_versions

  tags = {
    Name = "aws-to-gcp-${var.gcp_project_id}-vpn${each.key}"
  }
}

resource "google_compute_external_vpn_gateway" "default" {
  name            = "aws-to-gcp-${var.gcp_project_id}-peer-gateway"
  redundancy_type = "FOUR_IPS_REDUNDANCY"

  dynamic "interface" {
    for_each = local.aws_external_gateway_ips

    content {
      id         = interface.key
      ip_address = interface.value.aws_external_ip_address
    }
  }
}

resource "google_compute_vpn_tunnel" "default" {
  for_each = local.aws_external_gateway_ips

  name          = "gcp-${var.gcp_project_id}-to-aws-tunnel${each.key}"
  shared_secret = each.value.preshared_key

  peer_external_gateway           = google_compute_external_vpn_gateway.default.id
  peer_external_gateway_interface = each.key
  router                          = google_compute_router.default.id
  vpn_gateway                     = google_compute_ha_vpn_gateway.default.id
  vpn_gateway_interface           = each.value.gcp_gateway_id
}

resource "google_compute_router_interface" "default" {
  for_each = local.aws_external_gateway_ips

  name       = "if-gcp-${var.gcp_project_id}-to-aws-bgp${each.key}"
  ip_range   = "${each.value.gcp_internal_ip_address}/30"
  router     = google_compute_router.default.name
  vpn_tunnel = google_compute_vpn_tunnel.default[each.key].id
}

resource "google_compute_router_peer" "default" {
  for_each = local.aws_external_gateway_ips

  name            = "gcp-${var.gcp_project_id}-to-aws-bgp${each.key}"
  interface       = google_compute_router_interface.default[each.key].name
  ip_address      = each.value.gcp_internal_ip_address
  peer_asn        = var.aws_private_asn
  peer_ip_address = each.value.aws_internal_ip_address
  router          = google_compute_router.default.name
}
