/**
 * # Terraform Module for Project Provisioning
 * Sets up a single GCP project linked to a billing account plus management metadata.
 */

resource "random_id" "project" {
  byte_length = 2
}

resource "google_project" "project" {
  name        = local.display_name
  project_id  = local.project_id
  skip_delete = true

  billing_account = var.billing_account_id
  folder_id       = var.parent_id

  auto_create_network = false

  labels = local.all_project_labels

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_project_service" "project" {
  for_each           = local.all_project_services
  project            = local.project_id
  service            = each.key
  disable_on_destroy = false
}

resource "google_project_iam_audit_config" "data_access_high" {
  count = var.risk_level == "high" ? 1 : 0

  project = local.project_id
  service = "allServices"
  audit_log_config {
    log_type = "ADMIN_READ"
  }
  audit_log_config {
    log_type = "DATA_READ"
  }
  audit_log_config {
    log_type = "DATA_WRITE"
  }
}

resource "google_logging_project_exclusion" "data_access_exclusions" {
  name        = "exclude-data-access-log-sink"
  description = "Exclude data access logs except BigQuery, secrets manager, and IAM for this project"

  filter = <<EOT
log_id("cloudaudit.googleapis.com/data_access")
AND NOT protoPayload.metadata."@type"="type.googleapis.com/google.cloud.audit.BigQueryAuditMetadata"
AND NOT protoPayload.serviceName="secretmanager.googleapis.com"
AND NOT protoPayload.serviceName="iam.googleapis.com"
  EOT
}

