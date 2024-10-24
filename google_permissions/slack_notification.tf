# Find the project number of the project whose identity will be used for sending
# the asset change notifications.

resource "google_service_account" "account" {
  for_each     = var.slack_project_map
  account_id   = "slack-send-pam-sa"
  display_name = "Slack sender function service account"
  project      = each.key
}

# Create a feed that sends notifications about network resource updates.
resource "google_cloud_asset_project_feed" "project_feed" {
  for_each     = var.slack_project_map
  project      = each.key
  feed_id      = var.feed_id
  content_type = "RESOURCE"

  asset_types = [
    "privilegedaccessmanager.googleapis.com/Grant",
  ]

  feed_output_config {
    pubsub_destination {
      topic = google_pubsub_topic.feed_output[each.key].id
    }
  }

  # start with no condition to see what we get in the feed
}

# The topic where the resource change notifications will be sent.
resource "google_pubsub_topic" "feed_output" {
  for_each                   = var.slack_project_map
  project                    = each.key
  name                       = var.pubsub_topic
  message_retention_duration = "86400s"
}


resource "google_pubsub_topic_iam_binding" "binding" {
  for_each = var.slack_project_map
  project  = each.key
  topic    = google_pubsub_topic.feed_output[each.key].id
  role     = "roles/pubsub.admin"
  members  = ["serviceAccount:${google_service_account.account[each.key].email}"]
}

// we want to share the bucket among all the projects related to this module instance
resource "google_storage_bucket" "bucket" {
  // TODO - sort out how to make this unique across all the projects
  // this is some FOO right here
  name                        = "${replace(replace(keys(var.slack_project_map)[0], "-prod", ""), "-nonprod", "")}-gcf-source" # Every bucket name must be globally unique
  location                    = "US"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "write_bucket_iam_member" {
  for_each   = var.slack_project_map
  bucket     = google_storage_bucket.bucket.name
  role       = "roles/storage.objectAdmin"
  member     = "serviceAccount:${google_service_account.account[each.key].email}"
  depends_on = [google_storage_bucket.bucket]
}

data "archive_file" "cloud_function_code" {
  type        = "zip"
  source_dir  = "${path.module}/python"
  output_path = var.function_archive_name
}

resource "google_storage_bucket_object" "object" {
  name   = var.function_archive_name
  bucket = google_storage_bucket.bucket.name
  source = var.function_archive_name # Add path to the zipped function source code
}

resource "google_cloudfunctions2_function_iam_member" "serviceagent-eventarc" {
  for_each       = var.slack_project_map
  project        = each.key
  location       = google_cloudfunctions2_function.function[each.key].location
  cloud_function = google_cloudfunctions2_function.function[each.key].name
  member         = "serviceAccount:${google_service_account.account[each.key].email}"
  role           = "roles/eventarc.serviceAgent"
}

resource "google_cloudfunctions2_function_iam_member" "serviceagent-cloudfunc" {
  for_each       = var.slack_project_map
  project        = each.key
  location       = google_cloudfunctions2_function.function[each.key].location
  cloud_function = google_cloudfunctions2_function.function[each.key].name
  member         = "serviceAccount:${google_service_account.account[each.key].email}"
  role           = "roles/cloudfunctions.serviceAgent"
}


resource "google_cloudfunctions2_function_iam_member" "invoker" {
  for_each       = var.slack_project_map
  project        = each.key
  location       = google_cloudfunctions2_function.function[each.key].location
  cloud_function = google_cloudfunctions2_function.function[each.key].name
  member         = "serviceAccount:${google_service_account.account[each.key].email}"
  role           = "roles/cloudfunctions.invoker"
}

# resource "google_cloud_run_service_iam_member" "cloud_run_invoker" {
#   provider = google-beta
#   project  = google_cloudfunctions2_function.function.project
#   location = google_cloudfunctions2_function.function.location
#   service  = google_cloudfunctions2_function.function.name
#   role     = "roles/run.invoker"
#   member   = "serviceAccount:${google_service_account.account.email}"
# }
# 
resource "google_cloudfunctions2_function" "function" {
  for_each = var.slack_project_map
  provider = google-beta
  name     = var.function_name
  location = var.function_region
  project  = each.key

  build_config {
    entry_point = "cloudevent_handler"
    runtime     = "python312"
    environment_variables = {
    }
    source {
      storage_source {
        bucket = google_storage_bucket.bucket.name
        object = var.function_archive_name
      }
    }
  }

  service_config {
    available_memory   = "8Gi"
    min_instance_count = 1
    available_cpu      = "2"
    timeout_seconds    = 540 # 9 minutes - max for event-driven functions
    environment_variables = {
      "SLACK_WEBHOOK_URL" = each.value
    }
    service_account_email = google_service_account.account[each.key].email
  }

  event_trigger {
    trigger_region = var.function_region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    #service_account_email = google_service_account.account.email
    retry_policy = "RETRY_POLICY_RETRY"
    pubsub_topic = google_pubsub_topic.feed_output[each.key].id
  }
}