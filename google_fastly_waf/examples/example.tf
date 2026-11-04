module "fastly" {
  source      = "github.com/mozilla/terraform-modules//google_fastly_waf?ref=main"
  application = glab
  environment = foo
  project_id  = bar
  realm       = bar

  ngwaf_agent_level = "block"

  # Extra BigQuery log columns, on top of the module's base schema. `expression` is a bare
  # Fastly VCL expression; the module json.escape()s it and adds a STRING column of the same
  # name. Append-only -- BigQuery cannot reorder or drop columns.
  extra_log_fields = [
    {
      name        = "response_content_encoding"
      expression  = "resp.http.Content-Encoding"
      description = "Content-Encoding negotiated for the response (e.g. gzip, br, dcb, dcz)"
    },
  ]

  subscription_domains = [
    { name = "my-app.mozilla.org" }
  ]

  domains = [
    { name = "my-cool-app.global.ssl.fastly.net" },
  ]

  backends = [
    {
      address           = "my_cool_app.net"
      name              = "my-cool-app-net"
      port              = 443
      ssl_cert_hostname = "my_cool_app.net"
      ssl_sni_hostname  = "my_cool_app.net"
      use_ssl           = true
    },
  ]
}
