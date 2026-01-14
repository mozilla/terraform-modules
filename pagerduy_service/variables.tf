variable "name" {
  type        = string
  description = "PagerDuty service name."
}

variable "description" {
  type        = string
  description = "PagerDuty service description."
  default     = ""
}

variable "application_name" {
  description = "Name of the application"
  type        = string
}

variable "auto_resolve_timeout" {
  type        = number
  description = "Seconds before incidents auto-resolve. 0 disables."
  default     = 0
}

variable "acknowledgement_timeout" {
  type        = number
  description = "Seconds before un-acked incidents re-trigger. 0 disables."
  default     = 0
}

variable "escalation_policy_name" {
  type        = string
  description = "Name of the escalation policy to attach to this service."
}

variable "escalation_policy_ids" {
  type        = map(string)
  description = "Map of escalation policy names to IDs (from pagerduty_team module)."
}


variable "integrations" {
  description = "Which integrations to create/enabled for this service."
  type = object({
    events_api_v2 = optional(bool, false)
    pingdom       = optional(bool, false)
    email         = optional(bool, false)
    cloudwatch    = optional(bool, false)
    grafana       = optional(bool, false)
  })
  default = {}
}
