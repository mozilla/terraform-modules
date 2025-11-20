output "certificate_map" {
  value = google_certificate_manager_certificate_map.default
}

output "dns_authorizations" {
  value = { for dns_resource_record in flatten([for a in google_certificate_manager_dns_authorization.default : a.dns_resource_record]) : dns_record_resource.domain => dns_record_resource }
}
