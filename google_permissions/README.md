test
<!-- BEGIN_TF_DOCS -->
# Google Permissions

This module provides an interface to adding permissions to your google projects and folders.

For information on how to add new roles to the modules, please see [this document](./ADDING\_NEW\_ROLE.md)

## Examples

```hcl
module "permissions" {
  source = "github.com/mozilla/terraform-modules//google_permissions?ref=main"
  // it is assumed that you loaded and have available a local.project
  google_folder_id          = local.project.folder.id
  google_prod_project_id    = local.project["prod"].id
  google_nonprod_project_id = local.project["nonprod"].id
  admin_ids                 = ["workgroup:my-project/workgroup_subgroup"]
  developer_ids             = ["workgroup:my-project/developers"]
  viewer_ids                = ["workgroup:my-project/viewers"]
}
```

```hcl
module "permissions" {
  source = "../../../google_permissions"
  // it is assumed that you loaded and have available a local.project
  google_folder_id          = local.project.folder.id
  google_prod_project_id    = local.project["prod"].id
  google_nonprod_project_id = local.project["nonprod"].id
  admin_ids                 = ["workgroup:my-project/admins"]
  developer_ids             = ["workgroup:my-project/developers"]
  folder_roles = [
    "roles/bigquery.jobUser",
  ]
  prod_roles = [
    "roles/storage.objectAdmin",
    "roles/storage.admin",
    "roles/cloudsql.admin"
  ]
  nonprod_roles = [
    "roles/editor",
    "roles/storage.admin",
    "roles/cloudsql.admin"
  ]
}
```

```hcl
module "permissions" {
  source = "../../../google_permissions"
  // it is assumed that you loaded and have available a local.project
  google_folder_id          = local.project.folder.id
  google_prod_project_id    = local.project["prod"].id
  google_nonprod_project_id = local.project["nonprod"].id
  admin_only                = true
  admin_ids                 = ["workgroup:my-project/admins"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_ids"></a> [admin\_ids](#input\_admin\_ids) | List of admin IDs to add to the project. | `list(string)` | `[]` | no |
| <a name="input_admin_only"></a> [admin\_only](#input\_admin\_only) | Whether or not to create a project with admin-only role. | `bool` | `false` | no |
| <a name="input_app_code"></a> [app\_code](#input\_app\_code) | The application code for the permissions. See https://github.com/mozilla-services/inventory/blob/master/application_component_registry.csv. | `string` | `""` | no |
| <a name="input_developer_ids"></a> [developer\_ids](#input\_developer\_ids) | List of developer IDs to add to the project. | `list(string)` | `[]` | no |
| <a name="input_entitlement_data"></a> [entitlement\_data](#input\_entitlement\_data) | The entitlement data for the project. | <pre>object({<br/>    enabled          = bool<br/>    additional_roles = list(string)<br/>    additional_entitlements = list(object({<br/>      name       = string<br/>      roles      = list(string)<br/>      principals = list(string)<br/>      approval_workflow = optional(object({<br/>        principals = list(string)<br/>      }))<br/>    }))<br/>  })</pre> | <pre>{<br/>  "additional_entitlements": [],<br/>  "additional_roles": [],<br/>  "enabled": false<br/>}</pre> | no |
| <a name="input_entitlement_enabled"></a> [entitlement\_enabled](#input\_entitlement\_enabled) | Whether or not to enable entitlements. | `bool` | `false` | no |
| <a name="input_entitlement_slack_topic"></a> [entitlement\_slack\_topic](#input\_entitlement\_slack\_topic) | The name of the pubsub topic to use for slack notifications. | `string` | `""` | no |
| <a name="input_feed_id"></a> [feed\_id](#input\_feed\_id) | The ID of the feed to be created | `string` | `"grant_feed"` | no |
| <a name="input_folder_roles"></a> [folder\_roles](#input\_folder\_roles) | List of roles to apply at the folder level. Also used as the roles in the entitlement. | `list(string)` | `[]` | no |
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
<!-- END_TF_DOCS -->
