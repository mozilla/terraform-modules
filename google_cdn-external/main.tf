/**
 * # Google CDN Distribution for external endpoints
 */

locals {
  name_prefix = join("-", [var.application, var.environment, var.name != "" ? "${var.name}-cdn" : "cdn"])
}

resource "google_compute_global_network_endpoint_group" "default" {
  name                  = local.name_prefix
  default_port          = var.origin_port
  network_endpoint_type = "INTERNET_FQDN_PORT"
}

resource "google_compute_global_network_endpoint" "default" {
  global_network_endpoint_group = google_compute_global_network_endpoint_group.default.name

  fqdn = var.origin_fqdn
  port = var.origin_port
}

resource "google_compute_backend_service" "default" {
  name                            = local.name_prefix
  enable_cdn                      = true
  timeout_sec                     = var.backend_timeout_sec
  connection_draining_timeout_sec = 10
  compression_mode                = var.compression_mode

  security_policy = var.security_policy

  protocol = var.origin_protocol

  custom_request_headers = concat(["host: ${var.origin_fqdn}"], var.custom_request_headers)

  custom_response_headers = var.custom_response_headers

  backend {
    group = google_compute_global_network_endpoint_group.default.self_link
  }

  log_config {
    enable      = true
    sample_rate = var.log_sample_rate
  }

  dynamic "cdn_policy" {
    for_each = var.cdn_policy != {} ? [1] : []

    content {
      cache_mode                   = lookup(var.cdn_policy, "cache_mode", null)
      client_ttl                   = lookup(var.cdn_policy, "client_ttl", null)
      default_ttl                  = lookup(var.cdn_policy, "default_ttl", null)
      max_ttl                      = lookup(var.cdn_policy, "max_ttl", null)
      negative_caching             = lookup(var.cdn_policy, "negative_caching", null)
      serve_while_stale            = lookup(var.cdn_policy, "serve_while_stale", null)
      signed_url_cache_max_age_sec = lookup(var.cdn_policy, "signed_url_cache_max_age_sec", null)
      cache_key_policy {
        include_host           = lookup(var.cache_key_policy, "include_host", true)
        include_protocol       = lookup(var.cache_key_policy, "include_protocol", true)
        include_query_string   = lookup(var.cache_key_policy, "include_query_string", true)
        include_http_headers   = lookup(var.cache_key_policy, "include_https_heaers", null)
        include_named_cookies  = lookup(var.cache_key_policy, "include_named_cookies", null)
        query_string_whitelist = lookup(var.cache_key_policy, "query_string_whitelist", null)
        query_string_blacklist = lookup(var.cache_key_policy, "query_string_blacklist", null)
      }
      dynamic "negative_caching_policy" {
        for_each = { for policy in var.negative_caching_policy : "${policy.code}.${policy.ttl}" => policy }
        content {
          code = negative_caching_policy.value.code
          ttl  = negative_caching_policy.value.ttl
        }
      }
    }
  }

  depends_on = [google_compute_global_network_endpoint.default]
}

resource "google_compute_url_map" "default" {
  name = local.name_prefix

  default_service = google_compute_backend_service.default.id

  dynamic "host_rule" {
    for_each = var.path_rewrites
    content {
      hosts        = host_rule.value.hosts
      path_matcher = host_rule.key
    }
  }

  dynamic "path_matcher" {
    for_each = var.path_rewrites
    content {
      name            = path_matcher.key
      default_service = google_compute_backend_service.default.self_link
      path_rule {
        paths   = path_matcher.value.paths
        service = google_compute_backend_service.default.self_link
        route_action {
          url_rewrite {
            path_prefix_rewrite = path_matcher.value.target
          }
        }
      }
    }
  }
}

resource "google_compute_url_map" "https_redirect" {
  name = "${local.name_prefix}-redirect"

  default_url_redirect {
    host_redirect          = var.primary_hostname
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }
}

resource "google_compute_target_http_proxy" "default" {
  name    = local.name_prefix
  url_map = var.https_redirect ? google_compute_url_map.https_redirect.id : google_compute_url_map.default.id
}

resource "google_compute_target_https_proxy" "default" {
  name             = local.name_prefix
  url_map          = google_compute_url_map.default.id
  ssl_certificates = var.certs
  quic_override    = var.quic_override
}

resource "google_compute_global_forwarding_rule" "http" {
  for_each = {
    ipv4 = {
      address = var.addresses.ipv4
    },
    ipv6 = {
      address = var.addresses.ipv6
    },
  }

  name       = "${local.name_prefix}-http-${each.key}"
  target     = google_compute_target_http_proxy.default.id
  port_range = "80"

  ip_address = each.value.address
}

resource "google_compute_global_forwarding_rule" "https" {
  for_each = {
    ipv4 = {
      address = var.addresses.ipv4
    },
    ipv6 = {
      address = var.addresses.ipv6
    },
  }

  name       = "${local.name_prefix}-https-${each.key}"
  target     = google_compute_target_https_proxy.default.id
  port_range = "443"

  ip_address = each.value.address
}
