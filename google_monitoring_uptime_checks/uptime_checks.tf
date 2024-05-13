resource "google_monitoring_uptime_check_config" "https" {
  for_each = { for uptime_check in var.uptime_checks : uptime_check.name => uptime_check }

  display_name = each.value.name
  timeout      = each.value.timeout

  http_check {
    path         = each.value.path
    port         = 443
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"

    labels = {
      project_id = var.project_id
      host       = each.value.host
    }
  }
}
