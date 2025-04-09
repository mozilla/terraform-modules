resource "google_project_service" "certificatemanager" {
  project = var.shared_infra_project_id

  service = "certificatemanager.googleapis.com"

  disable_on_destroy = false
}
