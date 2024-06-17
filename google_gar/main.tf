/**
 * # Terraform Module: Google Artifact Registry repository
 * Creates a GAR repository and a service account to access it.
 */


resource "google_project_service" "gar" {
  project            = var.project
  disable_on_destroy = "false"
  service            = "artifactregistry.googleapis.com"
}

resource "google_artifact_registry_repository" "repository" {
  provider      = google-beta
  depends_on    = [google_project_service.gar]
  repository_id = local.repository_id
  format        = var.format
  location      = var.location
  description   = var.description
  project       = var.project

  labels = {
    app_code = var.application
    realm    = var.realm
  }
}

resource "google_artifact_registry_repository_iam_member" "reader" {
  provider   = google-beta
  for_each   = toset(var.repository_readers)
  project    = var.project
  location   = var.location
  repository = google_artifact_registry_repository.repository.name
  role       = "roles/artifactregistry.reader"
  member     = each.key
}

resource "google_service_account" "writer_service_account" {
  account_id   = var.writer_service_account_id
  display_name = "Artifact Writer"
  project      = var.project
}

resource "google_artifact_registry_repository_iam_member" "writer" {
  provider   = google-beta
  project    = var.project
  location   = var.location
  repository = google_artifact_registry_repository.repository.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.writer_service_account.email}"
}
