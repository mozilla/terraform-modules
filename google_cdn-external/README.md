<!-- BEGIN_TF_DOCS -->
# Google CDN Distribution for external endpoints

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_addresses"></a> [addresses](#input\_addresses) | IP Addresses. | <pre>object({<br/>    ipv4 = string,<br/>    ipv6 = string,<br/>  })</pre> | n/a | yes |
| <a name="input_application"></a> [application](#input\_application) | Application name. | `string` | n/a | yes |
| <a name="input_backend_timeout_sec"></a> [backend\_timeout\_sec](#input\_backend\_timeout\_sec) | Timeout for backend service. | `number` | `10` | no |
| <a name="input_backend_type"></a> [backend\_type](#input\_backend\_type) | Backend type to create. Must be set to one of [service, bucket, service\_and\_bucket]. When service\_and\_bucket, the default backend is the service | `string` | `"service"` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | Name of GCS bucket to use as CDN backend. Required if backend\_type is set to 'bucket' or 'service\_and\_bucket'. | `string` | `""` | no |
| <a name="input_cache_key_policy"></a> [cache\_key\_policy](#input\_cache\_key\_policy) | Cache key policy config to be passed to backend service. | `map(any)` | `{}` | no |
| <a name="input_cdn_policy"></a> [cdn\_policy](#input\_cdn\_policy) | CDN policy config to be passed to backend service. | `map(any)` | `{}` | no |
| <a name="input_certs"></a> [certs](#input\_certs) | List of certificates ids. If this list is empty, this will be HTTP only. | `list(string)` | n/a | yes |
| <a name="input_compression_mode"></a> [compression\_mode](#input\_compression\_mode) | Can be AUTOMATIC or DISABLED | `string` | `"DISABLED"` | no |
| <a name="input_custom_response_headers"></a> [custom\_response\_headers](#input\_custom\_response\_headers) | Headers that the HTTP/S load balancer should add to proxied responses. | `list(string)` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name. | `string` | n/a | yes |
| <a name="input_https_redirect"></a> [https\_redirect](#input\_https\_redirect) | Redirect from http to https. | `bool` | `true` | no |
| <a name="input_log_sample_rate"></a> [log\_sample\_rate](#input\_log\_sample\_rate) | Sample rate for Cloud Logging. Must be in the interval [0, 1]. | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Optional name of distribution. | `string` | `""` | no |
| <a name="input_negative_caching_policy"></a> [negative\_caching\_policy](#input\_negative\_caching\_policy) | Negative caching policy config to be passed to backend service. | <pre>list(object({<br/>    code = string<br/>    ttl  = string<br/>  }))</pre> | `[]` | no |
| <a name="input_origin_fqdn"></a> [origin\_fqdn](#input\_origin\_fqdn) | Origin's fqdn: e.g., 'mozilla.org'. | `string` | n/a | yes |
| <a name="input_origin_port"></a> [origin\_port](#input\_origin\_port) | Port to use for origin. | `number` | `443` | no |
| <a name="input_origin_protocol"></a> [origin\_protocol](#input\_origin\_protocol) | Protocol for the origin. | `string` | `"HTTPS"` | no |
| <a name="input_path_rewrites"></a> [path\_rewrites](#input\_path\_rewrites) | Dictionary of path matchers. | <pre>map(object({<br/>    hosts                = list(string)<br/>    paths                = list(string)<br/>    target               = string<br/>    backend_bucket_paths = optional(list(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_primary_hostname"></a> [primary\_hostname](#input\_primary\_hostname) | Primary hostname of service. | `string` | n/a | yes |
| <a name="input_quic_override"></a> [quic\_override](#input\_quic\_override) | Specifies the QUIC override policy. Possible values `NONE`, `ENABLE`, `DISABLE` | `string` | `"DISABLE"` | no |
| <a name="input_security_policy"></a> [security\_policy](#input\_security\_policy) | Security policy as defined by google\_compute\_security\_policy | `string` | `null` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
