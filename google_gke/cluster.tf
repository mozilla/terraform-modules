# TBD block of things to investigate further in the future:
# * confidential nodes (basically encrypted in-use memory on VMs underlying nodes; in beta)
# * GKE sandbox (basically host kernel protection on nodes; in beta)
# * cluster telemetry (some kinda new monitoring / logging / metrics aggregation & dashboard for gke clusters; in beta)
# * enable_binary_authorization (all container images validated by Google Binary Authorization; needs further impact investigation)
# * enable_l4_ilb_subsetting (needs further impact investigation)
# * shielded_instance_config.enable_secure_boot & shielded_instance_config.enable_integrity_monitoring (needs further impact investigation)
# * database_encryption to be added with CloudKMS key (postponed for adding CloudKMS keys structure to Terraform or secrets management)

#
# GKE Cluster
#
resource "google_container_cluster" "primary" {
  provider = google-beta

  name            = local.cluster_name
  description     = var.description
  location        = var.region
  project         = local.project_id
  resource_labels = local.labels

  release_channel {
    channel = var.release_channel
  }

  workload_identity_config {
    workload_pool = "${local.project_id}.svc.id.goog"
  }

  # Internal Networking: Defaulting to IPTables & KubeProxy over DataPlane, eBPF & Cilium
  datapath_provider = local.datapath_provider
  dynamic "network_policy" {
    for_each = local.datapath_provider == "ADVANCED_DATAPATH" ? [] : [1]

    content {
      enabled  = true
      provider = "CALICO"
    }
  }

  dynamic "cost_management_config" {
    for_each = var.enable_cost_allocation ? [1] : []
    content {
      enabled = var.enable_cost_allocation
    }
  }

  dynamic "vertical_pod_autoscaling" {
    for_each = var.enable_vertical_pod_autoscaling ? [1] : []
    content {
      enabled = var.enable_vertical_pod_autoscaling
    }
  }

  default_snat_status {
    disabled = var.disable_snat_status
  }

  # Networking: Defaulting to Shared VPC Setup
  network         = local.network
  subnetwork      = local.subnetwork
  networking_mode = "VPC_NATIVE"
  ip_allocation_policy {
    cluster_secondary_range_name  = local.pods_ip_cidr_range_name
    services_secondary_range_name = local.services_ip_cidr_range_name
  }
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks

      content {
        cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
        display_name = lookup(cidr_blocks.value, "display_name", "")
      }
    }
    gcp_public_cidrs_access_enabled = var.enable_public_cidrs_access
  }

  dynamic "private_cluster_config" {
    for_each = var.enable_private_cluster ? [1] : []

    content {
      enable_private_endpoint = var.enable_private_cluster
      enable_private_nodes    = var.enable_private_cluster
      master_ipv4_cidr_block  = local.master_ipv4_cidr_block

      master_global_access_config {
        enabled = var.enable_private_cluster
      }
    }
  }

  # Observability
  logging_config {
    enable_components = [
      "APISERVER",
      "CONTROLLER_MANAGER",
      "SCHEDULER",
      "SYSTEM_COMPONENTS",
      "WORKLOADS"
    ]
  }

  monitoring_config {
    enable_components = var.monitoring_config_enable_components
    dynamic "managed_prometheus" {
      for_each = var.monitoring_enable_managed_prometheus ? [1] : []

      content {
        enabled = var.monitoring_enable_managed_prometheus
      }
    }
  }

  dynamic "resource_usage_export_config" {
    for_each = local.resource_usage_export_dataset_id != null ? [{
      dataset_id                           = local.resource_usage_export_dataset_id
      enable_network_egress_metering       = var.enable_network_egress_export
      enable_resource_consumption_metering = var.enable_resource_consumption_export
    }] : []

    content {
      enable_network_egress_metering       = resource_usage_export_config.value.enable_network_egress_metering
      enable_resource_consumption_metering = resource_usage_export_config.value.enable_resource_consumption_metering
      bigquery_destination {
        dataset_id = resource_usage_export_config.value.dataset_id
      }
    }
  }

  # Add-Ons
  addons_config {
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }

    network_policy_config {
      disabled = local.datapath_provider == "ADVANCED_DATAPATH" ? true : false
    }

    gcp_filestore_csi_driver_config {
      enabled = var.filestore_csi_driver
    }

    gcs_fuse_csi_driver_config {
      enabled = var.fuse_csi_driver
    }

    dns_cache_config {
      enabled = var.dns_cache
    }
  }

  # Gateway-api
  dynamic "gateway_api_config" {
    for_each = var.gateway_api_enabled ? [1] : []

    content {
      channel = "CHANNEL_STANDARD"
    }
  }

  # Google Groups for RBAC
  dynamic "authenticator_groups_config" {
    for_each = local.cluster_authenticator_security_group
    content {
      security_group = authenticator_groups_config.value.security_group
    }
  }

  # Maintenance
  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_start_time
    }

    dynamic "maintenance_exclusion" {
      for_each = var.maintenance_exclusions
      content {
        exclusion_name = maintenance_exclusion.value.name
        start_time     = maintenance_exclusion.value.start_time
        end_time       = maintenance_exclusion.value.end_time
      }
    }
  }

  # Configurations for Cluster's Default Nodepool / Nodes Defaults
  # We fully expect the default node pool to be immediately removed.
  default_max_pods_per_node = 32
  remove_default_node_pool  = true

  node_pool {
    name               = "default-pool"
    initial_node_count = 1

    node_config {
      labels = local.labels
      tags   = local.tags
    }
  }

  dynamic "node_pool_defaults" {
    for_each = var.enable_gcfs ? [1] : []
    content {
      # TODO: If we end up needing to configure more parts of `node_pool_defaults`
      # we will need to make this more dynamic
      node_config_defaults {
        gcfs_config {
          enabled = true
        }
      }
    }
  }


  lifecycle {
    ignore_changes = [
      initial_node_count,
      node_pool,
      resource_labels["asmv"],
      resource_labels["mesh_id"]
    ]

    prevent_destroy = true
  }
}

