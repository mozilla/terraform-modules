# Terraform Module: Tenant project bootstrapping
Calls submodules to bootstrap a tenant project

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.0 |
| <a name="requirement_google_beta"></a> [google-beta](#requirement\_google\_beta) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.0 |
| <a name="provider_google_beta"></a> [google-beta](#provider\_google\_beta) | >= 4.0 |

## Modules

| Name |
|------|
| [google_gar](https://github.com/mozilla/terraform-modules/tree/main/google_gar) |
| [google_deployment_accounts](https://github.com/mozilla/terraform-modules/tree/main/google_deployment_accounts) |
| [google_gsm_for_gke](https://github.com/mozilla/terraform-modules/tree/main/google_gsm_for_gke) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment e.g., stage. | `string` | n/a | yes |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | The Github repository running the deployment workflows in the format org/repository | `string` | n/a | yes |
| <a name="input_wip_name"></a> [wip\_name](#input\_wip\_name) | The name of the workload identity provider | `string` | n/a | yes |
| <a name="input_wip_project_number"></a> [wip\_project\_number](#input\_wip\_project\_number) | The project number of the project the workload identity provider lives in | `number` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `null` | yes |
| <a name="input_application"></a> [application](#input\_application) | n/a | `string` | `null` | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | n/a | `string` | `null` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gke_service_account"></a> [gke\_service\_account](#output\_gke\_service\_account) | n/a |
| <a name="output_deploy_service_account"></a> [deploy\_service\_account](#output\_deploy\_service\_account) | n/a |
| <a name="output_gar_service_account"></a> [gar\_service\_account](#output\_gar\_service\_account) | n/a |
| <a name="output_gar_repository"></a> [gar\_repository](#output\_gar\_repository) | n/a |

