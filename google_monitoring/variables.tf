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
    content_matchers = optional(list(object({
      content = optional(string)
      matcher = optional(string)
    })), [])
  }))

  default = []
}
