# Terraform Module: GKE Tenant Namepsace Logging
Creates a logging bucket and grants access to the logging service account so that
GKE Logs associated with the tenant namespace are available in the tenant project.
The log routing configuration happens as part of the GKE tenant bootstrapping.
## Example
```hcl
module "gke_logging" {
  source = "github.com/mozilla/terraform-modules//google_gke_namespace_logging?ref=main"

  application                           = "glonk"
  realm                                 = "dev"
  logging_writer_service_account_member = "serviceAccount:test@gcp-sa-logging.iam.gserviceaccount.com"
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application, e.g. bouncer. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. dev, stage, prod | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location of the logging bucket. Supported regions https://cloud.google.com/logging/docs/region-support#bucket-regions | `string` | `"global"` | no |
| <a name="input_log_analytics"></a> [log\_analytics](#input\_log\_analytics) | Enable log analytics for log bucket | `bool` | `false` | no |
| <a name="input_log_destination"></a> [log\_destination](#input\_log\_destination) | Destination for tenant application logs. Can be bucket or bigquery | `string` | `"bucket"` | no |
| <a name="input_logging_writer_service_account_member"></a> [logging\_writer\_service\_account\_member](#input\_logging\_writer\_service\_account\_member) | The unique\_writer\_identity service account that is provisioned when creating a Logging Sink | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `null` | no |
| <a name="input_retention_days"></a> [retention\_days](#input\_retention\_days) | Log retention for logs, values between 1 and 3650 days | `number` | `90` | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_logging_bucket_id"></a> [logging\_bucket\_id](#output\_logging\_bucket\_id) | n/a |
| <a name="output_logging_dataset_id"></a> [logging\_dataset\_id](#output\_logging\_dataset\_id) | n/a |%
