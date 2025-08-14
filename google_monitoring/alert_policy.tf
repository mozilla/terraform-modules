resource "google_monitoring_alert_policy" "uptime_alert_policies" {
  for_each = {
    for uptime_check in var.uptime_checks :
    uptime_check.name => uptime_check
    if try(uptime_check.alert_policy.enabled, false)
  }

  display_name = "${each.key}: Uptime Check Failed"
  combiner     = "OR"

  conditions {
    display_name = "${each.key}: Uptime Check Failure"

    condition_threshold {
      filter = format(
        "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.\"check_id\"=\"%s\" AND resource.type=\"uptime_url\"",
        google_monitoring_uptime_check_config.https[each.key].uptime_check_id
      )
      comparison      = "COMPARISON_GT"
      duration        = each.value.alert_policy.alert_threshold_duration
      threshold_value = 1

      trigger {
        count = each.value.alert_policy.trigger_count
      }

      aggregations {
        alignment_period     = each.value.alert_policy.alignment_period
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.label.*"]
      }
    }
  }

  alert_strategy {
    auto_close           = each.value.alert_policy.auto_close
    notification_prompts = ["OPENED", "CLOSED"]
  }

  notification_channels = each.value.alert_policy.notification_channels
  severity              = each.value.alert_policy.severity

  user_labels = {
    realm       = var.realm
    environment = var.environment
    application = var.application
  }

  documentation {
    subject   = "${each.key}: Uptime Check Alert"
    mime_type = "text/markdown"
    content = coalesce(each.value.alert_policy.custom_documentation, <<EOT
    ## ${var.application} Uptime Check Alert
    The `${each.key}` check failed.

    ### Alerting Behavior
    - **Threshold**: ${each.value.alert_policy.alert_threshold_duration}
    - **Alignment**: ${each.value.alert_policy.alignment_period}
    - **Trigger**: Fails when ${each.value.alert_policy.trigger_count} time series fail.
    EOT
    )

    dynamic "links" {
      for_each = each.value.alert_policy.documentation_links
      content {
        display_name = links.value.display_name
        url          = links.value.url
      }
    }
  }

  enabled = true
}


resource "google_monitoring_alert_policy" "synth_mon_alert_policies" {
  for_each = {
    for synthetic_monitors in var.synthetic_monitors :
    synthetic_monitors.name => synthetic_monitors
    if try(synthetic_monitors.alert_policy.enabled, false)
  }

  display_name = "${each.key}: Uptime Check Failed"
  combiner     = "OR"

  conditions {
    display_name = "${each.key}: Uptime Check Failure"

    condition_threshold {
      filter = format(
        "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.\"check_id\"=\"%s\" AND resource.type=\"uptime_url\"",
        google_monitoring_uptime_check_config.https[each.key].uptime_check_id
      )
      comparison      = "COMPARISON_GT"
      duration        = each.value.alert_policy.alert_threshold_duration
      threshold_value = 1

      trigger {
        count = each.value.alert_policy.trigger_count
      }

      aggregations {
        alignment_period     = each.value.alert_policy.alignment_period
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.label.*"]
      }
    }
  }

  alert_strategy {
    auto_close           = each.value.alert_policy.auto_close
    notification_prompts = ["OPENED", "CLOSED"]
  }

  notification_channels = each.value.alert_policy.notification_channels
  severity              = each.value.alert_policy.severity

  user_labels = {
    realm       = var.realm
    environment = var.environment
    application = var.application
  }

  documentation {
    subject   = "${each.key}: Uptime Check Alert"
    mime_type = "text/markdown"
    content = coalesce(each.value.alert_policy.custom_documentation, <<EOT
    ## ${var.application} Uptime Check Alert
    The `${each.key}` check failed.

    ### Alerting Behavior
    - **Threshold**: ${each.value.alert_policy.alert_threshold_duration}
    - **Alignment**: ${each.value.alert_policy.alignment_period}
    - **Trigger**: Fails when ${each.value.alert_policy.trigger_count} time series fail.
    EOT
    )

    dynamic "links" {
      for_each = each.value.alert_policy.documentation_links
      content {
        display_name = links.value.display_name
        url          = links.value.url
      }
    }
  }

  enabled    = true
  depends_on = [google_monitoring_uptime_check_config.synthetic_monitor]
}
