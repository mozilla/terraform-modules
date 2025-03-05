

## Examples

```hcl
module "gar" {
  source      = "github.com/mozilla/terraform-modules//google_fastly_waf?ref=main"
  application = glab
  environment = foo
  project_id  = bar
  realm       = bar

  waf_enabled       = true
  ngwaf_agent_level = "block"

  subscription_domains = [
    { name = "my-app.mozilla.org" }
  ]

  domains = [
    { name = "my-cool-app.global.ssl.fastly.net" },
  ]

  backends = [
    {
      address           = "my_cool_app.net"
      name              = "my_cool_app_net"
      port              = 443
      ssl_cert_hostname = "my_cool_app.net"
      ssl_sni_hostname  = "my_cool_app.net"
      use_ssl           = true
    },
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application name | `string` | n/a | yes |
| <a name="input_backends"></a> [backends](#input\_backends) | A list of backends | `list(any)` | `[]` | no |
| <a name="input_conditions"></a> [conditions](#input\_conditions) | Conditions | `list(any)` | `[]` | no |
| <a name="input_domains"></a> [domains](#input\_domains) | A list of domains | `list(any)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment this module is deployed into | `string` | n/a | yes |
| <a name="input_ngwaf_agent_level"></a> [ngwaf\_agent\_level](#input\_ngwaf\_agent\_level) | This is the site wide blocking level | `string` | `"log"` | no |
| <a name="input_ngwaf_corp"></a> [ngwaf\_corp](#input\_ngwaf\_corp) | Corp name for NGWAF | `string` | n/a | yes |
| <a name="input_ngwaf_email"></a> [ngwaf\_email](#input\_ngwaf\_email) | Email address associated with the token for the NGWAF API. | `string` | n/a | yes |
| <a name="input_ngwaf_immediate_block"></a> [ngwaf\_immediate\_block](#input\_ngwaf\_immediate\_block) | n/a | `bool` | `true` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project\_id for BigQuery logging | `string` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | The realm this module is deployed into | `string` | n/a | yes |
| <a name="input_subscription_domains"></a> [subscription\_domains](#input\_subscription\_domains) | Domains to issue SSL certificates for | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ngwaf_edgesite"></a> [ngwaf\_edgesite](#output\_ngwaf\_edgesite) | n/a |
