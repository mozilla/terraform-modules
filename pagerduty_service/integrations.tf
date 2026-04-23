locals {
  email_integration_domin = "mozilla.pagerduty.com"
}

# Events API v2 Integration
resource "pagerduty_service_integration" "events_api_v2" {
  count   = lookup(var.integrations, "events_api_v2", false) ? 1 : 0
  name    = "${pagerduty_service.service.id} Events API V2 Integration"
  type    = "events_api_v2_inbound_integration"
  service = pagerduty_service.service.id
}

# Pingdom Integration
data "pagerduty_vendor" "pingdom" {
  count = var.integrations["pingdom"] ? 1 : 0
  name  = "Pingdom"
}

resource "pagerduty_service_integration" "pingdom" {
  count   = var.integrations["pingdom"] ? 1 : 0
  name    = "${pagerduty_service.service.id} Pingdom Integration"
  service = pagerduty_service.service.id
  vendor  = data.pagerduty_vendor.pingdom[0].id
}

# Email Integraton
resource "pagerduty_service_integration" "email" {
  count             = lookup(var.integrations, "email", false) ? 1 : 0
  name              = "${pagerduty_service.service.id} Email Integration"
  type              = "generic_email_inbound_integration"
  service           = pagerduty_service.service.id
  integration_email = "${var.application_name}@${local.email_integration_domin}"
}

# Grafana Integration
resource "pagerduty_service_integration" "grafana" {
  count   = lookup(var.integrations, "grafana", false) ? 1 : 0
  name    = "${pagerduty_service.service.id} Grafana Integration"
  type    = "events_api_v2_inbound_integration"
  service = pagerduty_service.service.id
}

# CloudWatch Integration
data "pagerduty_vendor" "cloudwatch" {
  count = lookup(var.integrations, "cloudwatch", false) ? 1 : 0
  name  = "Cloudwatch"
}

resource "pagerduty_service_integration" "cloudwatch" {
  count   = lookup(var.integrations, "cloudwatch", false) ? 1 : 0
  name    = "${pagerduty_service.service.id} CloudWatch Integration"
  service = pagerduty_service.service.id
  vendor  = data.pagerduty_vendor.cloudwatch[0].id
}

# NewRelic Integration
data "pagerduty_vendor" "newrelic" {
  name = "New Relic"
}

resource "pagerduty_service_integration" "newrelic" {
  count   = lookup(var.integrations, "newrelic", false) ? 1 : 0
  name    = "${pagerduty_service.service.id} NewRelic Integration"
  service = pagerduty_service.service.id
  vendor  = data.pagerduty_vendor.newrelic.id
}

# Stackdriver
data "pagerduty_vendor" "stackdriver" {
  name = "Stackdriver"
}

resource "pagerduty_service_integration" "stackdriver" {
  count   = lookup(var.integrations, "stackdriver", false) ? 1 : 0
  name    = "${pagerduty_service.service.id} Stackdriver Alerting"
  service = pagerduty_service.service.id
  vendor  = data.pagerduty_vendor.stackdriver.id
}

# Nagios
data "pagerduty_vendor" "nagios" {
  name = "Nagios"
}

resource "pagerduty_service_integration" "nagios" {
  count   = lookup(var.integrations, "nagios", false) ? 1 : 0
  name    = "${pagerduty_service.service.id} Nagios Integration"
  service = pagerduty_service.service.id
  vendor  = data.pagerduty_vendor.nagios.id
}
