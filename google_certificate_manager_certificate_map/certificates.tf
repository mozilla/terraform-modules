resource "google_certificate_manager_dns_authorization" "default" {
  for_each = { for cert in var.certificates : replace(cert.hostname, ".", "-") => cert if cert.dns_authorization == true }

  project     = var.shared_infra_project_id
  name        = format("%s", each.key)
  description = "managed by terraform"

  domain = each.value.hostname
}

resource "google_certificate_manager_certificate" "default" {
  for_each = { for cert in var.certificates : replace(cert.hostname, ".", "-") => cert }

  project     = var.shared_infra_project_id
  name        = format("%s", each.key)
  description = "managed by terraform"

  managed {
    domains            = concat([each.value.hostname], each.value.additional_domains)
    dns_authorizations = each.value.dns_authorization == true ? [google_certificate_manager_dns_authorization.default[each.key].id] : []
  }
}
