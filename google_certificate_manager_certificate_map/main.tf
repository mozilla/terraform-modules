locals {
  name_prefix = format("%s", var.identifier)
}

resource "google_certificate_manager_certificate_map" "default" {
  name = format("%s-certificate-map", local.name_prefix)
}

resource "google_certificate_manager_certificate" "default" {
  for_each = { for domain in var.certificates : replace(domain.hostname, ".", "-") => domain }

  name = each.key

  managed {
    domains = each.value.add_wildcard == true ? [format("*.%s", each.value.hostname), each.value.hostname] : [each.value.hostname]
  }
}

resource "google_certificate_manager_dns_authorization" "default" {
  for_each = { for domain in var.certificates : replace(domain.hostname, ".", "-") => domain if domain.dns_authorization == true }

  name   = each.key
  domain = each.value.hostname
}

resource "google_certificate_manager_certificate_map_entry" "default" {
  name         = format("%s-certificate-map-entry", local.name_prefix)
  map          = google_certificate_manager_certificate_map.default.name
  certificates = [for domain in var.certificates : google_certificate_manager_certificate.default[replace(domain.hostname, ".", "-")].id]
  matcher      = "PRIMARY"
}
