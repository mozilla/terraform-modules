## Synthetic Monitoring with Cloud Functions

In addition to HTTP uptime checks, you can deploy Cloud Functions as synthetic monitors using the `cloud_function_synthetic_monitor` module. Each function runs monitoring logic (e.g. Puppeteer) and is invoked by a Cloud Monitoring uptime check.
### What This Module Does

- Provisions a Cloud Function (2nd gen) per monitor
- Uploads source code from a zip file
- Injects a secret via environment variable
- Creates a service account per monitor
- Applies IAM bindings for the runner service account:
  - `roles/secretmanager.secretAccessor`
  - `roles/cloudfunctions.invoker`
- Configures an uptime check for each function
- Create a service account for building the function
- Applies IAM binding for the builder service account:
  - 'roles/logging.logWriter'
  - 'roles/artifactregistry.writer'
  - 'roles/cloudbuild.builds.builder'
  - 'roles/storage.objectViewer' with a condition to buckets which their names follows the format 'gcf-v2-sources-' , 'gcf-v2-uploads-' or 'run-sources-'



## Required Inputs

The following input variables are required:

### <a name="input_application"></a> [application](#input\_application)

Description: Used as default user\_label. Name of the application being monitored

Type: `string`

### <a name="input_environment"></a> [environment](#input\_environment)

Description: Used as default user\_label. Environment name.

Type: `string`

### <a name="input_project_id"></a> [project\_id](#input\_project\_id)

Description: n/a

Type: `string`

### <a name="input_realm"></a> [realm](#input\_realm)

Description: Used as default user\_label. Grouping of environments being one of: nonprod, prod

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_synthetic_monitors"></a> [synthetic\_monitors](#input\_synthetic\_monitors)

Description: List of synthetic monitoring function configurations

Type:

```hcl
list(object({
    name                          = string
    bucket_name                   = string
    object_name                   = string
    object_source                 = string
    function_name                 = string
    function_location             = optional(string, "us-central1")
    function_description          = string
    entry_point                   = string
    runtime                       = optional(string, "nodejs22")
    memory                        = optional(string, "2Gi")
    timeout                       = optional(string, "60")
    secret_key                    = string
    secret_name                   = string
    runtime_service_account_email = optional(string)
    build_service_account_email   = optional(string)

    alert_policy = optional(object({
      enabled                  = optional(bool, false)
      severity                 = optional(string, "WARNING")
      alert_threshold_duration = optional(string, "300s")
      alignment_period         = optional(string, "60s")
      trigger_count            = optional(number, 1)
      auto_close               = optional(string, "7200s")
      notification_channels    = optional(list(string), [])
      documentation_links = optional(list(object({
        display_name = string
        url          = string
      })), [])
      custom_documentation = optional(string)
    }))
  }))
```

Default: `[]`

### <a name="input_uptime_checks"></a> [uptime\_checks](#input\_uptime\_checks)

Description: n/a

Type:

```hcl
list(object({
    name                = string
    host                = string
    path                = string
    request_method      = optional(string, "GET")
    content_type        = optional(string)
    custom_content_type = optional(string)
    body                = optional(string)
    timeout             = optional(string, "30s")
    period              = optional(string, "60s")
    user_labels         = optional(map(string), {})
    selected_regions    = optional(list(string), ["EUROPE", "USA_OREGON", "USA_VIRGINIA"])

    accepted_response_status_codes = optional(list(object({
      status_value = number
    })), [])

    accepted_response_status_classes = optional(list(object({
      status_class = string
    })), [])

    content_matchers = optional(list(object({
      content = optional(string)
      matcher = optional(string)
    })), [])

    alert_policy = optional(object({
      enabled                  = optional(bool, false)
      severity                 = optional(string, "WARNING")
      alert_threshold_duration = optional(string, "300s")
      alignment_period         = optional(string, "60s")
      trigger_count            = optional(number, 1)
      auto_close               = optional(string, "7200s")
      notification_channels    = optional(list(string), [])
      documentation_links = optional(list(object({
        display_name = string
        url          = string
      })), [])
      custom_documentation = optional(string)
    }))
  }))
```

Default: `[]`

## Outputs

The following outputs are exported:

### <a name="output_uptime_checks"></a> [uptime\_checks](#output\_uptime\_checks)

Description: n/a
