resource "google_cloud_scheduler_job" "ddos_detection" {
  project          = var.project_id
  region           = var.region
  name             = local.job_name
  schedule         = "*/5 * * * *"
  time_zone        = "UTC"
  attempt_deadline = "320s"

  http_target {
    http_method = "POST"
    uri         = "https://run.googleapis.com/v2/projects/${var.project_id}/locations/${var.region}/jobs/${google_cloud_run_v2_job.ddos_detection.name}:run"

    oauth_token {
      service_account_email = google_service_account.scheduler.email
    }
  }
}
