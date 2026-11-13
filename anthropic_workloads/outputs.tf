output "workloads" {
  description = "Federation rule and service account IDs that each workload exchanges its OIDC token against."
  value = {
    for name, w in var.workloads : name => {
      federation_rule_id = anthropic_federation_rule.workloads[name].id
      service_account_id = anthropic_service_account.workloads[name].id
      workspace_id       = w.workspace_id
    }
  }
}
