/**
 * # Terraform Module: GKE Tenant Namepsace Logging
 * Creates a logging bucket and grants access to the logging service account so that
 * GKE Logs associated with the tenant namespace are available in the tenant project.
 * The log routing configuration happens as part of the GKE tenant bootstrapping.
 */

locals {
  tenant_namespace = "${var.application}-${var.environment}"
}

moved {
  from = google_logging_project_bucket_config.namespace[0]
  to   = google_logging_project_bucket_config.namespace
}

resource "google_logging_project_bucket_config" "namespace" {
  project          = var.project
  location         = var.location
  bucket_id        = "gke-${local.tenant_namespace}-log-bucket"
  description      = "Log bucket for ${local.tenant_namespace}"
  retention_days   = var.retention_days
  enable_analytics = true
}

moved {
  from = google_project_iam_member.logging_bucket_writer[0]
  to   = google_project_iam_member.logging_bucket_writer
}

resource "google_project_iam_member" "logging_bucket_writer" {
  project = var.project
  role    = "roles/logging.bucketWriter"
  member  = var.logging_writer_service_account_member

  condition {
    title       = "Log bucket writer for ${local.tenant_namespace}"
    expression  = "resource.name.endsWith(\"locations/${var.location}/buckets/gke-${local.tenant_namespace}-log-bucket\")"
    description = "Grants logging.bucketWriter role to service account ${var.logging_writer_service_account_member} used by gke-${local.tenant_namespace}-sink"
  }
}

moved {
  from = google_bigquery_dataset.namespace[0]
  to   = google_bigquery_dataset.namespace
}

resource "google_bigquery_dataset" "namespace" {
  dataset_id    = replace("gke-${local.tenant_namespace}-log", "-", "_")
  friendly_name = "gke-${local.tenant_namespace}-log-dataset"
  description   = "Log dataset for ${local.tenant_namespace}"

  default_table_expiration_ms     = var.retention_days * 86400000
  default_partition_expiration_ms = var.retention_days * 86400000
  location                        = "US"
}

moved {
  from = google_bigquery_dataset_iam_member.logging_dataset_writer[0]
  to   = google_bigquery_dataset_iam_member.logging_dataset_writer
}

resource "google_bigquery_dataset_iam_member" "logging_dataset_writer" {
  dataset_id = google_bigquery_dataset.namespace.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = var.logging_writer_service_account_member
}

moved {
  from = google_logging_linked_dataset.namespace_linked_dataset[0]
  to   = google_logging_linked_dataset.namespace_linked_dataset
}

resource "google_logging_linked_dataset" "namespace_linked_dataset" {
  link_id     = replace("gke-${local.tenant_namespace}-log-linked", "-", "_")
  bucket      = google_logging_project_bucket_config.namespace.id
  description = "Linked Dataset for GKE Namespace Logging ${local.tenant_namespace}"
}
