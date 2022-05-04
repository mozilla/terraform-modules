output "repository" {
  value = google_artifact_registry_repository.repository
}

output "writer_service_account" {
  value = google_service_account.writer_service_account
}
