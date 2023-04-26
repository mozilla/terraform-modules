output "logging_bucket_id" {
  value = google_logging_project_bucket_config.namespace.id
}

output "logging_dataset_id" {
  value = google_bigquery_dataset.namespace.id
}