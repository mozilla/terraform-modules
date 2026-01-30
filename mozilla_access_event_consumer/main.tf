locals {
  # Get central topic ID from remote state or use override
  central_topic_id = var.central_topic_id != null ? var.central_topic_id : data.terraform_remote_state.global_shared.outputs.employee_exits_topic_id

  # Validate that at least one of function_source_dir or service_account is provided
  validate_config = (var.function_source_dir != null || var.service_account != null) ? true : tobool("Either function_source_dir (for Cloud Function mode) or service_account (for GKE mode) must be provided")

  # Determine subscription name (includes environment to avoid conflicts)
  subscription_name = var.subscription_name != null && var.subscription_name != "" ? var.subscription_name : "${var.application}-${var.environment}-employee-exits"

  # Determine function name (includes environment to avoid conflicts)
  function_name = var.function_name != null && var.function_name != "" ? var.function_name : "${var.application}-${var.environment}-exit-processor"

  # Determine deployment mode
  deploy_cloud_function = var.function_source_dir != null
  deploy_k8s            = var.function_source_dir == null

  # Validate GKE mode has service_account
  validate_k8s_mode = local.deploy_k8s ? (var.service_account != null && var.service_account != "" ? true : tobool("service_account is required when function_source_dir is not provided (GKE mode)")) : true

  # Determine which service account to grant subscription access
  # For Cloud Functions: use the function's service account
  # For GKE: use the provided service account
  consumer_service_account = local.deploy_cloud_function ? google_service_account.consumer[0].email : var.service_account
}

# Service Account for the Cloud Function (only created if deploying Cloud Function)
resource "google_service_account" "consumer" {
  count   = local.deploy_cloud_function ? 1 : 0
  project = var.project_id

  account_id   = var.service_account_name != null && var.service_account_name != "" ? var.service_account_name : "${var.application}-${var.environment}-exit"
  display_name = var.service_account_display_name != null && var.service_account_display_name != "" ? var.service_account_display_name : "${var.application} ${var.environment} exit"
  description  = "Service account for processing employee exit notifications via Cloud Function in ${var.environment}"
}

# Pub/Sub Subscription (only needed for GKE mode)
# Cloud Functions use Eventarc which automatically manages subscriptions
resource "google_pubsub_subscription" "exit_consumer" {
  count   = local.deploy_k8s ? 1 : 0
  project = var.project_id
  name    = local.subscription_name
  topic   = local.central_topic_id

  message_retention_duration = var.message_retention_duration
  ack_deadline_seconds       = var.ack_deadline_seconds

  retry_policy {
    minimum_backoff = var.retry_minimum_backoff
    maximum_backoff = var.retry_maximum_backoff
  }

  dynamic "dead_letter_policy" {
    for_each = var.dead_letter_topic != null ? [1] : []
    content {
      dead_letter_topic     = var.dead_letter_topic
      max_delivery_attempts = var.max_delivery_attempts
    }
  }

  filter = var.subscription_filter
}

# Grant subscriber permissions to the service account (GKE mode only)
resource "google_pubsub_subscription_iam_binding" "consumer_subscriber" {
  count        = local.deploy_k8s ? 1 : 0
  project      = var.project_id
  subscription = google_pubsub_subscription.exit_consumer[0].name
  role         = "roles/pubsub.subscriber"
  members      = ["serviceAccount:${local.consumer_service_account}"]
}

resource "google_pubsub_subscription_iam_binding" "consumer_viewer" {
  count        = local.deploy_k8s ? 1 : 0
  project      = var.project_id
  subscription = google_pubsub_subscription.exit_consumer[0].name
  role         = "roles/pubsub.viewer"
  members      = ["serviceAccount:${local.consumer_service_account}"]
}

# GCS bucket for function source code
resource "google_storage_bucket" "function_source" {
  count   = local.deploy_cloud_function ? 1 : 0
  project = var.project_id
  name    = "${var.project_id}-${var.application}-${var.environment}-exit-function-source"

  location      = var.function_region
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}

# Package function source code
# Automatically detects changes and triggers redeployment via SHA256 hash
data "archive_file" "function_source" {
  count       = local.deploy_cloud_function ? 1 : 0
  type        = "zip"
  source_dir  = var.function_source_dir
  output_path = "${path.module}/.terraform/${var.application}-${var.environment}-exit-function.zip"
  excludes = [
    "__pycache__",
    "*.pyc",
    ".git",
    ".terraform",
    "*.md"
  ]
}

# Upload to GCS with hash in filename - when source changes, new object is created
resource "google_storage_bucket_object" "function_source" {
  count  = local.deploy_cloud_function ? 1 : 0
  name   = "${var.application}-${var.environment}-exit-function-${filesha256(data.archive_file.function_source[0].output_path)}.zip"
  bucket = google_storage_bucket.function_source[0].name
  source = data.archive_file.function_source[0].output_path

  content_type = "application/zip"
}

# Cloud Function
resource "google_cloudfunctions2_function" "exit_consumer" {
  count    = local.deploy_cloud_function ? 1 : 0
  project  = var.project_id
  name     = local.function_name
  location = var.function_region

  description = var.function_description != null ? var.function_description : "Processes employee exit notifications for ${var.application} in ${var.environment}"

  build_config {
    runtime     = var.function_runtime
    entry_point = var.function_entry_point

    source {
      storage_source {
        bucket = google_storage_bucket.function_source[0].name
        object = google_storage_bucket_object.function_source[0].name
      }
    }
  }

  service_config {
    max_instance_count               = var.function_max_instances
    min_instance_count               = var.function_min_instances
    available_memory                 = var.function_memory
    timeout_seconds                  = var.function_timeout
    max_instance_request_concurrency = var.function_concurrency
    service_account_email            = google_service_account.consumer[0].email

    # Restrict to internal traffic only - no public HTTP access
    ingress_settings = "ALLOW_INTERNAL_ONLY"

    environment_variables = merge(
      {
        PROJECT_ID       = var.project_id
        APPLICATION_NAME = var.application
        ENVIRONMENT      = var.environment
      },
      var.function_environment_variables
    )

    dynamic "secret_environment_variables" {
      for_each = var.function_gsm_environment_variables
      content {
        key        = secret_environment_variables.key
        project_id = var.project_id
        secret     = secret_environment_variables.value.name
        version    = secret_environment_variables.value.version
      }
    }
  }

  event_trigger {
    trigger_region = var.function_region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = local.central_topic_id
    retry_policy   = var.function_retry_policy
  }
}

# Grant Cloud Run Invoker to Pub/Sub
resource "google_cloud_run_service_iam_binding" "function_invoker" {
  count    = local.deploy_cloud_function ? 1 : 0
  project  = google_cloudfunctions2_function.exit_consumer[0].project
  location = google_cloudfunctions2_function.exit_consumer[0].location
  service  = google_cloudfunctions2_function.exit_consumer[0].name
  role     = "roles/run.invoker"
  members  = ["serviceAccount:service-${data.google_project.project.number}@gcp-sa-pubsub.iam.gserviceaccount.com"]
}
