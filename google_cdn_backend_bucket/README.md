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
| <a name="input_external_managed_backend_bucket_migration_state"></a> [external\_managed\_backend\_bucket\_migration\_state](#input\_external\_managed\_backend\_bucket\_migration\_state) | Canary migration state of the backend bucket behind the global forwarding rules when moving a live load balancer from `EXTERNAL` to `EXTERNAL_MANAGED`. One of `PREPARE`, `TEST_BY_PERCENTAGE` or `TEST_ALL_TRAFFIC`. Migrate in order: `PREPARE`, then `TEST_ALL_TRAFFIC`, then set `load_balancing_scheme` to `EXTERNAL_MANAGED` and leave this at `TEST_ALL_TRAFFIC`. Leave null for new load balancers. | `string` | `null` | no |
| <a name="input_external_managed_backend_bucket_migration_testing_percentage"></a> [external\_managed\_backend\_bucket\_migration\_testing\_percentage](#input\_external\_managed\_backend\_bucket\_migration\_testing\_percentage) | Percentage (0-100) of requests to the backend bucket that the global forwarding rules send through the `EXTERNAL_MANAGED` stack while `external_managed_backend_bucket_migration_state` is `TEST_BY_PERCENTAGE`. Only valid while `load_balancing_scheme` is `EXTERNAL`. | `number` | `null` | no |
| <a name="input_load_balancing_scheme"></a> [load\_balancing\_scheme](#input\_load\_balancing\_scheme) | Load balancing scheme for the global forwarding rules. One of `EXTERNAL`, `EXTERNAL_MANAGED`, `EXTERNAL_PASSTHROUGH`, `INTERNAL_MANAGED` or `INTERNAL_SELF_MANAGED`. Defaults to `EXTERNAL`, which was the Google provider's default before v8.0. Moving an existing load balancer from `EXTERNAL` to `EXTERNAL_MANAGED` requires the `external_managed_backend_bucket_migration_*` variables to be set first. | `string` | `"EXTERNAL"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | prefix for resource names | `string` | `""` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
