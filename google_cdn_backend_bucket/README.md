<!-- BEGIN_TF_DOCS -->
# google\_cdn\_backend\_bucket

this module builds a GCP Load Balancer with a backend bucket

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addresses"></a> [addresses](#input\_addresses) | loadbalancer ips | `map(string)` | n/a | yes |
| <a name="input_application"></a> [application](#input\_application) | n/a | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | name of bucket to use for the CDN | `string` | n/a | yes |
| <a name="input_cdn_policy"></a> [cdn\_policy](#input\_cdn\_policy) | cdn policy | <pre>object({<br/>    cache_mode        = optional(string, "CACHE_ALL_STATIC")<br/>    client_ttl        = optional(number, 3600)<br/>    default_ttl       = optional(number, 3600)<br/>    max_ttl           = optional(number, 86400)<br/>    negative_caching  = optional(bool, true)<br/>    serve_while_stale = optional(number, 86400)<br/>  })</pre> | n/a | yes |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | list of certificate ids to use on the https target proxy | `list(string)` | n/a | yes |
| <a name="input_compression_mode"></a> [compression\_mode](#input\_compression\_mode) | n/a | `string` | `"DISABLED"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | prefix for resource names | `string` | `""` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
