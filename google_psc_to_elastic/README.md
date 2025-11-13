<!-- BEGIN_TF_DOCS -->


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_psc_global_access"></a> [allow\_psc\_global\_access](#input\_allow\_psc\_global\_access) | Allow global access to the PSC endpoint | `bool` | `false` | no |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GCP region | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | GCP project name | `string` | n/a | yes |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | VPC network name | `string` | n/a | yes |
| <a name="input_project_id_for_network"></a> [project\_id\_for\_network](#input\_project\_id\_for\_network) | The project ID from which to retrieve the data of a network or subnet | `string` | `""` | no |
| <a name="input_subnetwork_name"></a> [subnetwork\_name](#input\_subnetwork\_name) | VPC subnetwork name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_psc_connection_id"></a> [psc\_connection\_id](#output\_psc\_connection\_id) | n/a |
<!-- END_TF_DOCS -->
