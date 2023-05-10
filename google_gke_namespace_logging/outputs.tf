output "logging_bucket_id" {
  value = google_logging_project_bucket_config.namespace.id
}
