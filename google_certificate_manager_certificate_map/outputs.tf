output "certificate_map" {
  value = google_certificate_manager_certificate_map.default
}

output "dns_authorizations" {
  value = flatten([for a in google_certificate_manager_dns_authorization.default : a.dns_resource_record])
}

output "dns_authorizations_additional_domains" {
  value = { for a in google_certificate_manager_dns_authorization.additional_domains : a.name => a.dns_resource_record }
}
