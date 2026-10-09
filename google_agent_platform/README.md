

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | The name of the application (tenant app\_code). | `string` | n/a | yes |
| <a name="input_caller_repositories"></a> [caller\_repositories](#input\_caller\_repositories) | GitHub repositories, in org/repository format, that invoke agents from CI without deploying them. | `list(string)` | `[]` | no |
| <a name="input_create_runtime_service_account"></a> [create\_runtime\_service\_account](#input\_create\_runtime\_service\_account) | Create an agent-runtime service account for agents deployed with service\_account instead of Agent Identity. | `bool` | `false` | no |
| <a name="input_deploy_github_environment"></a> [deploy\_github\_environment](#input\_deploy\_github\_environment) | GitHub Actions environment a deploy job must run in to use the deployer service account.<br>Set this for prod. When null, any workflow in deploy\_repositories can deploy. | `string` | `null` | no |
| <a name="input_deploy_repositories"></a> [deploy\_repositories](#input\_deploy\_repositories) | GitHub repositories, in org/repository format, that can deploy agents to this environment. | `list(string)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment to create (like, 'dev', 'stage', or 'prod'). | `string` | n/a | yes |
| <a name="input_gcp_organization_id"></a> [gcp\_organization\_id](#input\_gcp\_organization\_id) | GCP organization ID, used in the Agent Identity principal. | `number` | `442341870013` | no |
| <a name="input_image_repository"></a> [image\_repository](#input\_image\_repository) | Artifact Registry repository the Reasoning Engine service agent pulls BYOC images from. Null skips the grant. | <pre>object({<br>    project  = string<br>    location = string<br>    name     = string<br>  })</pre> | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project the agents run in. | `string` | n/a | yes |
| <a name="input_secret_readers"></a> [secret\_readers](#input\_secret\_readers) | Extra members that can read the secrets bag, for example a workgroup in nonprod. | `list(string)` | `[]` | no |
| <a name="input_wip_name"></a> [wip\_name](#input\_wip\_name) | The name of the workload identity provider. | `string` | `"github-actions"` | no |
| <a name="input_wip_project_number"></a> [wip\_project\_number](#input\_wip\_project\_number) | The project number of the project the workload identity provider lives in. | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agent_identity_principal"></a> [agent\_identity\_principal](#output\_agent\_identity\_principal) | IAM member covering every Agent Identity agent in the project. Grant to it in other projects. |
| <a name="output_caller_service_account_email"></a> [caller\_service\_account\_email](#output\_caller\_service\_account\_email) | n/a |
| <a name="output_deployer_service_account_email"></a> [deployer\_service\_account\_email](#output\_deployer\_service\_account\_email) | n/a |
| <a name="output_runtime_service_account_email"></a> [runtime\_service\_account\_email](#output\_runtime\_service\_account\_email) | n/a |
| <a name="output_secret_id"></a> [secret\_id](#output\_secret\_id) | n/a |
