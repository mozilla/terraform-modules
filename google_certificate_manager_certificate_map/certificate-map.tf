locals {
  certificate_map_entries_map = {
    for entry in local.certificate_domain_map : replace(replace(entry.domain, ".", "-"), "*", "wildcard") => {
      domain      = entry.domain,
      certificate = entry.certificate
    }
  }
}

resource "google_certificate_manager_certificate_map" "default" {
  project     = try(var.shared_infra_project_id)
  name        = format("%s", local.name_prefix)
}

resource "random_id" "certificate_map_entry_id" {
  for_each = local.certificate_map_entries_map

  byte_length = 8

  keepers = {
    map    = google_certificate_manager_certificate_map.default.name
    domain = each.value.domain
  }
}

resource "google_certificate_manager_certificate_map_entry" "default" {
  for_each = local.certificate_map_entries_map

  project     = try(var.shared_infra_project_id)
  name        = format("%s-%s", local.name_prefix, random_id.certificate_map_entry_id[each.key].hex)

  map      = google_certificate_manager_certificate_map.default.name
  hostname = each.value.domain

  certificates = [
    google_certificate_manager_certificate.default[each.value.certificate].id,
  ]
}
