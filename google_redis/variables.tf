variable "authorized_network" {
  default = "default"
}

variable "custom_name" {
  default     = ""
  description = "Use this field to set a custom name for the redis instance"
}

variable "application" {
  description = "Application e.g., bouncer."
}

variable "environment" {
  description = "Environment e.g., stage."
}

variable "realm" {
  description = "Realm e.g., nonprod."
}

variable "memory_size_gb" {
  description = "Memory size in GiB"
  default     = 1
}

variable "redis_configs" {
  description = "Redis configs https://cloud.google.com/memorystore/docs/redis/reference/rest/v1/projects.locations.instances#Instance.FIELDS.redis_configs"
  type        = map(any)

}

variable "redis_version" {
  default = "REDIS_6_X"
}

variable "region" {
  default = "us-west1"
}

variable "tier" {
  description = "Service tier of the instance. Either BASIC or STANDARD_HA"
}

variable "maintenance_window_day" {
  description = "Day of the week maintenance should occur"
  default     = "TUESDAY"
}

variable "maintenance_window_hour" {
  description = "The hour (from 0-23) when maintenance should start"
  default     = 16
}