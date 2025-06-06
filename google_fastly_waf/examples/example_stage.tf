# Fastly supports deploying your VCL to a "staging" environment. This environment
# has a different IP that requires you to override your local `/etc/hosts` to test
# https://docs.fastly.com/products/staging
#
# The workflow to deploy stage would be to add the `stage = true` arguement for
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
