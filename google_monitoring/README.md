## Examples

### Uptime Checks with Alert Policy (minimal configuration)
```hcl
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
```

### Uptime Checks with Alert Policy
```hcl
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
```


### Uptime Checks without Alert Policy
```hcl
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
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Used as default user\_label. Name of the application being monitored | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Used as default user\_label. Environment name. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | Used as default user\_label. Grouping of environments being one of: nonprod, prod | `string` | n/a | yes |
| <a name="input_uptime_checks"></a> [uptime\_checks](#input\_uptime\_checks) | n/a | <pre>list(object({<br>    name                = string<br>    host                = string<br>    path                = string<br>    request_method      = optional(string, "GET")<br>    content_type        = optional(string)<br>    custom_content_type = optional(string)<br>    body                = optional(string)<br>    timeout             = optional(string, "30s")<br>    period              = optional(string, "60s")<br>    user_labels         = optional(map(string), {})<br>    selected_regions    = optional(list(string), ["EUROPE", "USA_OREGON", "USA_VIRGINIA"])<br><br>    accepted_response_status_codes = optional(list(object({<br>      status_value = number<br>    })), [])<br><br>    accepted_response_status_classes = optional(list(object({<br>      status_class = string<br>    })), [])<br><br>    content_matchers = optional(list(object({<br>      content = optional(string)<br>      matcher = optional(string)<br>    })), [])<br><br>    alert_policy = optional(object({<br>      enabled                  = optional(bool, false)<br>      severity                 = optional(string, "WARNING")<br>      alert_threshold_duration = optional(string, "300s")<br>      alignment_period         = optional(string, "60s")<br>      trigger_count            = optional(number, 1)<br>      auto_close               = optional(string, "7200s")<br>      notification_channels    = optional(list(string), [])<br>      documentation_links = optional(list(object({<br>        display_name = string<br>        url          = string<br>      })), [])<br>      custom_documentation = optional(string)<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_uptime_checks"></a> [uptime\_checks](#output\_uptime\_checks) | n/a |
