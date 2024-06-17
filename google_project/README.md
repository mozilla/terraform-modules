# Terraform Module for Project Provisioning
Sets up a single GCP project linked to a billing account plus management metadata.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 3.90.1 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project) | resource |
| [google_project_service.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [random_id.project](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_code"></a> [app\_code](#input\_app\_code) | Defaults to project\_name. Used for labels and metadata on application-related resources. See https://github.com/mozilla-services/inventory/blob/master/application_component_registry.csv. | `string` | `""` | no |
| <a name="input_billing_account_id"></a> [billing\_account\_id](#input\_billing\_account\_id) | Associated billing account | `string` | n/a | yes |
| <a name="input_component_code"></a> [component\_code](#input\_component\_code) | Defaults to app\_code-uncat. See https://github.com/mozilla-services/inventory/blob/master/application_component_registry.csv | `string` | `""` | no |
| <a name="input_cost_center"></a> [cost\_center](#input\_cost\_center) | Cost center of the project or resource. Default is 5650 (Services Engineering) | `string` | `"5650"` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name for the project. Defaults to project\_name | `string` | `""` | no |
| <a name="input_extra_project_labels"></a> [extra\_project\_labels](#input\_extra\_project\_labels) | Extra project labels (a map of key/value pairs) to be applied to the Project. | `map(string)` | `{}` | no |
| <a name="input_parent_id"></a> [parent\_id](#input\_parent\_id) | Parent folder (with GCP). | `string` | n/a | yes |
| <a name="input_program_code"></a> [program\_code](#input\_program\_code) | Program Code of the project or resource: https://mana.mozilla.org/wiki/display/FINArchive/Program+Codes. Drop the `PC - `, lowercase the string and substitute spaces for dashes. | `string` | `"firefox-services"` | no |
| <a name="input_program_name"></a> [program\_name](#input\_program\_name) | Name of the Firefox program being one of: ci, data, infrastructure, services, web. | `string` | `"services"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Override default project id. Only use if the project id is already taken. | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name of project e.g., autopush | `string` | n/a | yes |
| <a name="input_project_services"></a> [project\_services](#input\_project\_services) | List of google\_project\_service APIs to enable. | `list(string)` | `[]` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm is a grouping of environments being one of: global, nonprod, prod | `string` | `""` | no |
| <a name="risk_level"></a> [risk\_level](#input\_risk\_level) | The risk level of the project, usually comes from an RRA | `string` | `"low"` | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | n/a |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | n/a |
| <a name="output_project_number"></a> [project\_number](#output\_project\_number) | n/a |

