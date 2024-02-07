# Google CDN Distribution for external endpoints

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.42 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.42 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_backend_bucket.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_bucket) | resource |
| [google_compute_backend_service.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_service) | resource |
| [google_compute_global_forwarding_rule.http](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_global_forwarding_rule.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_global_network_endpoint.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_network_endpoint) | resource |
| [google_compute_global_network_endpoint_group.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_network_endpoint_group) | resource |
| [google_compute_target_http_proxy.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy) | resource |
| [google_compute_target_https_proxy.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy) | resource |
| [google_compute_url_map.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |
| [google_compute_url_map.https_redirect](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addresses"></a> [addresses](#input\_addresses) | IP Addresses. | <pre>object({<br>    ipv4 = string,<br>    ipv6 = string,<br>  })</pre> | n/a | yes |
| <a name="input_application"></a> [application](#input\_application) | Application name. | `string` | n/a | yes |
| <a name="input_certs"></a> [certs](#input\_certs) | List of certificates ids. If this list is empty, this will be HTTP only. | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name. | `string` | n/a | yes |
| <a name="input_origin_fqdn"></a> [origin\_fqdn](#input\_origin\_fqdn) | Origin's fqdn: e.g., 'mozilla.org'. | `string` | n/a | yes |
| <a name="input_primary_hostname"></a> [primary\_hostname](#input\_primary\_hostname) | Primary hostname of service. | `string` | n/a | yes |
| <a name="input_backend_timeout_sec"></a> [backend\_timeout\_sec](#input\_backend\_timeout\_sec) | Timeout for backend service. | `number` | `10` | no |
| <a name="input_backend_type"></a> [backend\_type](#input\_backend\_type) | Backend type to create. Must be set to one of [service, bucket, service\_and\_bucket]. When service\_and\_bucket, the default backend is the service | `string` | `"service"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of GCS bucket to use as CDN backend. Required if backend\_type is set to 'bucket' or 'service\_and\_bucket'. | `string` | `""` | no |
| <a name="input_cache_key_policy"></a> [cache\_key\_policy](#input\_cache\_key\_policy) | Cache key policy config to be passed to backend service. | `map(any)` | `{}` | no |
| <a name="input_cdn_policy"></a> [cdn\_policy](#input\_cdn\_policy) | CDN policy config to be passed to backend service. | `map(any)` | `{}` | no |
| <a name="input_compression_mode"></a> [compression\_mode](#input\_compression\_mode) | Can be AUTOMATIC or DISABLED | `string` | `"DISABLED"` | no |
| <a name="input_custom_response_headers"></a> [custom\_response\_headers](#input\_custom\_response\_headers) | Headers that the HTTP/S load balancer should add to proxied responses. | `list(string)` | `null` | no |
| <a name="input_https_redirect"></a> [https\_redirect](#input\_https\_redirect) | Redirect from http to https. | `bool` | `true` | no |
| <a name="input_log_sample_rate"></a> [log\_sample\_rate](#input\_log\_sample\_rate) | Sample rate for Cloud Logging. Must be in the interval [0, 1]. | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Optional name of distribution. | `string` | `""` | no |
| <a name="input_negative_caching_policy"></a> [negative\_caching\_policy](#input\_negative\_caching\_policy) | Negative caching policy config to be passed to backend service. | <pre>list(object({<br>    code = string<br>    ttl  = string<br>  }))</pre> | `[]` | no |
| <a name="input_origin_port"></a> [origin\_port](#input\_origin\_port) | Port to use for origin. | `number` | `443` | no |
| <a name="input_origin_protocol"></a> [origin\_protocol](#input\_origin\_protocol) | Protocol for the origin. | `string` | `"HTTPS"` | no |
| <a name="input_path_rewrites"></a> [path\_rewrites](#input\_path\_rewrites) | Dictionary of path matchers. | <pre>map(object({<br>    hosts                = list(string)<br>    paths                = list(string)<br>    target               = string<br>    backend_bucket_paths = optional(list(string))<br>  }))</pre> | `{}` | no |
| <a name="input_quic_override"></a> [quic\_override](#input\_quic\_override) | Specifies the QUIC override policy. Possible values `NONE`, `ENABLE`, `DISABLE` | `string` | `"DISABLE"` | no |
| <a name="input_security_policy"></a> [security\_policy](#input\_security\_policy) | Security policy as defined by google\_compute\_security\_policy | `string` | `null` | no |

## Outputs

No outputs.
