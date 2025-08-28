## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 6.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_component_code"></a> [component\_code](#input\_component\_code) | The component code for this infrastructure | `string` | `"notset"` | no |
| <a name="input_credentials"></a> [credentials](#input\_credentials) | Path to service account key file or JSON string | `string` | `null` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain name | `string` | `null` | no |
| <a name="input_env_code"></a> [env\_code](#input\_env\_code) | The environment code (e.g., dev, staging, prod) | `string` | `"notset"` | no |
| <a name="input_impersonate_service_account"></a> [impersonate\_service\_account](#input\_impersonate\_service\_account) | Service account to impersonate | `string` | `null` | no |
| <a name="input_override_current_tf_version"></a> [override\_current\_tf\_version](#input\_override\_current\_tf\_version) | Override the current Terraform version | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project ID | `string` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | The realm (e.g., sandbox, production) | `string` | `"notset"` | no |
| <a name="input_region"></a> [region](#input\_region) | The default GCP region | `string` | `"us-central1"` | no |
| <a name="input_system"></a> [system](#input\_system) | The system/application name | `string` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | The default GCP zone | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_labels"></a> [default\_labels](#output\_default\_labels) | The computed default labels applied to all resources |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The configured GCP project ID |
| <a name="output_region"></a> [region](#output\_region) | The configured GCP region |
| <a name="output_zone"></a> [zone](#output\_zone) | The configured GCP zone |
