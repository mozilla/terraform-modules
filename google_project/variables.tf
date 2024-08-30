variable "app_code" {
  default     = ""
  description = "Defaults to project_name. Used for labels and metadata on application-related resources. See https://github.com/mozilla-services/inventory/blob/master/application_component_registry.csv."
  type        = string
}

variable "billing_account_id" {
  description = "Associated billing account"
  type        = string
}

variable "component_code" {
  default     = ""
  description = "Defaults to app_code-uncat. See https://github.com/mozilla-services/inventory/blob/master/application_component_registry.csv"
}

variable "cost_center" {
  description = "Cost center of the project or resource. Default is 5650 (Services Engineering)"
  default     = "5650"
  type        = string
}

variable "display_name" {
  default     = ""
  description = "Display name for the project. Defaults to project_name"
  type        = string
}

variable "additional_data_access_logs" {
  default     = []
  description = "Additional services that data access logs should be included for. Google Cloud services with audit logs: https://cloud.google.com/logging/docs/audit/services ."
  type        = list(string)

  validation {
    condition = alltrue([
      for v in var.additional_data_access_logs : endswith(v, ".googleapis.com")
    ])
    error_message = "The Google Cloud service must end with .googleapis.com . Google Cloud services with audit logs: https://cloud.google.com/logging/docs/audit/services ."
  }
}

variable "parent_id" {
  description = "Parent folder (with GCP)."
  type        = string
}

variable "project_name" {
  description = "Name of project e.g., autopush"
  type        = string
}

variable "project_id" {
  default     = ""
  description = "Override default project id. Only use if the project id is already taken."
  type        = string
}

variable "extra_project_labels" {
  description = "Extra project labels (a map of key/value pairs) to be applied to the Project."
  type        = map(string)
  default     = {}
}

variable "risk_level" {
  default     = ""
  description = "Level of risk the project poses, usually obtained from an RRA"
  type        = string
}

#
# Variables to possibly Archive?
#

variable "program_code" {
  description = "Program Code of the project or resource: https://mana.mozilla.org/wiki/display/FINArchive/Program+Codes. Drop the `PC - `, lowercase the string and substitute spaces for dashes."
  default     = "firefox-services"
  type        = string

  validation {
    condition     = !contains(["PC - "], var.program_code)
    error_message = "Drop the `PC - `, lowercase the string, and substitute spaces for dashes."
  }
}

variable "program_name" {
  description = "Name of the Firefox program being one of: ci, data, infrastructure, services, web."
  default     = "services"
  type        = string

  validation {
    condition     = contains(["ci", "data", "infrastructure", "security", "services", "web"], var.program_name)
    error_message = "Valid values for program_name: ci, data, infrastructure, services, web."
  }
}

variable "project_services" {
  description = "List of google_project_service APIs to enable."
  default     = []
  type        = list(string)
}

variable "realm" {
  description = "Realm is a grouping of environments being one of: global, nonprod, prod"
  default     = ""
  type        = string

  validation {
    condition     = contains(["global", "nonprod", "prod"], var.realm)
    error_message = "Valid values for realm: global, nonprod, prod."
  }
}

variable "log_analytics" {
  type        = bool
  description = "Enable log analytics for _Default log bucket"
  default     = false
}
