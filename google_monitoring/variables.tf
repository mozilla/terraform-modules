variable "project_id" {
  type = string
}

variable "application" {
  description = "Used as default user_label. Name of the application being monitored"
  type        = string
}

variable "realm" {
  description = "Used as default user_label. Grouping of environments being one of: nonprod, prod"
  type        = string
}

variable "environment" {
  type        = string
  description = "Used as default user_label. Environment name."
}

variable "uptime_checks" {
  type = list(object({
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
  default = []
}

variable "synthetic_monitors" {
  description = "List of synthetic monitoring function configurations"
  type = list(object({
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
  default = []
}

