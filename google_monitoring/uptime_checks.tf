resource "google_monitoring_uptime_check_config" "https" {
  for_each = { for uptime_check in var.uptime_checks : uptime_check.name => uptime_check }

  display_name = each.value.name
  timeout      = each.value.timeout
  period       = each.value.period
  user_labels  = each.value.user_labels

  http_check {
    path                = each.value.path
    port                = 443
    request_method      = each.value.request_method
    use_ssl             = true
    validate_ssl        = true
    content_type        = lookup(each.value, "content_type", null)
    custom_content_type = lookup(each.value, "custom_content_type", null)
    body                = lookup(each.value, "body", null)
  }

  dynamic "content_matchers" {
    for_each = each.value.content_matchers

    content {
      content = content_matchers.value.content
      matcher = content_matchers.value.matcher
    }
  }

  monitored_resource {
    type = "uptime_url"

    labels = {
      project_id = var.project_id
      host       = each.value.host
    }
  }
}
