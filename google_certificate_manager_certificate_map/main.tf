locals {
  name_prefix = format("%s", var.identifier)
}

resource "google_certificate_manager_certificate_map" "default" {
  name = format("%s-certificate-map", local.name_prefix)
}

resource "google_certificate_manager_certificate" "default" {
  for_each = { for entry in var.certificateMapEntries : replace(entry.hostname, ".", "-") => entry }

  name = each.key

  managed {
    domains            = each.value.add_wildcard == true ? [format("*.%s", each.value.hostname), each.value.hostname] : [each.value.hostname]
    dns_authorizations = each.value.dns_authorization == true ? [google_certificate_manager_dns_authorization.default[each.key].id] : []
  }
}

resource "google_certificate_manager_dns_authorization" "default" {
  for_each = { for entry in var.certificateMapEntries : replace(entry.hostname, ".", "-") => entry if entry.dns_authorization == true }

  name   = each.key
  domain = each.value.hostname
}

resource "google_certificate_manager_certificate_map_entry" "default" {
  for_each = { for entry in var.certificateMapEntries : replace(entry.hostname, ".", "-") => entry }

  name     = format("%s-%s", local.name_prefix, each.key)
  map      = google_certificate_manager_certificate_map.default.name
  hostname = each.value.hostname
  certificates = [
    google_certificate_manager_certificate.default[each.key].id,
  ]
}

resource "google_certificate_manager_certificate_map_entry" "wildcard" {
  for_each = { for entry in var.certificateMapEntries : replace(entry.hostname, ".", "-") => entry if entry.add_wildcard == true }

  name     = format("%s-wildcard-%s", local.name_prefix, each.key)
  map      = google_certificate_manager_certificate_map.default.name
  hostname = format("*.%s", each.value.hostname)
  certificates = [
    google_certificate_manager_certificate.default[each.key].id,
  ]
}
