# Note that there is some longstanding technical debt associated with our IaC
# configuration that means usage of remote state without SA impersonation
# requires direct Atlantis/Spacelift access to be configured. Since these
# remote state lookups are into platform-managed state where these grants
# are in effect they should work, but in future we will likely clean this up to
# require remote state lookups to use impersonation

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

data "terraform_remote_state" "org" {
  count   = local.deploy_cloud_function ? 1 : 0
  backend = "gcs"

  config = {
    bucket = "moz-fx-platform-mgmt-global-tf"
    prefix = "projects/org"
  }
}
