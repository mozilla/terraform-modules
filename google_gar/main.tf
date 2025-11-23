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
  depends_on    = [google_project_service.gar]
  repository_id = local.repository_id
  format        = var.format
  location      = var.location
  description   = var.description
  project       = var.project

  dynamic "cleanup_policies" {
    for_each = var.cleanup_policies

    content {
      id     = cleanup_policies.value.id
      action = cleanup_policies.value.action

      dynamic "condition" {
        for_each = cleanup_policies.value.condition != null ? { condition = cleanup_policies.value.condition } : {}

        content {
          tag_state             = condition.value.tag_state
          tag_prefixes          = condition.value.tag_prefixes
          version_name_prefixes = condition.value.version_name_prefixes
          package_name_prefixes = condition.value.package_name_prefixes
          older_than            = condition.value.older_than
          newer_than            = condition.value.newer_than
        }
      }

      dynamic "most_recent_versions" {
        for_each = cleanup_policies.value.most_recent_versions != null ? { most_recent_versions = cleanup_policies.value.most_recent_versions } : {}

        content {
          package_name_prefixes = most_recent_versions.value.package_name_prefixes
          keep_count            = most_recent_versions.value.keep_count
        }
      }
    }
  }

  labels = {
    app_code = var.application
    realm    = var.realm
  }
}

resource "google_artifact_registry_repository_iam_member" "reader" {
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
  project    = var.project
  location   = var.location
  repository = google_artifact_registry_repository.repository.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.writer_service_account.email}"
}
