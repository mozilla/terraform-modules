resource "google_secret_manager_secret" "llm_api_key" {
  project   = var.project_id
  secret_id = "${local.name_prefix}-llm-api-key"
  labels    = var.labels

  replication {
    auto {}
  }
}
