variable "project_id" {
  type = string
}

variable "uptime_checks" {
  type = list(object({
    name        = string
    host        = string
    path        = string
    timeout     = optional(string, "60s")
    period      = optional(string, "300s")
    user_labels = optional(map(string), {})
  }))

  default = []
}
