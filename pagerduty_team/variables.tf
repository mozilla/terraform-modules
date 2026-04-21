variable "team_name" {
  type        = string
  description = "PagerDuty team name."
}

variable "observer_members" {
  type        = list(string)
  description = "PagerDuty user IDs to add as observers."
  default     = []
}

variable "responder_members" {
  type        = list(string)
  description = "PagerDuty user IDs to add as responders."
  default     = []
}

variable "manager_members" {
  type        = list(string)
  description = "PagerDuty user IDs to add as managers/admins."
  default     = []
}

variable "schedules" {
  description = "Schedules to create for this team."
  type = list(object({
    name                         = string
    time_zone                    = optional(string, "UTC")
    start                        = string
    rotation_virtual_start       = string
    rotation_turn_length_seconds = number
    users                        = list(string) # PD user IDs
  }))
  default = []
}

variable "escalation_policies" {
  description = "Escalation policies to create for this team."
  type = list(object({
    name                             = string
    description                      = optional(string, "")
    num_loops                        = number
    rule_escalation_delay_in_minutes = number
    escalation_rule_schedules        = list(string) # schedule names from var.schedules[*].name
  }))
  default = []
}
