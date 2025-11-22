variable "repository_id" {
  type    = string
  default = null
}

variable "format" {
  type    = string
  default = "DOCKER"
}

variable "location" {
  type        = string
  default     = "us"
  description = "Location of the repository. Should generally be set to a multi-region location like 'us' or 'europe'."
}

variable "description" {
  type    = string
  default = null
}

variable "application" {
  type        = string
  description = "Application, e.g. bouncer."
}

variable "realm" {
  description = "Realm, e.g. nonprod."
  type        = string
}

variable "project" {
  type    = string
  default = null
}

variable "repository_readers" {
  type        = list(string)
  default     = []
  description = "List of principals that should be granted read access to the repository."
}

variable "writer_service_account_id" {
  type    = string
  default = "artifact-writer"
}

variable "cleanup_policies" {
  type = map(object({
    id     = string
    action = string
    condition = optional(object({
      tag_state             = optional(string)
      tag_prefixes          = optional(list(string))
      version_name_prefixes = optional(list(string))
      package_name_prefixes = optional(list(string))
      older_than            = optional(string)
      newer_than            = optional(string)
    }))
    most_recent_versions = optional(object({
      package_name_prefixes = optional(list(string))
      keep_count            = optional(number)
    }))
  }))
  default     = {}
  description = "Map of Cleanup Policies https://cloud.google.com/artifact-registry/docs/repositories/cleanup-policy-overview ."
}
