/**
 * # Terraform Module: GKE Tenant Namepsace Logging
 * Creates a logging bucket and grants access to the logging service account so that
 * GKE Logs associated with the tenant namespace are available in the tenant project.
 * The log routing configuration happens as part of the GKE tenant bootstrapping.
 */

locals {
  tenant_namespace = "${var.application}-${var.environment}"
}

resource "google_logging_project_bucket_config" "namespace" {
  count          = var.log_destination == "bucket" ? 1 : 0
  project        = var.project
  location       = var.location
  bucket_id      = "gke-${local.tenant_namespace}-log-bucket"
  description    = "Log bucket for ${local.tenant_namespace}"
  retention_days = var.retention_days
}

resource "google_project_iam_member" "logging_bucket_writer" {
  count   = var.logging_writer_service_account_member != "" ? 1 : 0
  project = var.project
  role    = "roles/logging.bucketWriter"
  member  = var.logging_writer_service_account_member

  condition {
    title       = "Log bucket writer for ${local.tenant_namespace}"
    expression  = "resource.name.endsWith(\"locations/${var.location}/buckets/gke-${local.tenant_namespace}-log-bucket\")"
    description = "Grants logging.bucketWriter role to service account ${var.logging_writer_service_account_member} used by gke-${local.tenant_namespace}-sink"
  }
}

resource "google_bigquery_dataset" "namespace" {
  count         = var.log_destination == "bigquery" ? 1 : 0
  dataset_id    = replace("gke-${local.tenant_namespace}-log-dataset", "-", "_")
  friendly_name = "gke-${local.tenant_namespace}-log-dataset"
  description   = "Log dataset for ${local.tenant_namespace}"

  default_table_expiration_ms     = var.retention_days * 86400000
  default_partition_expiration_ms = var.retention_days * 86400000
  location                        = "US"
}

resource "google_project_iam_member" "logging_dataset_writer" {
  count   = var.logging_writer_service_account_member != "" ? 1 : 0
  project = var.project
  role    = "roles/bigquery.dataEditor"
  member  = var.logging_writer_service_account_member

  condition {
    title       = "Log dataset writer for ${local.tenant_namespace}"
    expression  = "resource.name.endsWith(\"datasets/gke-${local.tenant_namespace}-log-dataset\")"
    description = "Grants bigquery.dataEditor role to service account ${var.logging_writer_service_account_member} used by gke-${local.tenant_namespace}-sink"
  }
}
