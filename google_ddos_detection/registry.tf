resource "google_artifact_registry_repository" "ddos_detection" {
  project       = var.project_id
  location      = var.region
  repository_id = "ddos-detection"
  format        = "DOCKER"
  labels        = var.labels
}
