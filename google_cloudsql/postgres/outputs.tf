output "db_instance_ip" {
  value = google_sql_database_instance.master.private_ip_address
}
