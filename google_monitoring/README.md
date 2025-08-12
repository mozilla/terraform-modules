## Uptime Check Configuration Guidelines

Google Cloud Platform provides [1,000,000 free uptime checks per month per project](https://cloud.google.com/monitoring/pricing). Each check is counted **per region**, so selecting more regions and/or decreasing the period between checks can significantly increase your usage.

We divide projects by **realm**, typically using:
- `prod` for production environments
- `nonprod` for development and staging

To help manage cost and alert relevance, we recommend the following defaults and practices:

### Suggested Parameters

| Parameter                 | Recommended Value (prod)                   | Recommended Value (nonprod)                | Notes                                                                                     |
|--------------------------|--------------------------------------------|--------------------------------------------|-------------------------------------------------------------------------------------------|
| `period`                 | `60s`                                      | `300s`                                     | Frequency of uptime checks. Shorter periods result in more checks.                        |
| `timeout`                | `30s`                                      | `30s`                                      | Timeout for each check attempt.                                                           |
| `selected_regions`       | `["EUROPE", "USA_OREGON", "USA_VIRGINIA"]` | `["EUROPE", "USA_OREGON", "USA_VIRGINIA"]` | More regions improve reliability but multiply check count. **Minimum 3 regions are required** |
| `alignment_period`       | `60s`                                      | `300s`                                     | Used in the alert policy time series aggregation. Match to `period`.                      |
| `trigger_count`          | `1`                                        | `1`                                        | Number of violations needed to trigger an alert.                                          |
| `alert_threshold_duration` | `60s`                                      | `300s`                                     | How long a condition must hold true before alerting.                                      |
| `auto_close`             | `86400s` (24h)                             | `7200s`                                    | Automatically closes open incidents after this duration.                                  |

### Cost Example
#### `nonprod` realm example
A single uptime check with:
- `period = 60s`
- `3 selected regions`
- `2 environments` (stage and dev)

Will generate:

```
1 check / minute * 60 * 24 * 30 days = 43,200 checks per region
43,200 * 3 region * 2 environment = 259,200 checks / month
```
#### `prod` realm example
Five uptime check with:
- `period = 60s`
- `3 selected regions`
- `1 environments` (prod)

Will generate:

```
5 checks / minute * 60 * 24 * 30 days = 216,000 checks per region
216,000 * 3 region * 1 environment = 648,000 checks / month
```

Keep this in mind when configuring many services, especially in nonprod realms.

### Fine-Tuning by Realm

You can tailor alert behavior and sensitivity using Terraform expressions. For example:

```hcl
severity = var.realm == "prod" ? "CRITICAL" : "WARNING"
period   = var.realm == "prod" ? "60s" : "300s"
```

This lets you use more sensitive alerting in production, while maintaining cost-effective monitoring in development and staging environments.

### Additional Tips

- Do not use more than the minimum three regions required by GCP for `nonprod` unless you are testing regional availability.
- Avoid setting multiple checks with `period` values of `60s` unless required.
- Consider that `stage` and `dev` environments are both in the same `nonprod` project, thus sharing the same quota.
- Review uptime check and alerting metrics in GCP Monitoring to ensure your settings are appropriate.

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

<!-- BEGIN_TF_DOCS -->


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Used as default user\_label. Name of the application being monitored | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Used as default user\_label. Environment name. | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | Used as default user\_label. Grouping of environments being one of: nonprod, prod | `string` | n/a | yes |
| <a name="input_synthetic_monitors"></a> [synthetic\_monitors](#input\_synthetic\_monitors) | List of synthetic monitoring function configurations | <pre>list(object({<br/>    name                 = string<br/>    location             = optional(list(string), ["EUROPE", "USA_OREGON", "USA_VIRGINIA"])<br/>    bucket_name          = string<br/>    object_name          = string<br/>    object_source        = string<br/>    function_name        = string<br/>    function_location    = optional(string, "us-central1")<br/>    function_description = string<br/>    entry_point          = string<br/>    runtime              = optional(string, "nodejs22")<br/>    memory               = optional(string, "2Gi")<br/>    timeout              = optional(string, "60")<br/>    secret_key           = string<br/>    secret_name          = string<br/><br/>  }))</pre> | `[]` | no |
| <a name="input_uptime_checks"></a> [uptime\_checks](#input\_uptime\_checks) | n/a | <pre>list(object({<br/>    name                = string<br/>    host                = string<br/>    path                = string<br/>    request_method      = optional(string, "GET")<br/>    content_type        = optional(string)<br/>    custom_content_type = optional(string)<br/>    body                = optional(string)<br/>    timeout             = optional(string, "30s")<br/>    period              = optional(string, "60s")<br/>    user_labels         = optional(map(string), {})<br/>    selected_regions    = optional(list(string), ["EUROPE", "USA_OREGON", "USA_VIRGINIA"])<br/><br/>    accepted_response_status_codes = optional(list(object({<br/>      status_value = number<br/>    })), [])<br/><br/>    accepted_response_status_classes = optional(list(object({<br/>      status_class = string<br/>    })), [])<br/><br/>    content_matchers = optional(list(object({<br/>      content = optional(string)<br/>      matcher = optional(string)<br/>    })), [])<br/><br/>    alert_policy = optional(object({<br/>      enabled                  = optional(bool, false)<br/>      severity                 = optional(string, "WARNING")<br/>      alert_threshold_duration = optional(string, "300s")<br/>      alignment_period         = optional(string, "60s")<br/>      trigger_count            = optional(number, 1)<br/>      auto_close               = optional(string, "7200s")<br/>      notification_channels    = optional(list(string), [])<br/>      documentation_links = optional(list(object({<br/>        display_name = string<br/>        url          = string<br/>      })), [])<br/>      custom_documentation = optional(string)<br/>    }))<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_uptime_checks"></a> [uptime\_checks](#output\_uptime\_checks) | n/a |
<!-- END_TF_DOCS -->


## Synthetic Monitoring with Cloud Functions

In addition to HTTP uptime checks, you can deploy Cloud Functions as synthetic monitors using the `cloud_function_synthetic_monitor` module. Each function runs monitoring logic (e.g. Puppeteer) and is invoked by a Cloud Monitoring uptime check.

### What This Module Does

- Provisions a Cloud Function (2nd gen) per monitor
- Uploads source code from a zip file
- Injects a secret via environment variable
- Creates a service account per monitor
- Applies IAM bindings for:
  - `roles/secretmanager.secretAccessor`
  - `roles/cloudfunctions.invoker`
- Configures an uptime check for each function

### Usage

```hcl
module "synthetic_monitors" {
  source = "github.com/mozilla/terraform-modules//cloud_function_synthetic_monitor?ref=main"

  functions = [
    {
      name         = "login-check"
      location     = "us-central1"
      runtime      = "nodejs20"
      source_zip   = "build/login-check.zip"
      memory       = "256M"
      timeout      = 60
      secret_key   = "API_KEY"
      secret_name  = "login-monitor-secret"
    },
    {
      name         = "search-check"
      location     = "us-central1"
      runtime      = "nodejs20"
      source_zip   = "build/search-check.zip"
      memory       = "256M"
      timeout      = 60
      secret_key   = "API_KEY"
      secret_name  = "search-monitor-secret"
    }
  ]
}

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project_id](#input_project_id) | GCP project where all resources will be created | `string` | n/a | yes |
| <a name="input_synthetic_monitors"></a> [synthetic_monitors](#input_synthetic_monitors) | List of synthetic monitoring function configurations | <pre>list(object({<br/>  name                  = string<br/>  location              = optional(list(string), ["EUROPE", "USA_OREGON", "USA_VIRGINIA"])<br/>  bucket_name           = string<br/>  object_name           = string<br/>  object_source         = string<br/>  function_name         = string<br/>  function_location     = optional(string, "us-central1")<br/>  function_description  = string<br/>  entry_point           = string<br/>  runtime               = optional(string, "nodejs22")<br/>  memory                = optional(string, "2Gi")<br/>  timeout               = optional(string, "60")<br/>  secret_key            = string<br/>  secret_name           = string<br/>}))</pre> | `[]` | yes |


<!-- END_TF_DOCS -->
