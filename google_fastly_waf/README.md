

## Examples

```hcl
module "fastly" {
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
module "fastly_maintenance_page" {
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

  # To create a maintenance page requires two settings.
  # 1. A `condition` which matches all requests, you can modify the "statement"
  #    here if you only want to have maintenance on a particular route or
  #    api endpoint. Setting it to "true" matches all requests
  # 2. A `response_object` which binds to your `condition` and can serve any
  #    static content. Here we have a very basic static HTML page but this could 
  #    be json or an error page etc.

  conditions = [
    {
      name      = "maint-page"
      statement = "true"
      type      = "REQUEST"
      priority  = 0
    }
  ]

  response_objects = [
    {
      name              = "maint-page"
      status            = 200
      content           = <<EOF
<!DOCTYPE html>
<html>
<body>

<h1>Down For Maintenance</h1>

</body>
</html>
EOF
      content_type      = "text/html"
      request_condition = "maint-page"
    }
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
# Fastly supports deploying your VCL to a "staging" environment. This environment
# has a different IP that requires you to override your local `/etc/hosts` to test
# https://docs.fastly.com/products/staging
#
# The workflow to deploy stage would be to add the `stage = true` argument for
# the module, verify your changes look correct, then remove (or comment out) the
# `stage` argument and apply again. This will promote your changes to production.
module "fastly_stage" {
  source      = "github.com/mozilla/terraform-modules//google_fastly_waf?ref=main"
  application = glab
  environment = foo
  project_id  = bar
  realm       = bar

  waf_enabled       = true
  ngwaf_agent_level = "block"
  stage             = true

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
| <a name="input_conditions"></a> [conditions](#input\_conditions) | List of Fastly conditions to create (REQUEST, RESPONSE or CACHE). | <pre>list(object({<br/>    name      = string           # required, unique<br/>    statement = string           # VCL conditional expression<br/>    type      = string           # one of: REQUEST, RESPONSE, CACHE<br/>    priority  = optional(number) # lower runs first, default 10<br/>  }))</pre> | `[]` | no |
| <a name="input_domains"></a> [domains](#input\_domains) | A list of domains | `list(any)` | `[]` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment this module is deployed into | `string` | n/a | yes |
| <a name="input_ngwaf_agent_level"></a> [ngwaf\_agent\_level](#input\_ngwaf\_agent\_level) | This is the site wide blocking level | `string` | `"log"` | no |
| <a name="input_ngwaf_immediate_block"></a> [ngwaf\_immediate\_block](#input\_ngwaf\_immediate\_block) | n/a | `bool` | `true` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The GCP project\_ id for BigQuery logging | `string` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | The realm this module is deployed into | `string` | n/a | yes |
| <a name="input_response_objects"></a> [response\_objects](#input\_response\_objects) | List of synthetic response objects to attach to the Fastly service. | <pre>list(object({<br/>    name              = string           # required<br/>    status            = optional(number) # e.g. 503<br/>    response          = optional(string) # e.g. "Ok"<br/>    content           = optional(string)<br/>    content_type      = optional(string)<br/>    request_condition = optional(string) # name of an existing REQUEST condition<br/>    cache_condition   = optional(string) # name of an existing CACHE   condition<br/>  }))</pre> | `[]` | no |
| <a name="input_snippets"></a> [snippets](#input\_snippets) | snippets | `list(any)` | `[]` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Determine if something should be deployed to stage | `bool` | `false` | no |
| <a name="input_subscription_domains"></a> [subscription\_domains](#input\_subscription\_domains) | Domains to issue SSL certificates for | `list(any)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_verification_information"></a> [certificate\_verification\_information](#output\_certificate\_verification\_information) | n/a |
| <a name="output_ngwaf_edgesite_short_name"></a> [ngwaf\_edgesite\_short\_name](#output\_ngwaf\_edgesite\_short\_name) | n/a |
