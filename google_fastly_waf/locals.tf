locals {
  waf_bypass_snippet = {
    content  = "set waf.inspection.disabled = true;"
    name     = "bypass_ngwaf"
    type     = "recv"
    priority = 1
  }
  snippets = concat(var.snippets, var.stage ? [local.waf_bypass_snippet] : [])
}
