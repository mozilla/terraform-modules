
# Synthetic Monitoring checks without Alert Policy

module "synthetic_monitors" {
  source     = "github.com/mozilla/terraform-modules//google_monitoring?ref=main"
  project_id = local.project_id

  synthetic_monitors = [
    {
      name                 = "login-check"
      bucket_name          = "login-monitoring-bucket-unique-123"
      object_name          = "login.zip"
      object_source        = "src/login-check.zip"
      function_name        = "login_function"
      function_description = "test is a test"
      function_location    = "us-central1"
      entry_point          = "LoginCheck"
      memory               = "256M"
      runtime              = "nodejs20"
      timeout              = 60
      secret_key           = "API_KEY"
      secret_name          = "login-monitor-secret"
    },
    {
      name                 = "search-check"
      bucket_name          = "login-monitoring-bucket-unique-123"
      object_name          = "login.zip"
      object_source        = "src/search-check.zip"
      function_name        = "login_function"
      function_description = "test is a test"
      function_location    = "us-central1"
      entry_point          = "LoginCheck"

      runtime     = "nodejs20"
      memory      = "256M"
      timeout     = 60
      secret_key  = "API_KEY"
      secret_name = "search-monitor-secret"
    }
  ]
}

# Synthetic Monitoring Checks with Alert Policy (minimal configuration)

resource "google_monitoring_notification_channel" "dev_team_notification_channel" {
  display_name = "Dev Team"
  type         = "email"
  labels = {
    email_address = "dev_team+alerts@mydomain.com"
  }
  force_delete = false
}

module "synthetic_monitors" {
  source     = "github.com/mozilla/terraform-modules//google_monitoring?ref=main"
  project_id = local.project_id

  synthetic_monitors = [
    {
      name                 = "login-check"
      bucket_name          = "login-monitoring-bucket-unique-123"
      object_name          = "login.zip"
      object_source        = "src/login-check.zip"
      function_name        = "login_function"
      function_description = "test is a test"
      function_location    = "us-central1"
      entry_point          = "LoginCheck"
      memory               = "256M"
      runtime              = "nodejs20"
      timeout              = 60
      secret_key           = "API_KEY"
      secret_name          = "login-monitor-secret"

      alert_policy = {
        enabled = true
        notification_channels = [
          google_monitoring_notification_channel.dev_team_notification_channel.id
        ]
      }
    }
  ]
}

# Synthetic Monitoring Checks with Alert Policy

resource "google_monitoring_notification_channel" "dev_team_notification_channel" {
  display_name = "Dev Team"
  type         = "email"
  labels = {
    email_address = "dev_team+alerts@mydomain.com"
  }
  force_delete = false
}

module "synthetic_monitors" {
  source     = "github.com/mozilla/terraform-modules//google_monitoring?ref=main"
  project_id = local.project_id

  synthetic_monitors = [
    {
      name                 = "login-check"
      bucket_name          = "login-monitoring-bucket-unique-123"
      object_name          = "login.zip"
      object_source        = "src/login-check.zip"
      function_name        = "login_function"
      function_description = "test is a test"
      function_location    = "us-central1"
      entry_point          = "LoginCheck"
      memory               = "256M"
      runtime              = "nodejs20"
      timeout              = 60
      secret_key           = "API_KEY"
      secret_name          = "login-monitor-secret"

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