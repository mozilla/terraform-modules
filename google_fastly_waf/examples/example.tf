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
