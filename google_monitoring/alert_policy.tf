resource "google_monitoring_alert_policy" "uptime_alert_policies" {
  for_each = {
    for uptime_check in var.uptime_checks :
    uptime_check.name => uptime_check
    if try(uptime_check.alert_policy.enabled, false)
  }

  display_name = "${var.application} Uptime Check Failed - ${each.key}"
  combiner     = "OR"

  conditions {
    display_name = "${var.application} Uptime Check Failure - ${each.key}"

    condition_threshold {
      filter = format(
        "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.\"check_id\"=\"%s\" AND resource.type=\"uptime_url\"",
        google_monitoring_uptime_check_config.https[each.key].uptime_check_id
      )
      comparison      = "COMPARISON_GT"
      duration        = try(each.value.alert_policy.alert_threshold_duration, "300s")
      threshold_value = 1

      trigger {
        count = try(each.value.alert_policy.trigger_count, 1)
      }

      aggregations {
        alignment_period     = try(each.value.alert_policy.alignment_period, "60s")
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.label.*"]
      }
    }
  }

  alert_strategy {
    auto_close           = var.uptime_checks.alert_policy.auto_close
    notification_prompts = ["OPENED", "CLOSED"]
  }

  notification_channels = try(each.value.alert_policy.notification_channels, [])
  severity              = try(each.value.alert_policy.severity, "warning")

  user_labels = {
    realm       = var.realm
    environment = var.environment
    application = var.application
  }

  documentation {
    subject   = "${var.application} Uptime Check Alert - ${each.key}"
    mime_type = "text/markdown"
    content = try(each.value.alert_policy.custom_documentation, <<EOT
    ## ${var.application} Uptime Check Alert
    The `${each.key}` check failed.

    ### Alerting Behavior
    - **Threshold**: ${try(each.value.alert_policy.alert_threshold_duration, "300s")}
    - **Alignment**: ${try(each.value.alert_policy.alignment_period, "60s")}
    - **Trigger**: Fails when ${try(each.value.alert_policy.trigger_count, 1)} time series fail.
    EOT
    )

    dynamic "links" {
      for_each = try(each.value.alert_policy.documentation_links, [])
      content {
        display_name = links.value.display_name
        url          = links.value.url
      }
    }
  }

  enabled = true
}