<!-- BEGIN_TF_DOCS -->


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | n/a | `string` | n/a | yes |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | list of objects defining certificates to be added to the certmap | <pre>list(object({<br/>    hostname           = string<br/>    dns_authorization  = optional(bool, false)<br/>    additional_domains = optional(list(string), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_custom_name_prefix"></a> [custom\_name\_prefix](#input\_custom\_name\_prefix) | use this to set a custom name\_prefix for resource names | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | n/a | `string` | n/a | yes |
| <a name="input_shared_infra_project_id"></a> [shared\_infra\_project\_id](#input\_shared\_infra\_project\_id) | id of shared infra project to create resources in | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_map"></a> [certificate\_map](#output\_certificate\_map) | n/a |
| <a name="output_dns_authorizations"></a> [dns\_authorizations](#output\_dns\_authorizations) | n/a |
| <a name="output_dns_authorizations_by_domain"></a> [dns\_authorizations\_by\_domain](#output\_dns\_authorizations\_by\_domain) | n/a |
<!-- END_TF_DOCS -->
