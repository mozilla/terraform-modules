<!-- BEGIN_TF_DOCS -->
# Mozilla Access Event Consumer Module

This Terraform module creates the infrastructure needed for a tenant application to consume access event notifications from a centrally-managed Pub/Sub topic.

## Deployment Modes

1. **Cloud Function Mode** automatically triggered by Pub/Sub events
- Prefer **Cloud Functions** if you don't have GKE resources or in cases where your access event flows don't have any dependencies on your tenant's GKE resources
2. **GKE Mode** to pull messages from your tenant GKE setup
- Use **GKE Mode** if you prefer to manage your access event logic along with the rest of your application and GKE deployment

## Message Format

Access event messages have this structure:

```json
{
  "event_type": "employee_exit",
  "event_time": "2026-01-26T00:00:00Z",
  "employee_email": "user@mozilla.com",
  "employee_name": "Jane Doe",
  "publish_time": "2026-01-28T19:02:25.123456Z",
  "event_data": {
    "manager_name": "Jane Manager",
    "manager_email": "jmanager@mozilla.com"
  }
}
```

## IAM Role Management

**Cloud Function mode (push subscription):**

The module creates two service accounts:
- **Consumer SA** (`{app}-{env}-access`) - SA the Cloud Function runs as
- **Build SA** (`{app}-{env}-access-build`) - SA used by Cloud Build to build the Cloud Function artifact

Consumer SA permissions (resource-level):
- `roles/run.invoker` on the Cloud Run service to allow Pub/Sub to invoke the function
- `roles/iam.serviceAccountTokenCreator` on the consumer SA to allow the Pub/Sub service agent to mint OIDC tokens for authenticated push delivery

Build SA permissions (project-level, noncanonical via `google_project_iam_member`):
- `CloudFunctionBuilder` (org custom role) - grants the subset of `roles/logging.logWriter`, `roles/storage.objectViewer`, and `roles/artifactregistry.writer` permissions needed to build Cloud Function artifacts

**GKE mode (pull subscription):**
- `roles/pubsub.subscriber` - To pull messages from the subscription
- `roles/pubsub.viewer` - To view subscription metadata

**Additional IAM roles you must manage:**
- `roles/secretmanager.secretAccessor` - Required for each GSM resource referenced in `function_gsm_environment_variables`
- Database access roles (e.g., Cloud SQL, Firestore)
- Any other application-specific permissions

Use the `service_account_email` output to grant these permissions in your own Terraform code.

## Cloud Function Example

Full source: [examples/cloudfunction](examples/cloudfunction)

### Prerequisites

The following APIs must be enabled in your project:

- `cloudbuild.googleapis.com`
- `cloudfunctions.googleapis.com`
- `run.googleapis.com`

These should be specified in e.g. `webservices-infra/projects/tf/global/locals.tf` for your projects.

Deploy a Cloud Function that processes Pub/Sub events via push subscription:

```hcl
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
```

## GKE Example

Full source: [examples/gke](examples/gke)

Create a Pub/Sub subscription for pull-based processing from GKE:

