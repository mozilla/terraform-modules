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

output "replica_instance" {
  value = var.replica_count == 0 ? null : google_sql_database_instance.replica
}

output "replica_private_ip_address" {
  value = var.replica_count == 0 ? null : google_sql_database_instance.replica[*].private_ip_address
}

output "replica_public_ip_address" {
  value = var.replica_count == 0 ? null : google_sql_database_instance.replica[*].public_ip_address
}
