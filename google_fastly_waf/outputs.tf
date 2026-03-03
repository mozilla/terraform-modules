output "ngwaf_edgesite_short_name" {
  value = sigsci_site.ngwaf_edge_site.short_name
}

output "certificate_verification_information" {
  value = fastly_tls_subscription.fastly.*.managed_dns_challenges
}

output "slack_logging_integration_id" {
  value = var.enable_slack_logging_mode_alerts ? sigsci_site_integration.slack_logging_mode_alerts[0].id : null
}
