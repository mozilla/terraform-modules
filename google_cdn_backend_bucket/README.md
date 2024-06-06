# google\_cdn\_backend\_bucket

this module builds a GCP Load Balancer with a backend bucket

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.32.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 5.32.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_backend_bucket.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_bucket) | resource |
| [google_compute_global_forwarding_rule.http](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_global_forwarding_rule.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_target_http_proxy.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy) | resource |
| [google_compute_target_https_proxy.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy) | resource |
| [google_compute_url_map.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |
| [google_compute_url_map.https_redirect](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addresses"></a> [addresses](#input\_addresses) | loadbalancer ips | `map(string)` | n/a | yes |
| <a name="input_application"></a> [application](#input\_application) | n/a | `string` | n/a | yes |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | name of bucket to use for the CDN | `string` | n/a | yes |
| <a name="input_cdn_policy"></a> [cdn\_policy](#input\_cdn\_policy) | cdn policy | <pre>object({<br>    cache_mode        = optional(string, "CACHE_ALL_STATIC")<br>    client_ttl        = optional(number, 3600)<br>    default_ttl       = optional(number, 3600)<br>    max_ttl           = optional(number, 86400)<br>    negative_caching  = optional(bool, true)<br>    serve_while_stale = optional(number, 86400)<br>  })</pre> | n/a | yes |
| <a name="input_certificates"></a> [certificates](#input\_certificates) | list of certificate ids to use on the https target proxy | `list(string)` | n/a | yes |
| <a name="input_compression_mode"></a> [compression\_mode](#input\_compression\_mode) | n/a | `string` | `"DISABLED"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | prefix for resource names | `string` | `""` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | n/a | `string` | n/a | yes |

## Outputs

No outputs.
