output "logging_bucket_id" {
  value = google_logging_project_bucket_config.namespace.id
}

output "logging_bucket_linked_dataset_id" {
  description = "Log Analytics BigQuery dataset id"
  value       = google_logging_linked_dataset.namespace_linked_dataset.bigquery_dataset[0].dataset_id
}

output "logging_dataset_id" {
  value = google_bigquery_dataset.namespace.dataset_id
}
