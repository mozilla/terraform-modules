
## Example
```hcl
module "tenant" {
  source             = "github.com/mozilla/terraform-modules//google_tenant_bootstrap?ref=google_tenant_bootstrap-0.1.0"
  application        = "testapp1"
  function           = "webservices"
  risk_level         = "high"
  realm              = "nonprod"
  environment        = "dev"
  github_repository  = "example-org/testapp1"
  wip_project_number = 123456789012
}

module "lightweight_tenant" {
  source                      = "github.com/mozilla/terraform-modules//google_tenant_bootstrap?ref=google_tenant_bootstrap-0.1.0"
  application                 = "testapp2"
  function                    = "aiservices"
  realm                       = "nonprod"
  environment                 = "dev"
  disable_shared_integrations = true
  github_build_repositories   = ["example-org/testapp2"]
  wip_project_number          = 123456789012
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application name (app\_code) | `string` | n/a | yes |
| <a name="input_circleci_build_repositories"></a> [circleci\_build\_repositories](#input\_circleci\_build\_repositories) | CircleCI repositories (org/repository) that push images | `list(string)` | `[]` | no |
| <a name="input_disable_shared_integrations"></a> [disable\_shared\_integrations](#input\_disable\_shared\_integrations) | Skip shared GKE resources. Set for lightweight tenants. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, such as dev, stage, or prod | `string` | n/a | yes |
| <a name="input_function"></a> [function](#input\_function) | Function: aiservices, dataservices, sandbox, or webservices | `string` | n/a | yes |
| <a name="input_gha_environments"></a> [gha\_environments](#input\_gha\_environments) | GitHub environments the deploy service account accepts. Overrides `environment`.<br>Prod deploys need a manual approval step. Do not use this to bypass it. | `list(string)` | `[]` | no |
| <a name="input_github_build_repositories"></a> [github\_build\_repositories](#input\_github\_build\_repositories) | GitHub repositories (org/repository) that push images. Overrides `github_repository` for<br>the artifact-writer service account. | `list(string)` | `[]` | no |
| <a name="input_github_deploy_repositories"></a> [github\_deploy\_repositories](#input\_github\_deploy\_repositories) | GitHub repositories (org/repository) that deploy. Overrides `github_repository` for the<br>deploy service account. | `list(string)` | `[]` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | GitHub repository (org/repository) that builds and deploys. `github_build_repositories`<br>and `github_deploy_repositories` override it. | `string` | `null` | no |
| <a name="input_github_require_build_env"></a> [github\_require\_build\_env](#input\_github\_require\_build\_env) | Require the GitHub Actions environment "build" to use the artifact-writer service account. | `bool` | `true` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Log retention in days | `number` | `90` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Tenant project ID | `string` | `null` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm: nonprod, prod, mgmt, or global | `string` | n/a | yes |
| <a name="input_risk_level"></a> [risk\_level](#input\_risk\_level) | Risk level, high or low. Required unless disable\_shared\_integrations is set. | `string` | `null` | no |
| <a name="input_wip_name"></a> [wip\_name](#input\_wip\_name) | Workload identity pool name | `string` | `"github-actions"` | no |
| <a name="input_wip_project_number"></a> [wip\_project\_number](#input\_wip\_project\_number) | Project number of the workload identity pool | `number` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deploy_service_account_email"></a> [deploy\_service\_account\_email](#output\_deploy\_service\_account\_email) | n/a |
| <a name="output_deploy_service_account_name"></a> [deploy\_service\_account\_name](#output\_deploy\_service\_account\_name) | n/a |
| <a name="output_gke_cluster_project_id"></a> [gke\_cluster\_project\_id](#output\_gke\_cluster\_project\_id) | n/a |
| <a name="output_gke_service_account_email"></a> [gke\_service\_account\_email](#output\_gke\_service\_account\_email) | n/a |
| <a name="output_gke_service_account_name"></a> [gke\_service\_account\_name](#output\_gke\_service\_account\_name) | n/a |
| <a name="output_internal_ips"></a> [internal\_ips](#output\_internal\_ips) | n/a |
| <a name="output_logging_bucket_id"></a> [logging\_bucket\_id](#output\_logging\_bucket\_id) | n/a |
| <a name="output_logging_bucket_linked_dataset_id"></a> [logging\_bucket\_linked\_dataset\_id](#output\_logging\_bucket\_linked\_dataset\_id) | n/a |
| <a name="output_logging_dataset_id"></a> [logging\_dataset\_id](#output\_logging\_dataset\_id) | n/a |
| <a name="output_network"></a> [network](#output\_network) | n/a |
| <a name="output_public_ips"></a> [public\_ips](#output\_public\_ips) | n/a |

<!-- BEGIN_TF_DOCS -->

## Example
```hcl
module "tenant" {
  source             = "github.com/mozilla/terraform-modules//google_tenant_bootstrap?ref=google_tenant_bootstrap-0.1.0"
  application        = "testapp1"
  function           = "webservices"
  risk_level         = "high"
  realm              = "nonprod"
  environment        = "dev"
  github_repository  = "example-org/testapp1"
  wip_project_number = 123456789012
}

