# Terraform Module: Service Accounts for deployment from GitHub Actions
Creates a Cloud IAM service accounts which let GitHub Actions workflows authenticate to GKE.

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

No modules.

## Resources

| Name | Type |
|------|------|
| [google_service_account.account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_binding.github-actions-access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Name of the service account. Defaults to deploy-<env> | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment e.g., stage. | `string` | n/a | yes |
| <a name="input_gha_environments"></a> [gha\_environments](#input\_gha\_environments) | Github environments from which to deploy. If specified, this overrides the environment variable. | `list(string)` | `[]` | no |
| <a name="input_github_repositories"></a> [github\_repositories](#input\_github\_repositories) | The Github repositories running the deployment workflows in the format org/repository, overwriting the github\_deployment variable | `list(string)` | `[]` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | The Github repository running the deployment workflows in the format org/repository | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `null` | no |
| <a name="input_wip_name"></a> [wip\_name](#input\_wip\_name) | The name of the workload identity provider | `string` | `"github-actions"` | no |
| <a name="input_wip_project_number"></a> [wip\_project\_number](#input\_wip\_project\_number) | The project number of the project the workload identity provider lives in | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | n/a |
