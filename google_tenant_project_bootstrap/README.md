<!-- BEGIN_TF_DOCS -->
# Terraform Module: Tenant project bootstrapping
Calls submodules to bootstrap a tenant project

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | The name of the application. | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment to create (like, 'dev', 'stage', or 'prod') | `string` | `null` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | The Github repository running the deployment workflows in the format org/repository | `string` | n/a | yes |
| <a name="input_gke_cluster_project_id"></a> [gke\_cluster\_project\_id](#input\_gke\_cluster\_project\_id) | The project ID for the GKE cluster this app uses | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | The project ID in which we're doing this work. | `string` | `null` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | Name of infrastructure realm (e.g. prod, nonprod, mgmt, or global). | `string` | n/a | yes |
| <a name="input_wip_name"></a> [wip\_name](#input\_wip\_name) | The name of the workload identity provider | `string` | `"github-actions"` | no |
| <a name="input_wip_project_number"></a> [wip\_project\_number](#input\_wip\_project\_number) | The project number of the project the workload identity provider lives in | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deploy_service_account"></a> [deploy\_service\_account](#output\_deploy\_service\_account) | n/a |
| <a name="output_gar_repository"></a> [gar\_repository](#output\_gar\_repository) | n/a |
| <a name="output_gar_service_account"></a> [gar\_service\_account](#output\_gar\_service\_account) | n/a |
| <a name="output_gke_service_account"></a> [gke\_service\_account](#output\_gke\_service\_account) | n/a |
<!-- END_TF_DOCS -->
