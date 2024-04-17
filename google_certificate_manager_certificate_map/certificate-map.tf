resource "google_certificate_manager_certificate_map" "default" {
  project     = substr(format("moz-fx-webservices-%s-%s", var.risk_level, var.realm), 0, 32)
  name        = format("%s", local.name_prefix)
  description = "managed by terraform - code lives in tenant project"
}

resource "google_certificate_manager_certificate_map_entry" "default" {
  for_each = {
    for entry in local.certificate_domain_map : replace(replace(entry.domain, ".", "-"), "*", "wildcard") => {
      domain      = entry.domain,
      certificate = entry.certificate
    }
  }

  project     = substr(format("moz-fx-webservices-%s-%s", var.risk_level, var.realm), 0, 32)
  name        = format("%s-%s", local.name_prefix, each.key)
  description = "managed by terraform - code lives in tenant project"

  map      = google_certificate_manager_certificate_map.default.name
  hostname = each.value.domain

  certificates = [
    google_certificate_manager_certificate.default[each.value.certificate].id,
  ]
}
