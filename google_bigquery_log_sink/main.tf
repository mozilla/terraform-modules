locals {
  ninety_days_in_ms = 7776000000 // 90 days in ms
}

resource "google_bigquery_dataset" "self" {
  dataset_id = "log_storage_${var.environment}"

  default_table_expiration_ms     = local.ninety_days_in_ms
  default_partition_expiration_ms = local.ninety_days_in_ms
  location                        = "US"
}

resource "google_logging_project_sink" "self" {
  name        = "bigquery-log-storage-${var.environment}"
  destination = "bigquery.googleapis.com/${google_bigquery_dataset.self.id}"

  filter                 = var.log_filter
  unique_writer_identity = true

  bigquery_options {
    use_partitioned_tables = true
  }
}

resource "google_project_iam_member" "self" {
  project = var.project
  role    = "roles/bigquery.dataEditor"
  member  = google_logging_project_sink.self.writer_identity
}
