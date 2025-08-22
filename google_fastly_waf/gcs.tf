resource "google_storage_bucket" "fastly" {
  name          = "${var.application}-${var.realm}-${var.environment}-fastly-cdn-logs"
  project       = var.project_id
  location      = "US"
  force_destroy = true

  labels = {
    env            = var.environment
    realm          = var.realm
    application    = var.application
    component_code = "fastly-logs"
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 90
    }
  }
}
