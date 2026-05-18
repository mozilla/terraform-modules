variable "app_name" {
  description = "Application name or product name, e.g. autopush"
  type        = string
}

variable "project_id" {
  description = "GCP project_id where the zone will be provisioned."
  type        = string
}

variable "parent_project_id" {
  description = "GCP project_id that contains DNS zones used for delegation"
  type        = string
}

variable "parent_managed_zone" {
  description = "GCP DNS managed zone to add the record."
  type        = string
}

variable "realm" {
  description = "Realm is a grouping of environments being one of: global, nonprod, prod"
  default     = ""
  type        = string

  validation {
    condition     = contains(["global", "mgmt", "nonprod", "prod"], var.realm)
    error_message = "Valid values for realm: global, mgmt, nonprod, prod."
  }
}

variable "team_name" {
  description = "Name of SRE team, which should correspond to the top-level folder name"
  type        = string

  validation {
    condition     = contains(["cloudops", "dataops", "dataservices", "platform", "sandbox", "security", "servicessre", "webservices", "websre"], var.team_name)
    error_message = "Valid values for team_name: cloudops, dataops, dataservices, platform, sandbox, security, servicessre, webservices, websre."
  }
}
