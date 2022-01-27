#
# See https://www.terraform.io/docs/providers/google/r/sql_database_instance.html
# for argument reference for 'sql_database_instance' resource.
#

variable "project_id" {
}
variable "custom_database_name" {
  default     = ""
  description = "Use this field for custom database name."
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

variable "instance_version" {
  default     = "v1"
  description = "Version of database. Use this field if you need to spin up a new database instance."
}

variable "region" {
  description = "Region where database should be provisioned."
  default     = "us-west1"
}

variable "database_version" {
  default = "POSTGRES_13"
}

variable "db_cpu" {
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing"
  default     = "2"
}

variable "db_mem_gb" {
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing"
  default     = "12"
}

variable "tier_override" {
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing. This OVERRIDES var.db_cpu and var.db_mem_gb"
  default     = ""
}

variable "availability_type" {
  description = "high availability (REGIONAL) or single zone (ZONAL)"
  default     = "REGIONAL"
}

variable "disk_size" {
  default     = "10"
  description = "database instance disk size in GB, minimum 10"
}

variable "ip_configuration_authorized_networks" {
  default = []
}

variable "enable_public_ip" {
  default     = false
  description = "If true, will assign a public IP to database instance."
}

variable "ip_configuration_require_ssl" {
  default = false
}

variable "maintenance_window_day" {
  # Monday
  default = 1
}

variable "maintenance_window_hour" {
  # UTC hour
  default = 17
}

variable "maintenance_window_update_track" {
  default = "stable"
}

variable "network" {
  description = "Network where the private peering should attach."
  default     = "default"
}

variable "database_flags" {
  description = "A list of database flag maps: https://www.terraform.io/docs/providers/google/r/sql_database_instance.html"
  default     = []
}
