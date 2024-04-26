output "logging_bucket_id" {
  value = var.log_destination == "bucket" ? google_logging_project_bucket_config.namespace[0].id : null
}

output "logging_dataset_id" {
  value = var.log_destination == "bigquery" ? google_bigquery_dataset.namespace[0].dataset_id : null
}
