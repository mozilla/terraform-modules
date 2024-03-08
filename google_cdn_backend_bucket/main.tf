/*
 * # google_cdn_backend_bucket
 * 
 * this module builds a GCP Load Balancer with a backend bucket
 */

resource "google_compute_backend_bucket" "default" {
  name        = format("%s", local.name_prefix)
  bucket_name = var.bucket_name

  compression_mode = var.compression_mode
  enable_cdn       = true

  cdn_policy {
    cache_mode        = var.cdn_policy.cache_mode
    client_ttl        = var.cdn_policy.client_ttl
    default_ttl       = var.cdn_policy.default_ttl
    max_ttl           = var.cdn_policy.max_ttl
    negative_caching  = var.cdn_policy.negative_caching
    serve_while_stale = var.cdn_policy.serve_while_stale
  }
}

resource "google_compute_url_map" "default" {
  name            = format("%s", local.name_prefix)
  default_service = google_compute_backend_bucket.default.self_link
}

resource "google_compute_url_map" "https_redirect" {
  name = format("%s-https-redirect", local.name_prefix)

  default_url_redirect {
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }
}

resource "google_compute_target_http_proxy" "default" {
  name    = format("%s", local.name_prefix)
  url_map = google_compute_url_map.https_redirect.id
}

resource "google_compute_target_https_proxy" "default" {
  name             = format("%s", local.name_prefix)
  url_map          = google_compute_url_map.default.id
  ssl_certificates = var.certificates
  quic_override    = "DISABLE"
}

resource "google_compute_global_forwarding_rule" "http" {
  for_each = var.addresses

  name       = format("%s-http-%s", local.name_prefix, each.key)
  port_range = "80"
  target     = google_compute_target_http_proxy.default.id
  ip_address = each.value
}

resource "google_compute_global_forwarding_rule" "https" {
  for_each = var.addresses

  name       = format("%s-https-%s", local.name_prefix, each.key)
  port_range = "443"
  target     = google_compute_target_https_proxy.default.id
  ip_address = each.value
}
