<!-- BEGIN_TF_DOCS -->
# Terraform Module for GCP Terraform State Storage
Creates GCP storage bucket which will store a project's Terraform state.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of Terraform state bucket (recommended to use GCP Project or Service ID). | `string` | n/a | yes |
| <a name="input_tfadmin_project_id"></a> [tfadmin\_project\_id](#input\_tfadmin\_project\_id) | GCP Project ID of GCP Project that owns/administers the state bucket. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->
