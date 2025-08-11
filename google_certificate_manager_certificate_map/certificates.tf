resource "google_certificate_manager_dns_authorization" "default" {
  for_each = { for cert in var.certificates : replace(cert.hostname, ".", "-") => cert if cert.dns_authorization == true }

  project     = coalesce(var.shared_infra_project_id, data.google_project.project.project_id)
  name        = format("%s", each.key)
  description = "managed by terraform"

  domain = each.value.hostname
}

resource "google_certificate_manager_dns_authorization" "additional_domains" {
  for_each = {
    for additional_domain in flatten([
      for cert in var.certificates : cert.additional_domains if cert.dns_authorization == true
    ]) : replace(additional_domain, ".", "-") => additional_domain
  }

  project     = coalesce(var.shared_infra_project_id, data.google_project.project.project_id)
  name        = format("%s", each.key)
  description = "managed by terraform"

  domain = each.value
}

resource "google_certificate_manager_certificate" "default" {
  for_each = { for cert in var.certificates : replace(cert.hostname, ".", "-") => cert }

  project     = coalesce(var.shared_infra_project_id, data.google_project.project.project_id)
  name        = format("%s", each.key)
  description = "managed by terraform"

  managed {
    domains = concat([each.value.hostname], each.value.additional_domains)
    dns_authorizations = each.value.dns_authorization == true ? concat(
      [google_certificate_manager_dns_authorization.default[each.key].id],
      [
        for additional_domain in each.value.additional_domains :
        google_certificate_manager_dns_authorization.additional_domains[replace(additional_domain, ".", "-")].id
      ]
    ) : []
  }
}
