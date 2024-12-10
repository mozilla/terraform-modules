# Mozilla workgroup
Retrieve workgroup ACL lists associated with data and gcp access workgroups.

Workgroup identifiers should be of the form:

```
workgroup:WORKGROUP_NAME[/SUBGROUP]
```

where `SUBGROUP` defaults to `default`. For example: `workgroup:app`, `workgroup:app/admin`.

For subgroup queries across all workgroups, an additional identifier format:

```
subgroup:SUBGROUP
```

is supported, which will return all workgroups that contain a particular subgroup.

This module is cloned from https://github.com/mozilla-services/cloudops-infra-terraform-modules/tree/master/data-workgroup.
## Example
```hcl
module "workgroup" {
  source = "github.com/mozilla/terraform-modules//mozilla_workgroup?ref=main"

  ids                           = ["workgroup:app/admins"]
  roles                         = {}
  workgroup_outputs             = ["members", "google_groups"]
  terraform_remote_state_bucket = "moz-bucket"
  terraform_remote_state_prefix = "projects/workgroups"
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ids"></a> [ids](#input\_ids) | List of workgroup identifiers to look up access for | `set(string)` | n/a | yes |
| <a name="input_roles"></a> [roles](#input\_roles) | List of roles to generate bigquery acls for | `map(string)` | <pre>{<br>  "metadata_viewer": "roles/bigquery.metadataViewer",<br>  "read": "READER",<br>  "write": "WRITER"<br>}</pre> | no |
| <a name="input_terraform_remote_state_bucket"></a> [terraform\_remote\_state\_bucket](#input\_terraform\_remote\_state\_bucket) | The GCS bucket used for terraform state that contains the expected workgroups output | `string` | n/a | yes |
| <a name="input_terraform_remote_state_prefix"></a> [terraform\_remote\_state\_prefix](#input\_terraform\_remote\_state\_prefix) | The path prefix where the terraform state file is located | `string` | n/a | yes |
| <a name="input_workgroup_outputs"></a> [workgroup\_outputs](#input\_workgroup\_outputs) | Expected outputs from workgroup output definition | `list(any)` | <pre>[<br>  "bigquery_acls",<br>  "members",<br>  "service_accounts",<br>  "google_groups"<br>]</pre> | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bigquery"></a> [bigquery](#output\_bigquery) | bigquery acls for members associated with the input workgroups |
| <a name="output_google_groups"></a> [google\_groups](#output\_google\_groups) | google groups associated with the input workgroups, unqualified |
| <a name="output_ids"></a> [ids](#output\_ids) | pass input ids as output |
| <a name="output_members"></a> [members](#output\_members) | authoritative, fully-qualified list of members associated with the input workgroups |
| <a name="output_service_accounts"></a> [service\_accounts](#output\_service\_accounts) | service accounts associated with the input workgroups, unqualified |

<!-- BEGIN_TF_DOCS -->
# workgroup
Retrieve workgroup ACL lists associated with data and gcp access workgroups.

Workgroup identifiers should be of the form:

```
workgroup:WORKGROUP_NAME[/SUBGROUP]
```

where `SUBGROUP` defaults to `default`. For example: `workgroup:app`, `workgroup:app/admin`.

For subgroup queries across all workgroups, an additional identifier format:

```
subgroup:SUBGROUP
```

is supported, which will return all workgroups that contain a particular subgroup.

This module is cloned from https://github.com/mozilla-services/cloudops-infra-terraform-modules/tree/master/data-workgroup.
## Example
```hcl
module "workgroup" {
  source = "github.com/mozilla/terraform-modules//mozilla_workgroup?ref=main"

  ids                           = ["workgroup:app/admins"]
  roles                         = {}
  workgroup_outputs             = ["members", "google_groups"]
  terraform_remote_state_bucket = "moz-bucket"
  terraform_remote_state_prefix = "projects/workgroups"
}
```
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ids"></a> [ids](#input\_ids) | List of workgroup identifiers to look up access for | `set(string)` | n/a | yes |
| <a name="input_roles"></a> [roles](#input\_roles) | List of roles to generate bigquery acls for | `map(string)` | `{}` | no |
| <a name="input_terraform_remote_state_bucket"></a> [terraform\_remote\_state\_bucket](#input\_terraform\_remote\_state\_bucket) | The GCS bucket used for terraform state that contains the expected workgroups output | `string` | `"moz-fx-platform-mgmt-global-tf"` | no |
| <a name="input_terraform_remote_state_prefix"></a> [terraform\_remote\_state\_prefix](#input\_terraform\_remote\_state\_prefix) | The path prefix where the terraform state file is located | `string` | `"projects/google-workspace-management"` | no |
| <a name="input_workgroup_outputs"></a> [workgroup\_outputs](#input\_workgroup\_outputs) | Expected outputs from workgroup output definition | `list(any)` | <pre>[<br>  "members",<br>  "google_groups"<br>]</pre> | no |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bigquery"></a> [bigquery](#output\_bigquery) | bigquery acls for members associated with the input workgroups |
| <a name="output_google_groups"></a> [google\_groups](#output\_google\_groups) | google groups associated with the input workgroups, unqualified |
| <a name="output_ids"></a> [ids](#output\_ids) | pass input ids as output |
| <a name="output_members"></a> [members](#output\_members) | authoritative, fully-qualified list of members associated with the input workgroups |
| <a name="output_service_accounts"></a> [service\_accounts](#output\_service\_accounts) | service accounts associated with the input workgroups, unqualified |
<!-- END_TF_DOCS -->