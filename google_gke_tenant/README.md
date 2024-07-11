# Terraform Module: Google GKE tenant
Sets up a service account for use with GKE

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.0 |

## Modules

None

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment e.g., stage. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project_id](#input\_project\_id) | n/a | `string` | `null` | yes |
| <a name="input_application"></a> [application](#input\_application) | n/a | `string` | `null` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gke_service_account"></a> [gke\_service\_account](#output\_gke\_service\_account) | n/a |

