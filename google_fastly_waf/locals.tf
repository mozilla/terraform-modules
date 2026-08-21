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

  # Base BigQuery log format, used verbatim unless extra fields are configured.
  bq_log_format_file = file("${path.module}/logging/${var.legacy_edge_deployment ? "bq_format.txt" : "bq_format_v2.txt"}")

  # Base BigQuery table schema, mirroring the log format above.
  base_bq_schema = jsondecode(file("${path.module}/logging/bq_schema.json"))

  # Caller-supplied extra columns. The expression is always wrapped in json.escape() and always
  # quoted, so a value can never break the JSON log line -- BigQuery rejects a malformed line by
  # dropping the whole row, which would otherwise let a request suppress its own WAF log entry.
  extra_bq_log_fields = [
    for f in var.extra_log_fields :
    "\"${f.name}\":\"%%{json.escape(${f.expression})}V\""
  ]

  # Services that set no extra fields get the file byte-for-byte.
  bq_log_format = length(var.extra_log_fields) == 0 ? local.bq_log_format_file : "${join(", ", concat(
    [trimspace(trimsuffix(trimspace(local.bq_log_format_file), "}"))],
    local.extra_bq_log_fields,
  ))} }"
}
