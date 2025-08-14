# Uptime Checks without Alert Policy

module "uptime_checks" {
  # Using main branch for simplicity, always pin your dependencies
  source      = "github.com/mozilla/terraform-modules//google_monitoring?ref=main"
  project_id  = local.project_id
  environment = local.environment
  application = local.application
  realm       = local.realm

  uptime_checks = [
    {
      name = local.uptime_check_name
      host = "myservice.mydomain.com"
      path = "/__heartbeat__"

      timeout = "30s"
      period  = "60s"
    }
  ]
}

# Uptime Checks with Alert Policy (minimal configuration)

resource "google_monitoring_notification_channel" "dev_team_notification_channel" {
  display_name = "Dev Team"
  type         = "email"
  labels = {
    email_address = "dev_team+alerts@mydomain.com"
  }
  force_delete = false
}

module "uptime_checks" {
  # Using main branch for simplicity, always pin your dependencies
  source      = "github.com/mozilla/terraform-modules//google_monitoring?ref=main"
  project_id  = local.project_id
  environment = local.environment
  application = local.application
  realm       = local.realm

  uptime_checks = [
    {
      name = local.uptime_check_name
      host = "myservice.mydomain.com"
      path = "/__heartbeat__"

      alert_policy = {
        enabled = true
        notification_channels = [
          google_monitoring_notification_channel.dev_team_notification_channel.id
        ]
      }
    }
  ]
}


# Uptime Checks with Alert Policy

resource "google_monitoring_notification_channel" "dev_team_notification_channel" {
  display_name = "Dev Team"
  type         = "email"
  labels = {
    email_address = "dev_team+alerts@mydomain.com"
  }
  force_delete = false
}

module "uptime_checks" {
  # Using main branch for simplicity, always pin your dependencies
  source      = "github.com/mozilla/terraform-modules//google_monitoring?ref=main"
  project_id  = local.project_id
  environment = local.environment
  application = local.application
  realm       = local.realm

  uptime_checks = [
    {
      name = local.uptime_check_name
      host = "myservice.mydomain.com"
      path = "/__heartbeat__"

      timeout = "30s"
      period  = "60s"

      alert_policy = {
        enabled  = true
        severity = local.realm == "prod" ? "CRITICAL" : "WARNING"
        notification_channels = [
          google_monitoring_notification_channel.dev_team_notification_channel.id
        ]
        alert_threshold_duration = "300s"
        alignment_period         = "60s"
        trigger_count            = 1
        auto_close               = "7200s"
        documentation_links = [
          {
            display_name = "Service Runbook"
            url          = "https://mydomain.atlassian.net/wiki/spaces/FOLDER/pages/1234567/MYSERVICE+Runbook"
          },
          {
            display_name = "Dev Team Slack Channel"
            url          = "https://mydomain.slack.com/archives/ABCDEFG12345"
          }
        ]
      }
    }
  ]
}
