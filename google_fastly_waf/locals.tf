locals {
  waf_bypass_snippet = {
    content  = "set req.http.x-sigsci-no-inspection = \"debug_bypass\";"
    name     = "bypass_ngwaf"
    type     = "recv"
    priority = 1
  }
  # The waf_bypass_snippet relies on the legacy x-sigsci-no-inspection header,
  # which is only honored by the legacy EdgeDeployment integration.
  snippets = var.legacy_edge_deployment ? concat(var.snippets, var.stage ? [local.waf_bypass_snippet] : []) : var.snippets

  # Base BigQuery log format
  bq_log_format_base = trimspace(trimsuffix(
    trimspace(file("${path.module}/logging/${var.legacy_edge_deployment ? "bq_format.txt" : "bq_format_v2.txt"}")),
    "}"
  ))

  # Opt-in response_content_encoding log field
  optional_bq_log_fields = compact([
    var.log_response_content_encoding ? "\"response_content_encoding\":\"%%{json.escape(resp.http.Content-Encoding)}V\"" : "",
  ])

  bq_log_format = "${join(", ", concat([local.bq_log_format_base], local.optional_bq_log_fields))} }"
}
