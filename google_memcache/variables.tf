variable "application" {
  description = "Application e.g., bouncer."
  type        = string
}

variable "authorized_network" {
  description = "The network name of the shared VPC - expects the format to be: projects/<project-name>/global/networks/<network-name>"
  type        = string
}

variable "component" {
  description = "A logical component of an application"
  default     = "cache"
}

variable "cpu_count" {
  default = 1
  type    = number
}

variable "custom_name" {
  default     = ""
  description = "Use this field to set a custom name for the memcache instance"
  type        = string
}

variable "environment" {
  description = "Environment e.g., stage."
  type        = string
}

variable "maintenance_duration" {
  description = "The length of the maintenance window in seconds"
  default     = "10800s"
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

variable "memcache_configs" {
  description = "Memcache configs https://cloud.google.com/memorystore/docs/memcached/memcached-configs"
  type        = map(string)
  default     = {}
}

variable "memcache_version" {
  default = "MEMCACHE_1_5"
  type    = string
}

variable "memory_size_mb" {
  description = "Memory size in MiB"
  default     = 1024
  type        = number
}

variable "node_count" {
  default = 1
  type    = number
}

variable "project_id" {
  type    = string
  default = null
}

variable "realm" {
  description = "Realm e.g., nonprod."
  type        = string
}

variable "region" {
  default = null
  type    = string
}