#
# GKE Node Pools as configured via Variables
#
resource "google_container_node_pool" "pools" {
  for_each    = local.node_pools
  provider    = google-beta
  name        = tobool(each.value.use_name_prefix) == false ? each.key : null
  name_prefix = tobool(each.value.use_name_prefix) == true ? format("%s-", each.key) : null

  cluster            = google_container_cluster.primary.name
  initial_node_count = each.value.initial_node_count
  location           = var.region
  max_pods_per_node  = each.value.max_pods_per_node
  project            = local.project_id

  node_locations = lookup(each.value, "node_locations", null) != null ? jsondecode(each.value.node_locations) : null

  autoscaling {
    min_node_count = each.value.min_count
    max_node_count = each.value.max_count
  }

  dynamic "network_config" {
    for_each = try({ (each.value.pod_range) = { enable_private_nodes = each.value.enable_private_nodes } }, {})

    content {
      create_pod_range     = false
      pod_range            = network_config.key
      enable_private_nodes = network_config.value.enable_private_nodes
    }
  }

  node_config {
    disk_size_gb = each.value.disk_size_gb
    disk_type    = each.value.disk_type
    image_type   = "COS_CONTAINERD"
    labels       = local.node_pools_labels[each.key]

    dynamic "guest_accelerator" {
      for_each = length(local.node_pools_guest_accelerator[each.key]) != 0 ? [1] : []

      content {
        type  = local.node_pools_guest_accelerator[each.key].type
        count = local.node_pools_guest_accelerator[each.key].count
      }
    }

    dynamic "linux_node_config" {
      for_each = length(local.node_pools_sysctls[each.key]) != 0 ? [1] : []

      content {
        sysctls = local.node_pools_sysctls[each.key]
      }
    }

    spot = local.node_pools_spot_enabled[each.key]

    machine_type    = each.value.machine_type
    oauth_scopes    = local.node_pools_oauth_scopes[each.key]
    service_account = google_service_account.cluster_service_account.email
    tags            = local.node_pools_tags[each.key]
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    dynamic "taint" {
      for_each = local.node_pools_taints[each.key]

      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }
  }

  upgrade_settings {
    max_surge       = each.value.max_surge
    max_unavailable = each.value.max_unavailable
  }

  lifecycle {
    create_before_destroy = true

    ignore_changes = [
      initial_node_count,
      node_config[0].oauth_scopes,
      node_config[0].metadata,
    ]
  }
}
