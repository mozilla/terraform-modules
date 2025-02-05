<!-- BEGIN_TF_DOCS -->
# Terraform Module: Google GKE tenant
Sets up a service account for use with GKE

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application name, eg. bouncer | `string` | `null` | no |
| <a name="input_cluster_project_id"></a> [cluster\_project\_id](#input\_cluster\_project\_id) | The project ID for the GKE cluster this app uses | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment to create (like, 'dev', 'stage', or 'prod') | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID in which we're doing this work. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gke_service_account"></a> [gke\_service\_account](#output\_gke\_service\_account) | n/a |
<!-- END_TF_DOCS -->
