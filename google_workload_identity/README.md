<!-- BEGIN_TF_DOCS -->
# Terraform module for Workload Identity
Creates identity mapping and optionally the service
accounts to go with it

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 3.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project_iam_member.workload_identity_sa_bindings](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.cluster_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_iam_member.main](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_member) | resource |
| [kubernetes_service_account.main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [google_service_account.cluster_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/service_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automount_service_account_token"></a> [automount\_service\_account\_token](#input\_automount\_service\_account\_token) | Enable automatic mounting of the service account token | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Cluster name. Required if using existing KSA. | `string` | `""` | no |
| <a name="input_gcp_sa_name"></a> [gcp\_sa\_name](#input\_gcp\_sa\_name) | Name for the Google service account; overrides `var.name`. | `string` | `null` | no |
| <a name="input_impersonate_service_account"></a> [impersonate\_service\_account](#input\_impersonate\_service\_account) | An optional service account to impersonate for gcloud commands. If this service account is not specified, the module will use Application Default Credentials. | `string` | `""` | no |
| <a name="input_k8s_sa_name"></a> [k8s\_sa\_name](#input\_k8s\_sa\_name) | Name for the Kubernetes service account; overrides `var.name`. | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Cluster location (region if regional cluster, zone if zonal cluster). Required if using existing KSA. | `string` | `""` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for both service accounts. The GCP SA will be truncated to the first 30 chars if necessary. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace for the Kubernetes service account | `string` | `"default"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project ID | `string` | n/a | yes |
| <a name="input_roles"></a> [roles](#input\_roles) | A list of roles to be added to the created service account | `list(string)` | `[]` | no |
| <a name="input_use_existing_gcp_sa"></a> [use\_existing\_gcp\_sa](#input\_use\_existing\_gcp\_sa) | Use an existing Google service account instead of creating one | `bool` | `false` | no |
| <a name="input_use_existing_k8s_sa"></a> [use\_existing\_k8s\_sa](#input\_use\_existing\_k8s\_sa) | Use an existing kubernetes service account instead of creating one | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gcp_service_account"></a> [gcp\_service\_account](#output\_gcp\_service\_account) | GCP service account. |
| <a name="output_gcp_service_account_email"></a> [gcp\_service\_account\_email](#output\_gcp\_service\_account\_email) | Email address of GCP service account. |
| <a name="output_gcp_service_account_fqn"></a> [gcp\_service\_account\_fqn](#output\_gcp\_service\_account\_fqn) | FQN of GCP service account. |
| <a name="output_gcp_service_account_name"></a> [gcp\_service\_account\_name](#output\_gcp\_service\_account\_name) | Name of GCP service account. |
| <a name="output_k8s_service_account_name"></a> [k8s\_service\_account\_name](#output\_k8s\_service\_account\_name) | Name of k8s service account. |
| <a name="output_k8s_service_account_namespace"></a> [k8s\_service\_account\_namespace](#output\_k8s\_service\_account\_namespace) | Namespace of k8s service account. |
<!-- END_TF_DOCS -->