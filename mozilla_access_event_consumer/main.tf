/**
 * # Mozilla Access Event Consumer Module
 *
 * This Terraform module creates the infrastructure needed for a tenant application to consume access event notifications from a centrally-managed Pub/Sub topic.
 *
 * ## Deployment Modes
 *
 * 1. **Cloud Function Mode** automatically triggered by Pub/Sub events
 * - Prefer **Cloud Functions** if you don't have GKE resources or in cases where your access event flows don't have any dependencies on your tenant's GKE resources
 * 2. **GKE Mode** to pull messages from your tenant GKE setup
 * - Use **GKE Mode** if you prefer to manage your access event logic along with the rest of your application and GKE deployment
 *
 * ## Message Format
 *
 * Access event messages have this structure:
 *
 * ```json
 * {
 *   "event_type": "employee_exit",
 *   "event_time": "2026-01-26T00:00:00Z",
 *   "employee_email": "user@mozilla.com",
 *   "employee_name": "Jane Doe",
 *   "publish_time": "2026-01-28T19:02:25.123456Z",
 *   "event_data": {
 *     "manager_name": "Jane Manager",
 *     "manager_email": "jmanager@mozilla.com"
 *   }
 * }
 * ```
 *
 * ## IAM Role Management
 *
 * **Cloud Function mode (push subscription):**
 *
 * The module creates two service accounts:
 * - **Consumer SA** (`{app}-{env}-access`) - SA the Cloud Function runs as
 * - **Build SA** (`{app}-{env}-access-build`) - SA used by Cloud Build to build the Cloud Function artifact
 *
 * Consumer SA permissions (resource-level):
 * - `roles/run.invoker` on the Cloud Run service to allow Pub/Sub to invoke the function
 * - `roles/iam.serviceAccountTokenCreator` on the consumer SA to allow the Pub/Sub service agent to mint OIDC tokens for authenticated push delivery
 *
 * Build SA permissions (project-level, noncanonical via `google_project_iam_member`):
 * - `CloudFunctionBuilder` (org custom role) - grants the subset of `roles/logging.logWriter`, `roles/storage.objectViewer`, and `roles/artifactregistry.writer` permissions needed to build Cloud Function artifacts
 *
 * **GKE mode (pull subscription):**
 * - `roles/pubsub.subscriber` - To pull messages from the subscription
 * - `roles/pubsub.viewer` - To view subscription metadata
 *
 * **Additional IAM roles you must manage:**
 * - `roles/secretmanager.secretAccessor` - Required for each GSM resource referenced in `function_gsm_environment_variables`
 * - Database access roles (e.g., Cloud SQL, Firestore)
 * - Any other application-specific permissions
 *
 * Use the `service_account_email` output to grant these permissions in your own Terraform code.
 */

locals {
  central_topic_id = coalesce(var.central_topic_id, data.terraform_remote_state.global_shared[0].outputs.access_events_topic_id)

  subscription_name = coalesce(var.subscription_name, "${var.application}-${var.environment}-access-events")
  function_name     = coalesce(var.function_name, "${var.application}-${var.environment}-access-event-processor")

  deploy_cloud_function = var.function_source_dir != null

  # For Cloud Functions: use the function's service account
  # For GKE: use the provided service account email
  consumer_service_account = local.deploy_cloud_function ? google_service_account.consumer[0].email : var.service_account_email
}

# Service Account for the Cloud Function (only created if deploying Cloud Function)
resource "google_service_account" "consumer" {
  count   = local.deploy_cloud_function ? 1 : 0
  project = var.project_id

  # max 30 characters so truncate if necessary
  account_id   = coalesce(var.service_account_name, "${substr("${var.application}-${var.environment}", 0, min(23, length("${var.application}-${var.environment}")))}-access")
  display_name = coalesce(var.service_account_display_name, "${var.application} ${var.environment} access")
  description  = "Service account for processing access event notifications via Cloud Function in ${var.environment}"
}

resource "google_service_account" "builder" {
  count   = local.deploy_cloud_function ? 1 : 0
  project = var.project_id

  # max 30 characters so truncate if necessary
  account_id   = "${substr("${var.application}-${var.environment}", 0, min(17, length("${var.application}-${var.environment}")))}-access-build"
  display_name = "${var.application} ${var.environment} access build"
  description  = "Service account for building Cloud Function artifacts for ${var.application} in ${var.environment}"
}

resource "google_project_iam_member" "builder" {
  count   = local.deploy_cloud_function ? 1 : 0
  project = var.project_id
  role    = data.terraform_remote_state.org[0].outputs.iam_custom_roles["CloudFunctionBuilder"]
  member  = "serviceAccount:${google_service_account.builder[0].email}"
}

