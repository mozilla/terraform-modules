data "terraform_remote_state" "shared_project" {
  backend = "gcs"

  config = {
    bucket = "moz-fx-data-terraform-state-global"
    prefix = "projects/data-shared/${var.realm}/project"
  }
}

data "terraform_remote_state" "shared_resources" {
  backend = "gcs"

  config = {
    bucket = data.terraform_remote_state.shared_project.outputs.tfstate_bucket
    prefix = "projects/data-shared/${var.realm}/envs/${var.environment}/resources-new"
  }
}

resource "google_logging_project_sink" "data_platform_sink" {
  name                   = "pubsub-data-platform-${var.environment}"
  destination            = "pubsub.googleapis.com/${data.terraform_remote_state.shared_resources.outputs.topics.structured.logging}"
  project                = var.project
  filter                 = var.log_filter
  disabled               = true
  unique_writer_identity = true
}

resource "google_pubsub_topic_iam_member" "data_platform_sink" {
  project = data.terraform_remote_state.shared_project.outputs.project_id
  topic   = data.terraform_remote_state.shared_resources.outputs.topics.structured.logging
  role    = "roles/pubsub.publisher"
  member  = google_logging_project_sink.data_platform_sink.writer_identity
}
