#
# K8S API Proxy Setup
#
resource "google_compute_address" "static_v4_k8s_api_proxy_ip" {
  count        = var.enable_k8s_api_proxy_ip ? 1 : 0
  provider     = google-beta # At this time the beta provider is required to define labels
  name         = format("k8s-api-proxy-%s-%s-ip-v4-internal", var.name, var.region)
  description  = format("IPv4 Internal - k8s api proxy - name:%s region:%s", var.name, var.region)
  subnetwork   = var.service_subnetworks[var.region].subnetwork
  region       = var.region
  address_type = "INTERNAL"

  labels = local.labels
}

resource "google_dns_record_set" "k8s_api_proxy_dns_name" {
  count        = var.enable_k8s_api_proxy_ip ? 1 : 0
  name         = "${local.k8s_api_proxy_name}.${var.project_outputs.zone_dns_name}"
  managed_zone = var.project_outputs.zone_name

  type = "A"
  ttl  = 300

  rrdatas = [
    google_compute_address.static_v4_k8s_api_proxy_ip[0].address
  ]
}
