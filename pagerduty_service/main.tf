resource "pagerduty_service" "service" {
  name        = var.name
  description = var.description
  # You thought that 0 is a pretty sensible developer interface to disable a timeout right?
  # But what if you were a some kind of chaos lover and decided "The string 'null' is better"?
  # Well then you'd be the Pagerduty Terraform developers ;(
  # https://github.com/PagerDuty/terraform-provider-pagerduty/blob/960ed279bba2b96608bd04e9abedc140c98e782b/pagerduty/resource_pagerduty_service.go#L381-L399
  auto_resolve_timeout    = var.auto_resolve_timeout == 0 ? "null" : var.auto_resolve_timeout
  acknowledgement_timeout = var.acknowledgement_timeout == 0 ? "null" : var.acknowledgement_timeout

  escalation_policy = local.escalation_policy_id
  alert_creation    = "create_alerts_and_incidents"

  lifecycle {
    precondition {
      condition     = local.escalation_policy_id != null
      error_message = "Escalation policy '${var.escalation_policy_name}' not found in provided escalation_policy_ids map."
    }
  }
}
