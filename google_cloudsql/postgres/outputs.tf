output "db_instance_ip" {
  value = google_sql_database_instance.primary.private_ip_address
}
