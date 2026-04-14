<!-- BEGIN_TF_DOCS -->
# google\_bigquery\_syndicated\_dataset

Creates a BigQuery dataset configured for syndication to Mozilla Data Platform
infrastructure (mozdata and data-shared projects).  This module is meant to
simplify the steps in [Importing Data from OLTP Databases to BigQuery via Federated Queries](https://mozilla-hub.atlassian.net/wiki/spaces/IP/pages/473727279/Importing+Data+from+OLTP+Databases+to+BigQuery+via+Federated+Queries)

This module abstracts away the syndication boilerplate:
- Resolves syndication service accounts via workgroup
- Looks up the org custom role for syndication
- Auto-discovers whether syndicated datasets exist in data platform projects
- Adds dataset authorizations only when targets exist

## Target Inference

The `syndicated_dataset_id` (defaults to `dataset_id`) determines targets:
- Does NOT end in `_syndicate` → user-facing → both mozdata and data-shared
- Ends in `_syndicate` → data-shared only
- Eventually the syndication datasets themselves will be inferred from bqetl metadata available to all MozCloud tenant infrastructure

## State propagation

While this module reduces the amount of PRs required to set up syndication, it will not automatically
propagate those changes. You still need to follow the steps on
https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/27924945/Atlantis+-+Terraform+Automation#Invoking-Atlantis-without-terraform-changes
in order to authorize datasets on the tenant infra side. Eventually policy-as-code and drift
detection automation will make these manual steps unnecessary.

## Example

```hcl
module "treeherder" {
  source = "github.com/mozilla/terraform-modules//google_bigquery_syndicated_dataset?ref=main"

  dataset_id            = "for_treeherder_1"
  syndicated_dataset_id = "treeherder_db"
  realm                 = var.realm

  access = [
    { role = "OWNER", special_group = "projectOwners" },
    # projectReaders/projectWriters usage is discouraged, see DSRE-1497
    { role = "READER", special_group = "projectReaders" },
    { role = "WRITER", special_group = "projectWriters" },
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 7.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 7.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_syndication_workgroup"></a> [syndication\_workgroup](#module\_syndication\_workgroup) | github.com/mozilla/terraform-modules//mozilla_workgroup | main |

## Resources

| Name | Type |
|------|------|
| [google_bigquery_dataset.dataset](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset) | resource |
| [google_bigquery_dataset_access.syndicated_authorization](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset_access) | resource |
| [google_bigquery_dataset_access.syndication_role](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset_access) | resource |
| [terraform_remote_state.org](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.syndication_target](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access"></a> [access](#input\_access) | Application-specific access blocks for this dataset. projectOwners OWNER access is included by default unless disable\_project\_owners\_access is set. | <pre>set(object({<br/>    role           = optional(string)<br/>    user_by_email  = optional(string)<br/>    group_by_email = optional(string)<br/>    special_group  = optional(string)<br/>    domain         = optional(string)<br/>    iam_member     = optional(string)<br/>    dataset = optional(object({<br/>      dataset = object({<br/>        project_id = string<br/>        dataset_id = string<br/>      })<br/>      target_types = list(string)<br/>    }))<br/>    view = optional(object({<br/>      project_id = string<br/>      dataset_id = string<br/>      table_id   = string<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_create_dataset"></a> [create\_dataset](#input\_create\_dataset) | Whether to create the BigQuery dataset. Set to false to only manage syndication access on an existing dataset. | `bool` | `true` | no |
| <a name="input_dataset_id"></a> [dataset\_id](#input\_dataset\_id) | A unique ID for this dataset, without the project name. | `string` | n/a | yes |
| <a name="input_default_partition_expiration_ms"></a> [default\_partition\_expiration\_ms](#input\_default\_partition\_expiration\_ms) | The default partition expiration for all partitioned tables, in milliseconds. | `number` | `null` | no |
| <a name="input_default_table_expiration_ms"></a> [default\_table\_expiration\_ms](#input\_default\_table\_expiration\_ms) | The default lifetime of all tables in the dataset, in milliseconds. | `number` | `null` | no |
| <a name="input_delete_contents_on_destroy"></a> [delete\_contents\_on\_destroy](#input\_delete\_contents\_on\_destroy) | If true, delete all tables in the dataset when destroying the resource. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | A user-friendly description of the dataset. | `string` | `null` | no |
| <a name="input_disable_project_owners_access"></a> [disable\_project\_owners\_access](#input\_disable\_project\_owners\_access) | Disable the implied projectOwners OWNER access on this dataset. This should almost never be set. | `bool` | `false` | no |
| <a name="input_friendly_name"></a> [friendly\_name](#input\_friendly\_name) | A descriptive name for the dataset. | `string` | `null` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to apply to the dataset. | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | The geographic location where the dataset should reside. | `string` | `"US"` | no |
| <a name="input_max_time_travel_hours"></a> [max\_time\_travel\_hours](#input\_max\_time\_travel\_hours) | Defines the time travel window in hours. | `number` | `null` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | Source infrastructure realm. | `string` | n/a | yes |
| <a name="input_syndicated_dataset_id"></a> [syndicated\_dataset\_id](#input\_syndicated\_dataset\_id) | Name of the dataset in target projects. Defaults to dataset\_id. If name ends in '\_syndicate', only data-shared is targeted (no mozdata). | `string` | `null` | no |
| <a name="input_syndication_workgroup_ids"></a> [syndication\_workgroup\_ids](#input\_syndication\_workgroup\_ids) | Workgroup identifiers for service accounts that perform syndication. | `list(string)` | <pre>[<br/>  "workgroup:dataplatform/jenkins"<br/>]</pre> | no |
| <a name="input_target_realm"></a> [target\_realm](#input\_target\_realm) | Target realm for syndication. Defaults to realm. Set override, e.g. nonprod source syndicating to prod targets. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dataset_id"></a> [dataset\_id](#output\_dataset\_id) | The dataset ID. |
| <a name="output_id"></a> [id](#output\_id) | The fully-qualified dataset ID (projects/PROJECT/datasets/DATASET). |
| <a name="output_self_link"></a> [self\_link](#output\_self\_link) | The URI of the created resource. |
| <a name="output_syndication_role_id"></a> [syndication\_role\_id](#output\_syndication\_role\_id) | The custom role ID used for syndication access. |
| <a name="output_syndication_service_accounts"></a> [syndication\_service\_accounts](#output\_syndication\_service\_accounts) | The service account emails used for syndication. |
| <a name="output_syndication_targets_active"></a> [syndication\_targets\_active](#output\_syndication\_targets\_active) | Map of syndication target names to whether authorized dataset access is active. |
<!-- END_TF_DOCS -->
