# Google Permissions

This module provides an interface to adding permissions to your google projects and folders.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 5.7.0 |

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
| [google_project_iam_binding.nonprod_developer_db_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.prod_bucket_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.prod_developer_db_admin](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.storage_objectadmin_prod](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_binding.translationhub_admin_prod](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_project_iam_member.cloudtranslate_editor_prod](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.developers_secretmanager_secretAccessor](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.developers_secretmanager_secretVersionAdder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_members"></a> [admin\_members](#input\_admin\_members) | List of admin members to add to the project. | `list(string)` | `[]` | no |
| <a name="input_admin_only"></a> [admin\_only](#input\_admin\_only) | Whether or not to create a project with admin-only permissions. | `bool` | `false` | no |
| <a name="input_developer_members"></a> [developer\_members](#input\_developer\_members) | List of developer members to add to the project. | `list(string)` | `[]` | no |
| <a name="input_google_folder_id"></a> [google\_folder\_id](#input\_google\_folder\_id) | The ID of the folder to create the project in. | `string` | n/a | yes |
| <a name="input_google_nonprod_id"></a> [google\_nonprod\_id](#input\_google\_nonprod\_id) | The ID of the nonprod project. | `string` | `""` | no |
| <a name="input_google_prod_id"></a> [google\_prod\_id](#input\_google\_prod\_id) | The ID of the prod project. | `string` | `""` | no |
| <a name="input_other_permissions"></a> [other\_permissions](#input\_other\_permissions) | List of other additional permissions beyond the core set to allow on the project. | `list(string)` | `[]` | no |
| <a name="input_viewer_members"></a> [viewer\_members](#input\_viewer\_members) | List of viewer members to add to the project. | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->