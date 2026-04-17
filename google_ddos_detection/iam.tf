resource "google_service_account" "run" {
  project      = var.project_id
  account_id   = local.sa_run_name
  display_name = "${local.name_prefix} DDoS detection runner"
}

resource "google_service_account" "scheduler" {
  project      = var.project_id
  account_id   = local.sa_sch_name
  display_name = "${local.name_prefix} DDoS detection scheduler"
}

resource "google_bigquery_dataset_iam_member" "run_bq_viewer" {
  project    = var.project_id
  dataset_id = local.bq_dataset
  role       = "roles/bigquery.dataViewer"
  member     = "serviceAccount:${google_service_account.run.email}"
}

resource "google_project_iam_member" "run_bq_job_user" {
  project = var.project_id
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.run.email}"
}

resource "google_secret_manager_secret_iam_member" "run_secret_accessor" {
  project   = var.project_id
  secret_id = google_secret_manager_secret.llm_api_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.run.email}"
}

resource "google_cloud_run_v2_job_iam_member" "scheduler_invoker" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_job.ddos_detection.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_service_account.scheduler.email}"
}
