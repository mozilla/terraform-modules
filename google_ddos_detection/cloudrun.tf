resource "google_cloud_run_v2_job" "ddos_detection" {
  project  = var.project_id
  name     = local.job_name
  location = var.region
  labels   = var.labels

  template {
    labels = var.labels

    template {
      service_account = google_service_account.run.email
      max_retries     = 0

      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.ddos_detection.repository_id}/analyst:latest"

        env {
          name  = "MODE"
          value = "bigquery"
        }
        env {
          name  = "BQ_PROJECT"
          value = var.project_id
        }
        env {
          name  = "BQ_DATASET"
          value = local.bq_dataset
        }
        env {
          name  = "BQ_TABLE"
          value = local.bq_table
        }
        env {
          name  = "WINDOW_MINUTES"
          value = tostring(var.window_minutes)
        }
        env {
          name  = "MODEL"
          value = var.model
        }
        env {
          name  = "GCS_OUTPUT_BUCKET"
          value = google_storage_bucket.results.name
        }
        env {
          name = "LLM_API_KEY"
          value_source {
            secret_key_ref {
              secret  = google_secret_manager_secret.llm_api_key.secret_id
              version = "latest"
            }
          }
        }
      }
    }
  }
}
