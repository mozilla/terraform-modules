# Terraform Module for GCP Terraform State Storage
Creates GCP storage bucket which will store a project's Terraform state.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
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
| [google_storage_bucket.tfstate](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of Terraform state bucket (recommended to use GCP Project or Service ID). | `string` | n/a | yes |
| <a name="input_tfadmin_project_id"></a> [tfadmin\_project\_id](#input\_tfadmin\_project\_id) | GCP Project ID of GCP Project that owns/administers the state bucket. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | n/a |
