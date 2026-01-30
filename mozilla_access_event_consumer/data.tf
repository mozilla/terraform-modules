# Remote State Lookup for central topic
data "terraform_remote_state" "global_shared" {
  backend = "gcs"

  config = {
    bucket = "moz-fx-platform-mgmt-global-tf"
    prefix = "projects/global-shared"
  }
}

# Get project number for Pub/Sub service account
data "google_project" "project" {
  project_id = var.project_id
}
