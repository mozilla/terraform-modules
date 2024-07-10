## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.32.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.32.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_workload-identity-for-generic-tenant-sa"></a> [workload-identity-for-generic-tenant-sa](#module\_workload-identity-for-generic-tenant-sa) | github.com/mozilla/terraform-modules//google_workload_identity | main |
| <a name="module_workload-identity-for-tenant-external-secrets-sa"></a> [workload-identity-for-tenant-external-secrets-sa](#module\_workload-identity-for-tenant-external-secrets-sa) | github.com/mozilla/terraform-modules//google_workload_identity | main |
| <a name="module_workload-identity-for-tenant-sa"></a> [workload-identity-for-tenant-sa](#module\_workload-identity-for-tenant-sa) | github.com/mozilla/terraform-modules//google_workload_identity | main |

## Resources

| Name | Type |
|------|------|
| [google_project_iam_audit_config.GSM](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_audit_config) | resource |
| [google_project_iam_member.sa-role-secret-accessor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.sa-role-token-creator](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_service.GSM](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_secret_manager_secret_iam_member.sa-role-secret-accessor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/secret_manager_secret_iam_member) | resource |
| [google_service_account.gke-account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application name, eg. bouncer | `string` | `null` | no |
| <a name="input_cluster_project_id"></a> [cluster\_project\_id](#input\_cluster\_project\_id) | The project ID for the GKE cluster this app uses | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment to create (like, 'dev', 'stage', or 'prod') | `string` | `null` | no |
| <a name="input_gke_sa_secret_ids"></a> [gke\_sa\_secret\_ids](#input\_gke\_sa\_secret\_ids) | list of secret ids gke service account needs to have access to | `list(string)` | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID in which we're doing this work. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gke_service_account"></a> [gke\_service\_account](#output\_gke\_service\_account) | n/a |