# Pub/Sub Subscription
# In Cloud Function mode: push subscription delivers messages to the function's HTTP endpoint
# In GKE mode: pull subscription for the GKE workload to consume
resource "google_pubsub_subscription" "access_consumer" {
  project = var.project_id
  name    = local.subscription_name
  topic   = local.central_topic_id

  lifecycle {
    precondition {
      condition     = var.function_source_dir != null || (var.service_account_email != null && var.service_account_email != "")
      error_message = "Either function_source_dir (for Cloud Function mode) or service_account_email (for GKE mode) must be provided."
    }
  }

  message_retention_duration = var.message_retention_duration
  ack_deadline_seconds       = var.ack_deadline_seconds

  retry_policy {
    minimum_backoff = var.retry_minimum_backoff
    maximum_backoff = var.retry_maximum_backoff
  }

  dynamic "push_config" {
    for_each = local.deploy_cloud_function ? [1] : []
    content {
      push_endpoint = google_cloudfunctions2_function.access_consumer[0].service_config[0].uri
      oidc_token {
        service_account_email = google_service_account.consumer[0].email
      }
    }
  }

  expiration_policy {
    ttl = ""
  }

  filter = var.subscription_filter
}

# Grant subscriber permissions to the service account in GKE mode onl since
# push subscriptions use OIDC, see below
resource "google_pubsub_subscription_iam_binding" "consumer_subscriber" {
  count        = local.deploy_cloud_function ? 0 : 1
  project      = var.project_id
  subscription = google_pubsub_subscription.access_consumer.name
  role         = "roles/pubsub.subscriber"
  members      = ["serviceAccount:${local.consumer_service_account}"]
}

resource "google_pubsub_subscription_iam_binding" "consumer_viewer" {
  count        = local.deploy_cloud_function ? 0 : 1
  project      = var.project_id
  subscription = google_pubsub_subscription.access_consumer.name
  role         = "roles/pubsub.viewer"
  members      = ["serviceAccount:${local.consumer_service_account}"]
}

# GCS bucket for function source code
resource "google_storage_bucket" "function_source" {
  count   = local.deploy_cloud_function ? 1 : 0
  project = var.project_id
  # max 63 characters so truncate if necessary
  name = "${substr("${var.project_id}-${var.application}-${var.environment}", 0, 48)}-access-fn-src"

  location      = var.function_region
  storage_class = "STANDARD"

  # Make deleting the bucket during
  # https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/870645965/Deleting+a+Tenant+Project easier
  force_destroy               = true
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
}

# Package function source code
# Automatically detects changes and triggers redeployment via SHA256 hash
data "archive_file" "function_source" {
  count       = local.deploy_cloud_function ? 1 : 0
  type        = "zip"
  source_dir  = var.function_source_dir
  output_path = "${path.root}/.terraform/tmp/${var.application}-${var.environment}-access-function.zip"
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
  name   = "${var.application}-${var.environment}-access-function-${data.archive_file.function_source[0].output_sha256}.zip"
  bucket = google_storage_bucket.function_source[0].name
  source = data.archive_file.function_source[0].output_path

  content_type = "application/zip"
}

# Cloud Function
resource "google_cloudfunctions2_function" "access_consumer" {
  count    = local.deploy_cloud_function ? 1 : 0
  project  = var.project_id
  name     = local.function_name
  location = var.function_region

  description = coalesce(var.function_description, "Processes access event notifications for ${var.application} in ${var.environment}")

  depends_on = [google_project_iam_member.builder]

  build_config {
    runtime         = var.function_runtime
    entry_point     = var.function_entry_point
    service_account = google_service_account.builder[0].id

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
}

# Grant Cloud Run Invoker to Pub/Sub service agent
# Required for Pub/Sub push subscriptions to invoke the Cloud Run service backing the function
resource "google_cloud_run_service_iam_binding" "function_invoker" {
  count    = local.deploy_cloud_function ? 1 : 0
  project  = google_cloudfunctions2_function.access_consumer[0].project
  location = google_cloudfunctions2_function.access_consumer[0].location
  service  = google_cloudfunctions2_function.access_consumer[0].name
  role     = "roles/run.invoker"
  members  = ["serviceAccount:${google_service_account.consumer[0].email}"]
}

# Grant Token Creator to Pub/Sub service agent on the consumer service account
# Required for Pub/Sub to mint OIDC tokens for authenticated push delivery
resource "google_service_account_iam_binding" "pubsub_token_creator" {
  count              = local.deploy_cloud_function ? 1 : 0
  service_account_id = google_service_account.consumer[0].name
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = ["serviceAccount:service-${data.google_project.project[0].number}@gcp-sa-pubsub.iam.gserviceaccount.com"]
}
