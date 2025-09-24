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
