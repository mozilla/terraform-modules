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
}
