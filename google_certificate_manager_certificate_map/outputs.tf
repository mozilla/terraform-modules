output "certificate_map" {
  value = google_certificate_manager_certificate_map.default
}

output "dns_authorizations" {
  value = flatten([for a in google_certificate_manager_dns_authorization.default : a.dns_resource_record])
}
