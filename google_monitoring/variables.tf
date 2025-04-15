variable "project_id" {
  type = string
}

variable "application" {
  description = "Name of the application being monitored"
  type        = string
}

variable "realm" {
  description = "Grouping of environments being one of: nonprod, prod"
  type        = string
}

variable "environment" {
  type        = string
  description = "Environment name."
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
    timeout             = optional(string, "60s")
    period              = optional(string, "300s")
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
