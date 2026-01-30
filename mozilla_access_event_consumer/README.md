<!-- BEGIN_TF_DOCS -->
# Mozilla Access Event Consumer Module

This Terraform module creates the infrastructure needed for a tenant application to consume access event notifications from a centrally-managed Pub/Sub topic. It supports both Cloud Functions and GKE.

## Deployment Modes

1. **Cloud Function Mode** automatically triggered by Pub/Sub events
- Prefer **Cloud Functions** if you don't have GKE resources or in cases where your exit flows don't have any dependencies on your tenant's GKE resources
2. **GKE Mode**  Pull messages from your tenant GKE setup
- Use **GKE** if you prefer to manage your exit logic along with the rest of your application and GKE deployment

## Usage

### Cloud Function Mode

Deploy a Cloud Function that uses [Eventarc](https://docs.cloud.google.com/run/docs/tutorials/pubsub-eventdriven) to handle Pub/Sub events:

```hcl
module "exit_consumer" {
  # see https://github.com/mozilla/terraform-modules?tab=readme-ov-file#using-these-modules for versioning strategies
  source = "github.com/mozilla/terraform-modules//mozilla_access_event_consumer?ref=main"

  project_id          = local.project_id
  application         = local.application
  environment         = local.environment
  function_source_dir = "${path.module}/exit-processor"
}
```

### GKE Mode

Create a Pub/Sub subscription for pull-based processing from GKE:

```hcl
module "exit_consumer" {
  # see https://github.com/mozilla/terraform-modules?tab=readme-ov-file#using-these-modules for versioning strategies
  source = "github.com/mozilla/terraform-modules//mozilla_access_event_consumer?ref=main"

  project_id  = local.project_id
  application = local.application
  environment = local.environment

  # Provide GKE service account for GKE mode
  service_account = module.tenant.gke_service_account_email
}
```

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
    "manager_email": "manager@mozilla.com"
  }
}
```

**Field Descriptions:**
- `event_type` (string, required): Type of access event. Currently supports `"employee_exit"`.
- `event_time` (string, nullable): ISO 8601 timestamp of when the event occurred.
- `employee_email` (string, nullable): Email address of the employee.
- `employee_name` (string, nullable): Full name of the employee.
- `publish_time` (string, required): ISO 8601 timestamp of when the message was published.
- `event_data` (object, nullable): Event-specific data. For `employee_exit` events, contains:
  - `manager_name` (string): Name of the employee's manager.
  - `manager_email` (string): Email address of the employee's manager.

## IAM Role Management

The module creates a service account (in Cloud Function mode) or uses your GKE service account (in GKE mode) and grants minimal permissions:

**Cloud Function mode (Eventarc):**
- `roles/run.invoker` - Allows Pub/Sub service agent to invoke the function
- Eventarc automatically manages subscription and permissions

**GKE mode (manual subscription):**
- `roles/pubsub.subscriber` - To pull messages from the subscription
- `roles/pubsub.viewer` - To view subscription metadata

**Additional IAM roles you must manage:**
- `roles/secretmanager.secretAccessor` - Required for each GSM resource referenced in `function_gsm_environment_variables`
- Database access roles (e.g., Cloud SQL, Firestore)
- Any other application-specific permissions

Use the `service_account_email` output to grant these permissions in your own Terraform code.

## Examples

See the [examples/](./examples/) directory for examples:

- **[examples/cloudfunction/](./examples/cloudfunction/)** - Cloud Function with secrets
- **[examples/gke/](./examples/gke/)** - GKE with batch processing

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | >= 2.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | >= 2.0 |
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Name of the application consuming exit notifications (used for resource naming) | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name. Used to differentiate resources when deploying multiple environments in the same project. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID where the consumer resources will be created | `string` | n/a | yes |
| <a name="input_ack_deadline_seconds"></a> [ack\_deadline\_seconds](#input\_ack\_deadline\_seconds) | Maximum time after a subscriber receives a message before the subscriber should acknowledge | `number` | `300` | no |
| <a name="input_central_topic_id"></a> [central\_topic\_id](#input\_central\_topic\_id) | Full resource ID of the central employee exit topic. Automatically retrieved from remote state. Only override for testing purposes. | `string` | `null` | no |
| <a name="input_dead_letter_topic"></a> [dead\_letter\_topic](#input\_dead\_letter\_topic) | Pub/Sub topic for dead letter messages (optional) | `string` | `null` | no |
| <a name="input_function_concurrency"></a> [function\_concurrency](#input\_function\_concurrency) | Maximum concurrent requests per instance | `number` | `1` | no |
| <a name="input_function_description"></a> [function\_description](#input\_function\_description) | Description of the Cloud Function | `string` | `null` | no |
| <a name="input_function_entry_point"></a> [function\_entry\_point](#input\_function\_entry\_point) | Entry point function name | `string` | `"process_exit"` | no |
| <a name="input_function_environment_variables"></a> [function\_environment\_variables](#input\_function\_environment\_variables) | Environment variables for the Cloud Function | `map(string)` | `{}` | no |
| <a name="input_function_gsm_environment_variables"></a> [function\_gsm\_environment\_variables](#input\_function\_gsm\_environment\_variables) | Environment variables sourced from Google Secret Manager for the Cloud Function. References existing GSM resources. The consumer is responsible for granting the service account access via roles/secretmanager.secretAccessor. Map of environment variable name to {name = GSM resource name, version = 'latest' or version number} | <pre>map(object({<br/>    name    = string<br/>    version = string<br/>  }))</pre> | `{}` | no |
| <a name="input_function_max_instances"></a> [function\_max\_instances](#input\_function\_max\_instances) | Maximum number of function instances | `number` | `10` | no |
| <a name="input_function_memory"></a> [function\_memory](#input\_function\_memory) | Memory allocated to the function | `string` | `"256Mi"` | no |
| <a name="input_function_min_instances"></a> [function\_min\_instances](#input\_function\_min\_instances) | Minimum number of function instances | `number` | `0` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Cloud Function (defaults to {application}-{environment}-exit-processor) | `string` | `null` | no |
| <a name="input_function_region"></a> [function\_region](#input\_function\_region) | GCP region for the Cloud Function, see https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/1286176831/GCP+Regions | `string` | `"us-west1"` | no |
| <a name="input_function_retry_policy"></a> [function\_retry\_policy](#input\_function\_retry\_policy) | Retry policy for the event trigger (RETRY\_POLICY\_RETRY or RETRY\_POLICY\_DO\_NOT\_RETRY) | `string` | `"RETRY_POLICY_RETRY"` | no |
| <a name="input_function_runtime"></a> [function\_runtime](#input\_function\_runtime) | Runtime for the Cloud Function (e.g., python312, nodejs20) | `string` | `"python312"` | no |
| <a name="input_function_source_dir"></a> [function\_source\_dir](#input\_function\_source\_dir) | Path to the directory containing Cloud Function source code. If provided, deploys a Cloud Function. If not specified, only creates a subscription for GKE usage. | `string` | `null` | no |
| <a name="input_function_timeout"></a> [function\_timeout](#input\_function\_timeout) | Function timeout in seconds | `number` | `60` | no |
| <a name="input_max_delivery_attempts"></a> [max\_delivery\_attempts](#input\_max\_delivery\_attempts) | Maximum number of delivery attempts for dead letter policy | `number` | `5` | no |
| <a name="input_message_retention_duration"></a> [message\_retention\_duration](#input\_message\_retention\_duration) | How long to retain unacknowledged messages (default: 7 days) | `string` | `"604800s"` | no |
| <a name="input_retry_maximum_backoff"></a> [retry\_maximum\_backoff](#input\_retry\_maximum\_backoff) | Maximum delay between retry attempts | `string` | `"600s"` | no |
| <a name="input_retry_minimum_backoff"></a> [retry\_minimum\_backoff](#input\_retry\_minimum\_backoff) | Minimum delay between retry attempts | `string` | `"10s"` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | Service account email to use instead of creating one. Required for GKE mode with GKE Workload Identity (e.g., gke-prod@project.iam.gserviceaccount.com). Only used if function\_source\_dir is null. | `string` | `null` | no |
| <a name="input_service_account_display_name"></a> [service\_account\_display\_name](#input\_service\_account\_display\_name) | Display name for the service account | `string` | `null` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | Service account ID (defaults to {application}-{environment}-exit) | `string` | `null` | no |
| <a name="input_subscription_filter"></a> [subscription\_filter](#input\_subscription\_filter) | Filter expression for the subscription (e.g., 'attributes.notification\_type = "exit"') | `string` | `null` | no |
| <a name="input_subscription_name"></a> [subscription\_name](#input\_subscription\_name) | Name of the Pub/Sub subscription (defaults to {application}-{environment}-employee-exits) | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_url"></a> [function\_url](#output\_function\_url) | URL of the Cloud Function (null if using GKE mode) |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | Email of the service account created for the Cloud Function. Use this to grant IAM permissions for secrets, databases, and other resources (null if using GKE mode) |
| <a name="output_subscription_id"></a> [subscription\_id](#output\_subscription\_id) | Full resource path of the Pub/Sub subscription (null if using Cloud Function mode with Eventarc) |
<!-- END_TF_DOCS -->