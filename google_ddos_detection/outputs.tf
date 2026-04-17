output "job_name" {
  value = google_cloud_run_v2_job.ddos_detection.name
}

output "registry_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.ddos_detection.repository_id}"
}

output "llm_secret_id" {
  value = google_secret_manager_secret.llm_api_key.secret_id
}

output "results_bucket" {
  value = google_storage_bucket.results.name
}
