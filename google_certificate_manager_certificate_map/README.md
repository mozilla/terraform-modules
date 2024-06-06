## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.32.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.6.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.32.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.6.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_certificate_manager_certificate.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/certificate_manager_certificate) | resource |
| [google_certificate_manager_certificate_map.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/certificate_manager_certificate_map) | resource |
| [google_certificate_manager_certificate_map_entry.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/certificate_manager_certificate_map_entry) | resource |
| [google_certificate_manager_dns_authorization.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/certificate_manager_dns_authorization) | resource |
| [random_id.certificate_map_entry_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | n/a | `string` | n/a | yes |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | list of objects defining certificates to be added to the certmap | <pre>list(object({<br>    hostname           = string<br>    dns_authorization  = optional(bool, false)<br>    additional_domains = optional(list(string), [])<br>  }))</pre> | `[]` | no |
| <a name="input_custom_name_prefix"></a> [custom\_name\_prefix](#input\_custom\_name\_prefix) | use this to set a custom name\_prefix for resource names | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | n/a | `string` | n/a | yes |
| <a name="input_shared_infra_project_id"></a> [shared\_infra\_project\_id](#input\_shared\_infra\_project\_id) | id of shared infra project to create resources in | `string` | n/a | yes |

## Outputs

No outputs.
