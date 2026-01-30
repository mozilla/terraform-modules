# module "tenant" {
#   source = "../../../modules/tenant"
#   # ... tenant configuration ...
# }

locals {
  dry_run      = "true"
  api_endpoint = "https://myapp.mozilla.com/api"
}

module "exit_consumer" {
  source = "github.com/mozilla/terraform-modules//mozilla_employee_exit_consumer?ref=main"

  project_id  = local.project_id
  application = local.application
  environment = local.environment

  # central_topic_id automatically retrieved from remote state
  # Override only for testing: central_topic_id = var.central_topic_id

  # Cloud Function configuration
  function_source_dir  = "${path.module}/src"
  function_entry_point = "process_exit"
  function_runtime     = "python312"
  function_region      = "us-west1"
  function_memory      = "512Mi"
  function_timeout     = 120

  # Example Environment variables for the function
  function_environment_variables = {
    DRY_RUN      = local.dry_run ? "true" : "false"
    API_ENDPOINT = local.api_endpoint
  }

  # Example: Expose a secret as an environment variable
  function_secret_environment_variables = [
    {
      key        = "DATABASE_PASSWORD"
      project_id = local.project_id
      secret     = google_secret_manager_secret.db_password.secret_id
      version    = "latest"
    }
  ]
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
  members   = ["serviceAccount:${module.exit_consumer.service_account_email}"]
}

# Outputs
output "function_url" {
  description = "URL of the deployed Cloud Function"
  value       = module.exit_consumer.function_url
}

output "service_account_email" {
  description = "Email of the service account"
  value       = module.exit_consumer.service_account_email
}
