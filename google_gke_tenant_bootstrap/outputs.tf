output "gke_service_account" {
  value = google_gsm_for_gke.gke-service-account
}

output "deploy_service_account" {
  value = google_deployment_accounts.service_account
}

output "gar_service_account" {
  value = google_gar.writer_service_account
}

output "gar_repository" {
  value = google_gar.repository
}
