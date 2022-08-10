resource "google_project_service" "GSM" {
  project            = var.project_id
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_iam_audit_config" "GSM" {
  project = var.project_id
  service = "secretmanager.googleapis.com"
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
