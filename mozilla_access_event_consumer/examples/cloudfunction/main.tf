# module "tenant" {
#   source = "../../../modules/tenant"
#   # ... tenant configuration ...
# }

locals {
  dry_run = true
}

module "access_consumer" {
  # Use the latest version of this module from https://github.com/mozilla/terraform-modules/tags
  source = "github.com/mozilla/terraform-modules//mozilla_access_event_consumer?ref=main"

  project_id  = local.project_id
  application = local.application
  environment = local.environment

  # Cloud Function configuration
  function_source_dir  = "${path.module}/src"
  function_entry_point = "process_access_event"
  function_runtime     = "python312"
  function_region      = "us-west1"
  function_memory      = "512Mi"
  function_timeout     = 120

  function_environment_variables = {
    DRY_RUN = local.dry_run ? "true" : "false"
  }

  # Example: Expose a secret as an environment variable
  function_gsm_environment_variables = {
    DATABASE_PASSWORD = {
      name    = google_secret_manager_secret.db_password.secret_id
      version = "latest"
    }
  }
}

# Example secret
resource "google_secret_manager_secret" "db_password" {
  secret_id = "db-password-secret" # pragma: allowlist secret

  replication {
    auto {}
  }
}

# Store the secret value
resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = "{}"
}

# Grant the Cloud Function's service account access to the secret
resource "google_secret_manager_secret_iam_binding" "function_access" {
  project   = local.project_id
  secret_id = google_secret_manager_secret.db_password.secret_id
  role      = "roles/secretmanager.secretAccessor"
  members   = ["serviceAccount:${module.access_consumer.service_account_email}"]
}

# Outputs
output "function_url" {
  description = "URL of the deployed Cloud Function"
  value       = module.access_consumer.function_url
}

output "subscription_id" {
  description = "Full resource path of the Pub/Sub push subscription"
  value       = module.access_consumer.subscription_id
}

output "service_account_email" {
  description = "Email of the service account"
  value       = module.access_consumer.service_account_email
}
