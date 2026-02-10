# Remote State Lookup for central topic (only when central_topic_id is not provided)
data "terraform_remote_state" "global_shared" {
  count   = var.central_topic_id == null ? 1 : 0
  backend = "gcs"

  config = {
    bucket = "moz-fx-platform-mgmt-global-tf"
    prefix = "projects/global-shared"
  }
}

# Get project number for Pub/Sub service agent (only needed for Cloud Function mode)
data "google_project" "project" {
  count      = local.deploy_cloud_function ? 1 : 0
  project_id = var.project_id
}
