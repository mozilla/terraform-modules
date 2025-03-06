resource "google_storage_bucket" "fastly" {
  name          = "${var.application}-${var.realm}-${var.environment}-fastly-cdn-logs"
  project       = var.project_id
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 90
    }
  }
}
