variable "project_id" {
  type = string
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
  }))

  default = []
}