```hcl
# module "tenant" {
#   source = "../../../modules/tenant"
#   # ... tenant configuration ...
# }

module "access_consumer" {
  # Use the latest version of this module from https://github.com/mozilla/terraform-modules/tags
  source = "github.com/mozilla/terraform-modules//mozilla_access_event_consumer?ref=main"

  project_id            = local.project_id
  application           = local.application
  environment           = local.environment
  service_account_email = module.tenant.gke_service_account_email
}

# The module only creates the Pub/Sub subscription.
# You must deploy the Kubernetes workload separately.
# See the k8s/ directory for an example manifest.
output "pubsub_subscription_id" {
  value = module.access_consumer.subscription_id
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ack_deadline_seconds"></a> [ack\_deadline\_seconds](#input\_ack\_deadline\_seconds) | Maximum time after a subscriber receives a message before the subscriber should acknowledge | `number` | `300` | no |
| <a name="input_application"></a> [application](#input\_application) | Name of the application consuming access event notifications (used for resource naming) | `string` | n/a | yes |
| <a name="input_central_topic_id"></a> [central\_topic\_id](#input\_central\_topic\_id) | Full resource ID of the central access event topic. Automatically retrieved from remote state. Only override for testing purposes | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name. Used to differentiate resources when deploying multiple environments in the same project | `string` | n/a | yes |
| <a name="input_function_concurrency"></a> [function\_concurrency](#input\_function\_concurrency) | Maximum concurrent requests per instance | `number` | `1` | no |
| <a name="input_function_description"></a> [function\_description](#input\_function\_description) | Description of the Cloud Function | `string` | `null` | no |
| <a name="input_function_entry_point"></a> [function\_entry\_point](#input\_function\_entry\_point) | Entry point function name | `string` | `"process_access_event"` | no |
| <a name="input_function_environment_variables"></a> [function\_environment\_variables](#input\_function\_environment\_variables) | Environment variables for the Cloud Function | `map(string)` | `{}` | no |
| <a name="input_function_gsm_environment_variables"></a> [function\_gsm\_environment\_variables](#input\_function\_gsm\_environment\_variables) | Map of environment variable name to version e.g. {name = GSM\_resource\_name, version = 'latest'}. The consumer is responsible for granting the service account access via roles/secretmanager.secretAccessor | <pre>map(object({<br/>    name    = string<br/>    version = string<br/>  }))</pre> | `{}` | no |
| <a name="input_function_max_instances"></a> [function\_max\_instances](#input\_function\_max\_instances) | Maximum number of function instances | `number` | `10` | no |
| <a name="input_function_memory"></a> [function\_memory](#input\_function\_memory) | Memory allocated to the function | `string` | `"256Mi"` | no |
| <a name="input_function_min_instances"></a> [function\_min\_instances](#input\_function\_min\_instances) | Minimum number of function instances | `number` | `0` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Cloud Function, defaults to {application}-{environment}-access-event-processor | `string` | `null` | no |
| <a name="input_function_region"></a> [function\_region](#input\_function\_region) | GCP region for the Cloud Function, see https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/1286176831/GCP+Regions | `string` | `"us-west1"` | no |
| <a name="input_function_runtime"></a> [function\_runtime](#input\_function\_runtime) | Runtime for the Cloud Function e.g., python314, nodejs20 | `string` | `"python314"` | no |
| <a name="input_function_source_dir"></a> [function\_source\_dir](#input\_function\_source\_dir) | Path to the directory containing Cloud Function source code. If provided, deploys a Cloud Function. If not specified, only creates a subscription for GKE usage | `string` | `null` | no |
| <a name="input_function_timeout"></a> [function\_timeout](#input\_function\_timeout) | Function timeout in seconds | `number` | `60` | no |
| <a name="input_message_retention_duration"></a> [message\_retention\_duration](#input\_message\_retention\_duration) | How long to retain unacknowledged messages, default 7 days | `string` | `"604800s"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID where the consumer resources will be created | `string` | n/a | yes |
| <a name="input_retry_maximum_backoff"></a> [retry\_maximum\_backoff](#input\_retry\_maximum\_backoff) | Maximum delay between retry attempts | `string` | `"600s"` | no |
| <a name="input_retry_minimum_backoff"></a> [retry\_minimum\_backoff](#input\_retry\_minimum\_backoff) | Minimum delay between retry attempts | `string` | `"10s"` | no |
| <a name="input_service_account_display_name"></a> [service\_account\_display\_name](#input\_service\_account\_display\_name) | Display name for the service account | `string` | `null` | no |
| <a name="input_service_account_email"></a> [service\_account\_email](#input\_service\_account\_email) | Service account email to use instead of creating one. Required for GKE mode with GKE Workload Identity (e.g., gke-prod@project.iam.gserviceaccount.com). Only used if function\_source\_dir is null | `string` | `null` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Service account ID, defaults to {application}-{environment}-access | `string` | `null` | no |
| <a name="input_subscription_filter"></a> [subscription\_filter](#input\_subscription\_filter) | Filter expression for the subscription e.g., 'attributes.event\_type = "employee\_exit"' | `string` | `null` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | Name of the Pub/Sub subscription, defaults to {application}-{environment}-access-events | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_url"></a> [function\_url](#output\_function\_url) | URL of the Cloud Function (null if using GKE mode) |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | Email of the service account used by the consumer. Returns the created service account in Cloud Function mode, or the provided service\_account\_email in GKE mode. |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | Full resource path of the Pub/Sub subscription |
<!-- END_TF_DOCS -->
