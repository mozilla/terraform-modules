# Google Permissions

This module provides an interface to adding permissions to your google projects and folders.

For information on how to add new roles to the modules, please see [this document](./ADDING\_NEW\_ROLE.md)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_admins_workgroup"></a> [admins\_workgroup](#module\_admins\_workgroup) | ../mozilla_workgroup | n/a |
| <a name="module_developers_workgroup"></a> [developers\_workgroup](#module\_developers\_workgroup) | ../mozilla_workgroup | n/a |
| <a name="module_viewers_workgroup"></a> [viewers\_workgroup](#module\_viewers\_workgroup) | ../mozilla_workgroup | n/a |

## Resources

| Name | Type |
|------|------|
| [google_folder_iam_binding.bq_data_viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_binding) | resource |
| [google_folder_iam_binding.bq_job_user](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_binding) | resource |
| [google_folder_iam_binding.developers_logging_privateLogViewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_binding) | resource |
| [google_folder_iam_binding.developers_techsupport_editor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_binding) | resource |
| [google_folder_iam_binding.folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_binding) | resource |
| [google_folder_iam_binding.owner](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_binding) | resource |
| [google_folder_iam_binding.viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_binding) | resource |
| [google_project_iam_binding.automl_editor_prod](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.bucket_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.editor_nonprod](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.nonprod_developer_cloudsql_viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.nonprod_developer_colabEnterpriseUser](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.nonprod_developer_db_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.nonprod_developer_monitoring_uptimecheckconfigeditor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.nonprod_developer_objectUser](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.nonprod_developer_pubsub_editor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.nonprod_developer_secretmanager_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.prod_bucket_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.prod_developer_cloudsql_viewer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.prod_developer_colabEnterpriseUser](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.prod_developer_db_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.prod_developer_monitoring_uptimecheckconfigeditor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.prod_developer_objectUser](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.prod_developer_pubsub_editor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.storage_objectadmin_prod](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.translationhub_admin_prod](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_member.cloudtranslate_editor_prod](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.developers_secretmanager_secretAccessor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.developers_secretmanager_secretVersionAdder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.prod_developer_secretmanager_secretAccessor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.prod_developer_secretmanager_secretVersionAdder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_ids"></a> [admin\_ids](#input\_admin\_ids) | List of admin IDs to add to the project. | `list(string)` | `[]` | no |
| <a name="input_admin_only"></a> [admin\_only](#input\_admin\_only) | Whether or not to create a project with admin-only role. | `bool` | `false` | no |
| <a name="input_developer_ids"></a> [developer\_ids](#input\_developer\_ids) | List of developer IDs to add to the project. | `list(string)` | `[]` | no |
| <a name="input_folder_roles"></a> [folder\_roles](#input\_folder\_roles) | List of roles to apply at the folder level. | `list(string)` | `[]` | no |
| <a name="input_google_folder_id"></a> [google\_folder\_id](#input\_google\_folder\_id) | The ID of the folder to create the project in. | `string` | n/a | yes |
| <a name="input_google_nonprod_project_id"></a> [google\_nonprod\_project\_id](#input\_google\_nonprod\_project\_id) | The ID of the nonprod project. | `string` | `""` | no |
| <a name="input_google_prod_project_id"></a> [google\_prod\_project\_id](#input\_google\_prod\_project\_id) | The ID of the prod project. | `string` | `""` | no |
| <a name="input_nonprod_roles"></a> [nonprod\_roles](#input\_nonprod\_roles) | List of roles to apply to the nonprod project. | `list(string)` | `[]` | no |
| <a name="input_prod_roles"></a> [prod\_roles](#input\_prod\_roles) | List of roles to apply to the prod project. | `list(string)` | `[]` | no |
| <a name="input_viewer_ids"></a> [viewer\_ids](#input\_viewer\_ids) | List of viewer IDs to add to the project. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_validate_folder_roles"></a> [validate\_folder\_roles](#output\_validate\_folder\_roles) | n/a |
| <a name="output_validate_nonprod_roles"></a> [validate\_nonprod\_roles](#output\_validate\_nonprod\_roles) | n/a |
| <a name="output_validate_prod_roles"></a> [validate\_prod\_roles](#output\_validate\_prod\_roles) | n/a |
