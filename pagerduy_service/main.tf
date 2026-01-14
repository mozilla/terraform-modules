resource "pagerduty_service" "service" {
  name                    = var.name
  description             = var.description
  auto_resolve_timeout    = var.auto_resolve_timeout
  acknowledgement_timeout = var.acknowledgement_timeout

  escalation_policy = local.escalation_policy_id
  alert_creation          = "create_alerts_and_incidents"

  lifecycle {
    precondition {
      condition     = local.escalation_policy_id != null
      error_message = "Escalation policy '${var.escalation_policy_name}' not found in provided escalation_policy_ids map."
    }
  }
}
