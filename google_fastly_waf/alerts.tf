# DDoS Protection alerting
# When var.ddos_protection_alert is set, create a Slack integration and a
# Fastly stats alert that fires on the `ddos_protection_requests_detect_count`
# metric (requests classified as DDoS attacks). This is only meaningful when
# ddos_protection is enabled (mode "log" or "block").

locals {
  ddos_protection_alert_enabled = (
    var.ddos_protection_alert != null && var.ddos_protection_alert.enabled
  )
}

resource "fastly_integration" "ddos_protection_slack" {
  count = local.ddos_protection_alert_enabled ? 1 : 0

  name        = "${var.application}-${var.realm}-${var.environment} DDoS Protection Slack integration"
  description = "Slack notifications for Fastly DDoS Protection detection events"
  type        = "slack"

  config = {
    webhook = sensitive(var.ddos_protection_alert.slack_webhook_secret)
  }
}

resource "fastly_alert" "ddos_protection" {
  count = local.ddos_protection_alert_enabled ? 1 : 0

  name = "${var.application}-${var.realm}-${var.environment} DDoS Protection events"
  description = (
    var.ddos_protection_alert.description != null
    ? var.ddos_protection_alert.description
    : "A DDoS event has happened for ${var.application} ${var.environment}"
  )
  service_id = fastly_service_vcl.default.id
  source     = "stats"
  metric     = "ddos_protection_requests_detect_count"

  evaluation_strategy {
    type      = "above_threshold"
    period    = var.ddos_protection_alert.period
    threshold = var.ddos_protection_alert.threshold
  }

  integration_ids = [fastly_integration.ddos_protection_slack[0].id]
}
