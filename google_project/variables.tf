variable "app_code" {
  default     = ""
  description = "Defaults to project_name. Used for labels and metadata on application-related resources."
  type        = string
}

variable "billing_account_id" {
  description = "Associated billing account"
  type        = string
}

variable "component_code" {
  default     = ""
  description = "Defaults to app_code-uncat"
}

variable "cost_center" {
  description = "Cost center of the project or resource. Default is 5650 (Services Engineering)"
  default     = "5650"
  type        = string
}

variable "display_name" {
  default     = ""
  description = "Display name for the project. Defaults to project_name-realm"
  type        = string
}

variable "env_code" {
  default     = ""
  description = "Defaults to realm (e.g. environment). Used for labels and metadata on environment-related resources."
  type        = string
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

variable "realm" {
  description = "Project environment e.g., prod"
  type        = string

  validation {
    condition     = contains(["dev", "global", "prod", "sandbox", "stage"], var.realm)
    error_message = "Valid values for realm: dev, global, prod, sandbox, stage."
  }
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
    condition     = contains(["ci", "data", "infrastructure", "services", "web"], var.program_name)
    error_message = "Valid values for program_name: ci, data, infrastructure, services, web."
  }
}
