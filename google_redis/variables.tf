variable "authorized_network" {
  description = "The network name of the shared VPC"
  type        = string
}

variable "custom_name" {
  default     = ""
  description = "Use this field to set a custom name for the redis instance"
  type        = string
}

variable "application" {
  description = "Application e.g., bouncer."
  type        = string
}

variable "environment" {
  description = "Environment e.g., stage."
  type        = string
}

variable "component" {
  description = "A logical component of an application"
  default     = "cache"
}

variable "realm" {
  description = "Realm e.g., nonprod."
  type        = string
}

variable "project_id" {
  type    = string
  default = null
}

variable "memory_size_gb" {
  description = "Memory size in GiB"
  default     = 1
  type        = number
}

variable "redis_configs" {
  description = "Redis configs https://cloud.google.com/memorystore/docs/redis/reference/rest/v1/projects.locations.instances#Instance.FIELDS.redis_configs"
  type        = map(string)

}

variable "redis_version" {
  default = "REDIS_6_X"
  type    = string
}

variable "region" {
  default = null
  type    = string
}

variable "tier" {
  description = "Service tier of the instance. Either BASIC or STANDARD_HA"
  type        = string
}

variable "maintenance_window_day" {
  description = "Day of the week maintenance should occur"
  default     = "TUESDAY"
  type        = string
}

variable "maintenance_window_hour" {
  description = "The hour (from 0-23) when maintenance should start"
  default     = 16
  type        = number
}

variable "enable_persistence" {
  description = "Controls whether peristence features are enabled"
  default     = false
  type        = bool
}

variable "transit_encryption_mode" {
  description = "Controls whether tls is enabled"
  default     = "DISABLED"
  type        = string

  validation {
    condition     = can(regex("^(DISABLED|SERVER_AUTHENTICATION)$", var.transit_encryption_mode))
    error_message = "Must be DISABLED or SERVER_AUTHENTICATION."
  }
}

variable "auth_enabled" {
  description = "Controls whether auth is enabled"
  default     = false
  type        = bool
}
