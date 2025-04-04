<!-- BEGIN_TF_DOCS -->
# Terraform Module: Project DNS
Creates a DNS zone for an application's project and realm and links it to the parent zone.

The created zone will be:

`APP_NAME.REALM.TEAM_NAME.mozgcp.net`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_name"></a> [app\_name](#input\_app\_name) | Application name or product name, e.g. autopush | `string` | n/a | yes |
| <a name="input_parent_managed_zone"></a> [parent\_managed\_zone](#input\_parent\_managed\_zone) | GCP DNS managed zone to add the record. | `string` | n/a | yes |
| <a name="input_parent_project_id"></a> [parent\_project\_id](#input\_parent\_project\_id) | GCP project\_id that contains DNS zones used for delegation | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | GCP project\_id where the zone will be provisioned. | `string` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm is a grouping of environments being one of: global, nonprod, prod | `string` | `""` | no |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | Name of SRE team, which should correspond to the top-level folder name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_zone_dns_name"></a> [zone\_dns\_name](#output\_zone\_dns\_name) | n/a |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | n/a |
<!-- END_TF_DOCS -->