module "lightweight_tenant" {
  source                      = "github.com/mozilla/terraform-modules//google_tenant_bootstrap?ref=google_tenant_bootstrap-0.1.0"
  application                 = "testapp2"
  function                    = "aiservices"
  realm                       = "nonprod"
  environment                 = "dev"
  disable_shared_integrations = true
  github_build_repositories   = ["example-org/testapp2"]
  wip_project_number          = 123456789012
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application name (app\_code) | `string` | n/a | yes |
| <a name="input_circleci_build_repositories"></a> [circleci\_build\_repositories](#input\_circleci\_build\_repositories) | CircleCI repositories (org/repository) that push images | `list(string)` | `[]` | no |
| <a name="input_disable_shared_integrations"></a> [disable\_shared\_integrations](#input\_disable\_shared\_integrations) | Skip shared GKE resources. Set for lightweight tenants. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, such as dev, stage, or prod | `string` | n/a | yes |
| <a name="input_function"></a> [function](#input\_function) | Function: aiservices, dataservices, sandbox, or webservices | `string` | n/a | yes |
| <a name="input_gha_environments"></a> [gha\_environments](#input\_gha\_environments) | GitHub environments the deploy service account accepts. Overrides `environment`.<br/>Prod deploys need a manual approval step. Do not use this to bypass it. | `list(string)` | `[]` | no |
| <a name="input_github_build_repositories"></a> [github\_build\_repositories](#input\_github\_build\_repositories) | GitHub repositories (org/repository) that push images. Overrides `github_repository` for<br/>the artifact-writer service account. | `list(string)` | `[]` | no |
| <a name="input_github_deploy_repositories"></a> [github\_deploy\_repositories](#input\_github\_deploy\_repositories) | GitHub repositories (org/repository) that deploy. Overrides `github_repository` for the<br/>deploy service account. | `list(string)` | `[]` | no |
| <a name="input_github_repository"></a> [github\_repository](#input\_github\_repository) | GitHub repository (org/repository) that builds and deploys. `github_build_repositories`<br/>and `github_deploy_repositories` override it. | `string` | `null` | no |
| <a name="input_github_require_build_env"></a> [github\_require\_build\_env](#input\_github\_require\_build\_env) | Require the GitHub Actions environment "build" to use the artifact-writer service account. | `bool` | `true` | no |
| <a name="input_log_retention_days"></a> [log\_retention\_days](#input\_log\_retention\_days) | Log retention in days | `number` | `90` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Tenant project ID | `string` | `null` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm: nonprod, prod, mgmt, or global | `string` | n/a | yes |
| <a name="input_risk_level"></a> [risk\_level](#input\_risk\_level) | Risk level, high or low. Required unless disable\_shared\_integrations is set. | `string` | `null` | no |
| <a name="input_wip_name"></a> [wip\_name](#input\_wip\_name) | Workload identity pool name | `string` | `"github-actions"` | no |
| <a name="input_wip_project_number"></a> [wip\_project\_number](#input\_wip\_project\_number) | Project number of the workload identity pool | `number` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deploy_service_account_email"></a> [deploy\_service\_account\_email](#output\_deploy\_service\_account\_email) | n/a |
| <a name="output_deploy_service_account_name"></a> [deploy\_service\_account\_name](#output\_deploy\_service\_account\_name) | n/a |
| <a name="output_gke_cluster_project_id"></a> [gke\_cluster\_project\_id](#output\_gke\_cluster\_project\_id) | n/a |
| <a name="output_gke_service_account_email"></a> [gke\_service\_account\_email](#output\_gke\_service\_account\_email) | n/a |
| <a name="output_gke_service_account_name"></a> [gke\_service\_account\_name](#output\_gke\_service\_account\_name) | n/a |
| <a name="output_internal_ips"></a> [internal\_ips](#output\_internal\_ips) | n/a |
| <a name="output_logging_bucket_id"></a> [logging\_bucket\_id](#output\_logging\_bucket\_id) | n/a |
| <a name="output_logging_bucket_linked_dataset_id"></a> [logging\_bucket\_linked\_dataset\_id](#output\_logging\_bucket\_linked\_dataset\_id) | n/a |
| <a name="output_logging_dataset_id"></a> [logging\_dataset\_id](#output\_logging\_dataset\_id) | n/a |
| <a name="output_network"></a> [network](#output\_network) | n/a |
| <a name="output_public_ips"></a> [public\_ips](#output\_public\_ips) | n/a |
<!-- END_TF_DOCS -->