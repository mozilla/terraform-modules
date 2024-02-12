# Terraform Module: Service Accounts for deployment from GitHub Actions and CircleCI
Creates a Cloud IAM service account which lets CI workflows authenticate to GCP.

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
| [google_service_account_iam_binding.circleci-access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_service_account_iam_binding.github-actions-access](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | Name of the service account. Defaults to deploy-ENV. | `string` | `null` | no |
| <a name="input_circleci_attribute_specifiers"></a> [circleci\_attribute\_specifiers](#input\_circleci\_attribute\_specifiers) | (CircleCI only) Set of attribute specifiers to allow deploys from, in the form ATTR/ATTR\_VALUE. If specified, this overrides the github\_repository variable and any other CircleCI-specific variables. | `set(string)` | `[]` | no |
| <a name="input_circleci_branches"></a> [circleci\_branches](#input\_circleci\_branches) | (CircleCI only) Branches to allow deployments from. If unspecified, allow deployment from all branches. | `set(string)` | `[]` | no |
| <a name="input_circleci_context_ids"></a> [circleci\_context\_ids](#input\_circleci\_context\_ids) | (CircleCI only) Contexts to allow deployments from. Not recommended when using merge queues since CircleCI Contexts are only accessible to members of your organization. | `set(string)` | `[]` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for the service account. Defaults to "Deployment to the ENV environment". | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment e.g., stage. Not used for OIDC configuration in CircleCI. | `string` | n/a | yes |
| <a name="input_gha_environments"></a> [gha\_environments](#input\_gha\_environments) | Github environments from which to deploy. If specified, this overrides the environment variable. | `list(string)` | `[]` | no |
| <a name="input_github_repositories"></a> [github\_repositories](#input\_github\_repositories) | The Github repositories running the deployment workflows in the format org/repository, will be used if github\_repository is not defined. | `list(string)` | `[]` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | The Github repository running the deployment workflows in the format org/repository. Optional for CircleCI or when github\_repositories is specified. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `null` | no |
| <a name="input_wip_name"></a> [wip\_name](#input\_wip\_name) | The name of the workload identity provider. This value implicitly controls whether to provision access to github-actions or circleci. | `string` | `"github-actions"` | no |
| <a name="input_wip_project_number"></a> [wip\_project\_number](#input\_wip\_project\_number) | The project number of the project the workload identity provider lives in. | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | n/a |
