variable "authorized_network" {
  description = "The network name of the shared VPC - expects the format to be: projects/<project-name>/global/networks/<network-name>"
  type        = string
}

variable "custom_name" {
  default     = ""
  description = "Use this field to set a custom name for the memcache instance"
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

variable "realm" {
  description = "Realm e.g., nonprod."
  type        = string
}

variable "project_id" {
  type    = string
  default = null
}

variable "memory_size_mb" {
  description = "Memory size in MiB"
  default     = 1024
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

variable "region" {
  default = null
  type    = string
}

variable "node_count" {
  default = 1
  type    = number
}

variable "cpu_count" {
  default = 1
  type    = number
}
