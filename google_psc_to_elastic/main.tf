locals {
  dns_name = "${data.ec_gcp_private_service_connect_endpoint.default.domain_name}."
  name     = "${var.name}-${var.gcp_region}-psc-elastic-endpoint"
}

data "google_project" "project" {
}

data "ec_gcp_private_service_connect_endpoint" "default" {
  region = var.gcp_region
}

data "google_compute_network" "default" {
  name    = var.network_name
  project = var.project_id_for_network != "" ? var.project_id_for_network : data.google_project.project.project_id
}

data "google_compute_subnetwork" "default" {
  name    = var.subnetwork_name
  project = var.project_id_for_network != "" ? var.project_id_for_network : data.google_project.project.project_id
}

resource "google_compute_address" "default" {
  name = local.name

  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = data.google_compute_subnetwork.default.id
}

resource "google_compute_forwarding_rule" "default" {
  name = local.name

  ip_address            = google_compute_address.default.id
  load_balancing_scheme = ""
  network               = data.google_compute_network.default.id
  target                = data.ec_gcp_private_service_connect_endpoint.default.service_attachment_uri
}

resource "google_dns_managed_zone" "default" {
  name = replace(data.ec_gcp_private_service_connect_endpoint.default.domain_name, ".", "-")

  dns_name   = local.dns_name
  visibility = "private"

  private_visibility_config {
    networks {
      network_url = data.google_compute_network.default.id
    }
  }
}

resource "google_dns_record_set" "default" {
  managed_zone = google_dns_managed_zone.default.name
  name         = "*.${local.dns_name}"
  type         = "A"

  rrdatas = [google_compute_address.default.address]
  ttl     = 3600
}
