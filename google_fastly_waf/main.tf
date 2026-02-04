locals {
  domains         = setunion(var.domains, var.subscription_domains)
  log_sample_name = "log_sampling"
}

resource "fastly_service_vcl" "default" {
  name = "${var.application}-${var.realm}-${var.environment}"

  # Toggling staging environment deployment
  # these variables work together and in inverse. I don't see a need
  # to have a separate `activate` toggle right now
  activate = !var.stage
  stage    = var.stage

  version_comment = "Applied via Atlantis at: ${local.pull_request_url}"

  product_enablement {
    brotli_compression = true
    bot_management     = true
  }

  gzip {
    name = "${var.application}-${var.realm}-${var.environment}-compression"
    content_types = [
      "text/html",
      "application/x-javascript",
      "text/css",
      "application/javascript",
      "text/javascript",
      "application/json",
      "application/geo+json",
      "application/wasm",
      "application/vnd.ms-fontobject",
      "application/x-font-opentype",
      "application/x-font-truetype",
      "application/x-font-ttf",
      "application/xml",
      "font/eot",
      "font/opentype",
      "font/otf",
      "image/svg+xml",
      "image/vnd.microsoft.icon",
      "text/plain",
      "text/xml"
    ]
    extensions = ["css", "js", "html", "eot", "ico", "otf", "ttf", "json", "svg", "geojson"]
  }

  dynamic "domain" {
    for_each = local.domains
    content {
      name    = domain.value.name
      comment = lookup(domain.value, "comment", null)
    }
  }

  dynamic "backend" {
    # See https://www.fastly.com/documentation/reference/api/services/backend/
    # for field reference.

    for_each = var.backends
    content {
      name    = backend.value.name
      address = backend.value.address

      connect_timeout    = lookup(backend.value, "connect_timeout", 10000)
      first_byte_timeout = lookup(backend.value, "first_byte_timeout", 60000)
      keepalive_time     = lookup(backend.value, "keepalive_time", 5)
      override_host      = lookup(backend.value, "override_host", "")
      port               = lookup(backend.value, "port", 443)
      request_condition  = lookup(backend.value, "request_condition", "False")
      shield             = lookup(backend.value, "shield", "")
      ssl_sni_hostname   = lookup(backend.value, "ssl_sni_hostname", "")
      use_ssl            = lookup(backend.value, "use_ssl", false)

      # health check is a string, created in another block
      healthcheck = lookup(backend.value, "health_check_name", "")

      # If use_ssl is true, then we force ssl_check_cert as a good security
      # practice. When ssl_check_cert is true, Fastly requires that
      # ssl_cert_hostname to be set. We don't use "lookup" here because we
      # want to fail early if ssl_cert_hostname is not given a value. If we
      # don't fail early, "terraform apply" will fail when it calls Fastly API.
      ssl_check_cert    = lookup(backend.value, "use_ssl", false) ? true : false
      ssl_cert_hostname = lookup(backend.value, "use_ssl", false) ? backend.value.ssl_cert_hostname : ""
    }
  }

  # Allow passing in arbitrary snippets for VCL configuration
  dynamic "snippet" {
    for_each = local.snippets
    content {
      content  = snippet.value.content
      name     = snippet.value.name
      type     = snippet.value.type
      priority = lookup(snippet.value, "priority", null)
    }
  }

  # Allow creating custom response objects. Useful if you want to setup a maintenance page
  # or error responses from Fastly
  #
  dynamic "condition" {
    for_each = var.conditions
    content {
      name      = condition.value.name
      statement = condition.value.statement
      type      = condition.value.type
      priority  = try(condition.value.priority, null)
    }
  }

  dynamic "response_object" {
    for_each = var.response_objects
    iterator = ro
    content {
      name              = ro.value.name
      status            = try(ro.value.status, null)
      response          = try(ro.value.response, null)
      content           = try(ro.value.content, null)
      content_type      = try(ro.value.content_type, null)
      request_condition = try(ro.value.request_condition, null)
      cache_condition   = try(ro.value.cache_condition, null)
    }
  }

  dynamic "cache_setting" {
    for_each = var.cache_settings
    iterator = cs
    content {
      name            = cs.value.name
      action          = try(cs.value.action, null)
      cache_condition = try(cs.value.cache_condition, null)
      stale_ttl       = try(cs.value.stale_ttl, null)
      ttl             = try(cs.value.ttl, null)
    }
  }

  # https://www.fastly.com/documentation/solutions/tutorials/next-gen-waf-edge-integration/
  #### NGWAF Dynamic Snippets and dictionary - MANAGED BY FASTLY - Start
  dynamicsnippet {
    name     = "ngwaf_config_init"
    type     = "init"
    priority = 0
  }

  dynamicsnippet {
    name     = "ngwaf_config_miss"
    type     = "miss"
    priority = 9000
  }

  dynamicsnippet {
    name     = "ngwaf_config_pass"
    type     = "pass"
    priority = 9000
  }

  dynamicsnippet {
    name     = "ngwaf_config_deliver"
    type     = "deliver"
    priority = 9000
  }

  # percentage of traffic going through WAF
  # usually 100%, this is called later in the file to set
  # how much traffic to send to the WAF
  dictionary {
    name = "Edge_Security"
  }
  #### NGWAF Dynamic Snippets and dictionary - MANAGED BY FASTLY - End

  dynamic "healthcheck" {
    # only enable the health on endpoints that need healthcheck enabled
    for_each = { for healthcheck, values in var.backends : healthcheck => values
    if lookup(values, "health_check_enabled", false) }
    content {
      name           = lookup(healthcheck.value, "health_check_name", "")
      host           = healthcheck.value.address
      path           = lookup(healthcheck.value, "health_check_path", "")
      method         = lookup(healthcheck.value, "health_check_method", "")
      check_interval = 50000
    }
  }

  condition {
    name      = "False"
    statement = "false"
    type      = "REQUEST"
  }

  dynamic "condition" {
    for_each = var.log_sampling_enabled ? { "enabled" = true } : {}
    content {
      name      = local.log_sample_name
      statement = "randombool(${var.log_sampling_percent},100)"
      type      = "RESPONSE"
    }
  }

  vcl {
    name = "main"
    content = templatefile("${path.module}/vcl/main.vcl.tftpl",
      {
        realm                  = var.realm,
        environment            = var.environment,
        https_redirect_enabled = var.https_redirect_enabled,
        cache_header           = var.cache_header
      }
    )
    main = true
  }

  default_ttl = 0

  logging_bigquery {
    dataset            = google_bigquery_dataset.fastly.dataset_id
    name               = "bigquery-default"
    project_id         = var.project_id
    table              = google_bigquery_table.fastly.table_id
    account_name       = google_service_account.log_uploader.account_id
    format             = file("${path.module}/logging/bq_format.txt")
    response_condition = var.log_sampling_enabled ? local.log_sample_name : ""
  }

  logging_gcs {
    bucket_name        = google_storage_bucket.fastly.name
    name               = "gcs-default"
    project_id         = var.project_id
    account_name       = google_service_account.log_uploader.account_id
    gzip_level         = 9
    period             = 300 # 5 minutes
    response_condition = var.log_sampling_enabled ? local.log_sample_name : ""
  }
}

