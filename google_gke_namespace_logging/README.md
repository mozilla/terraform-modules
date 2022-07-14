# Terraform Module: GKE Tenant Namepsace Logging
Creates a logging bucket and grants access to the logging service account so that
GKE Logs associated with the tenant namespace are available in the tenant project.
The log routing configuration happens as part of the GKE tenant bootstrapping.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_logging_project_bucket_config.namespace](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_project_bucket_config) | resource |
| [google_project_iam_member.logging_bucket_writer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application, e.g. bouncer. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. dev, stage, prod | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the logging bucket. Supported regions https://cloud.google.com/logging/docs/region-support#bucket-regions | `string` | `"global"` | no |
| <a name="input_logging_writer_service_account_member"></a> [logging\_writer\_service\_account\_member](#input\_logging\_writer\_service\_account\_member) | The unique\_writer\_identity service account that is provisioned when creating a Logging Sink | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `null` | no |
| <a name="input_retention_days"></a> [retention\_days](#input\_retention\_days) | Log retention for logs, values between 1 and 3650 days | `number` | `30` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logging_bucket_id"></a> [logging\_bucket\_id](#output\_logging\_bucket\_id) | n/a |
