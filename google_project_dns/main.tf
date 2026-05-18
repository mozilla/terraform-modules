/**
 * # Terraform Module: Project DNS
 * Creates a DNS zone for an application's project and realm and links it to the parent zone.
 *
 * The created zone will be:
 *
 * `APP_NAME.REALM.TEAM_NAME.mozgcp.net`
 */

resource "google_project_service" "dns" {
  project            = var.project_id
  service            = "dns.googleapis.com"
  disable_on_destroy = false
}

resource "google_dns_managed_zone" "zone" {
  name        = local.zone_name
  dns_name    = local.dns_name
  description = "Zone for ${local.zone_name}"

  project = var.project_id
}

resource "google_dns_record_set" "ns" {
  name = google_dns_managed_zone.zone.dns_name

  project      = var.parent_project_id
  managed_zone = var.parent_managed_zone

  ttl  = 300
  type = "NS"

  rrdatas = google_dns_managed_zone.zone.name_servers

  depends_on = [google_project_service.dns]
}