#### NGWAF Dynamic Snippets and dictionary - MANAGED BY FASTLY - Start
resource "fastly_service_dynamic_snippet_content" "ngwaf_config_init" {
  for_each = {
    for d in fastly_service_vcl.default.dynamicsnippet : d.name => d if d.name == "ngwaf_config_init"
  }

  service_id      = fastly_service_vcl.default.id
  snippet_id      = each.value.snippet_id
  content         = "### Fastly managed ngwaf_config_init"
  manage_snippets = false
}

resource "fastly_service_dynamic_snippet_content" "ngwaf_config_miss" {
  for_each = {
    for d in fastly_service_vcl.default.dynamicsnippet : d.name => d if d.name == "ngwaf_config_miss"
  }

  service_id      = fastly_service_vcl.default.id
  snippet_id      = each.value.snippet_id
  content         = "### Fastly managed ngwaf_config_miss"
  manage_snippets = false
}

resource "fastly_service_dynamic_snippet_content" "ngwaf_config_pass" {
  for_each = {
    for d in fastly_service_vcl.default.dynamicsnippet : d.name => d if d.name == "ngwaf_config_pass"
  }

  service_id      = fastly_service_vcl.default.id
  snippet_id      = each.value.snippet_id
  content         = "### Fastly managed ngwaf_config_pass"
  manage_snippets = false
}

resource "fastly_service_dynamic_snippet_content" "ngwaf_config_deliver" {
  for_each = {
    for d in fastly_service_vcl.default.dynamicsnippet : d.name => d if d.name == "ngwaf_config_deliver"
  }

  service_id      = fastly_service_vcl.default.id
  snippet_id      = each.value.snippet_id
  content         = "### Fastly managed ngwaf_config_deliver"
  manage_snippets = false
}

#### NGWAF Dynamic Snippets - MANAGED BY FASTLY - End

resource "sigsci_edge_deployment" "ngwaf_edge_site_service" {
  # https://registry.terraform.io/providers/signalsciences/sigsci/latest/docs/resources/edge_deployment
  site_short_name = sigsci_site.ngwaf_edge_site.short_name
}

resource "sigsci_edge_deployment_service" "ngwaf_edge_service_link" {
  # https://registry.terraform.io/providers/signalsciences/sigsci/latest/docs/resources/edge_deployment_service
  site_short_name = sigsci_site.ngwaf_edge_site.short_name
  fastly_sid      = fastly_service_vcl.default.id

  activate_version = true
  percent_enabled  = var.ngwaf_percent_enabled

  depends_on = [
    sigsci_edge_deployment.ngwaf_edge_site_service,
    fastly_service_vcl.default,
    fastly_service_dynamic_snippet_content.ngwaf_config_init,
    fastly_service_dynamic_snippet_content.ngwaf_config_miss,
    fastly_service_dynamic_snippet_content.ngwaf_config_pass,
    fastly_service_dynamic_snippet_content.ngwaf_config_deliver,
    sigsci_site.ngwaf_edge_site,
  ]
}

# This creates the actual WAF object
resource "sigsci_site" "ngwaf_edge_site" {
  short_name             = "${var.application}-${var.realm}-${var.environment}"
  display_name           = "${var.application}-${var.realm}-${var.environment}"
  block_duration_seconds = 86400
  agent_anon_mode        = ""
  agent_level            = var.ngwaf_agent_level # this setting dictates blocking mode
  immediate_block        = var.ngwaf_immediate_block
}

resource "sigsci_edge_deployment_service_backend" "ngwaf_edge_service_backend_sync" {
  site_short_name = sigsci_site.ngwaf_edge_site.short_name
  fastly_sid      = fastly_service_vcl.default.id

  fastly_service_vcl_active_version = fastly_service_vcl.default.active_version

  depends_on = [
    sigsci_edge_deployment_service.ngwaf_edge_service_link,
  ]
}
