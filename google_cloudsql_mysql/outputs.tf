output "self_link" {
  value = google_sql_database_instance.primary.self_link
}

output "connection_name" {
  value = google_sql_database_instance.primary.connection_name
}

output "service_account" {
  value = google_sql_database_instance.primary.service_account_email_address
}

output "ip_addresses" {
  value = local.ip_addresses
}

output "public_ip_address" {
  value = google_sql_database_instance.primary.public_ip_address
}

output "private_ip_address" {
  value = google_sql_database_instance.primary.private_ip_address
}

output "database_instance" {
  value = google_sql_database_instance.primary
}
