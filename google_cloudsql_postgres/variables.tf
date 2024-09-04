#
# See https://www.terraform.io/docs/providers/google/r/sql_database_instance.html
# for argument reference for 'sql_database_instance' resource.
#

variable "project_id" {
  type    = string
  default = null
}

variable "connector_enforcement" {
  type        = string
  default     = null
  description = "Enables the enforcement of Cloud SQL Auth Proxy or Cloud SQL connectors for all the connections. If enabled, all the direct connections are rejected."

  validation {
    condition     = var.connector_enforcement == null ? true : contains(["NOT_REQUIRED", "REQUIRED"], var.connector_enforcement)
    error_message = "Valid values for connector_enforcement: NOT_REQUIRED, REQUIRED"
  }
}


variable "custom_database_name" {
  default     = ""
  description = "Use this field for custom database name."
}

variable "application" {
  description = "Application e.g., bouncer."
}

variable "data_cache_enabled" {
  type        = bool
  default     = true
  description = "Whether data cache is enabled for the instance. Only available for `ENTERPRISE_PLUS` edition instances."
}

variable "environment" {
  description = "Environment e.g., stage."
}

variable "edition" {
  type        = string
  default     = "ENTERPRISE"
  description = "The edition of the instance, can be `ENTERPRISE` or `ENTERPRISE_PLUS`."
}

variable "component" {
  description = "A logical component of an application"
  default     = "db"
}

variable "realm" {
  description = "Realm e.g., nonprod."
}

variable "deletion_protection" {
  default     = true
  type        = bool
  description = "Whether the instance is protected from deletion (TF)"
}

variable "deletion_protection_enabled" {
  default     = true
  type        = bool
  description = "Whether the instance is protected from deletion (API)"
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

variable "replica_count" {
  default = 0
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

variable "authorized_networks" {
  default = []
}

variable "enable_public_ip" {
  default     = false
  description = "If true, will assign a public IP to database instance."
}

variable "ip_configuration_ssl_mode" {
  default = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
  validation {
    condition     = contains(["ALLOW_UNENCRYPTED_AND_ENCRYPTED", "ENCRYPTED_ONLY", "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"], var.ip_configuration_ssl_mode)
    error_message = "The ip_configuration_ssl_mode value must be one of ALLOW_UNENCRYPTED_AND_ENCRYPTED, ENCRYPTED_ONLY, or TRUSTED_CLIENT_CERTIFICATE_REQUIRED. Also ensure that ip_configuration_require_ssl value matches this variable."
  }
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

variable "enable_private_path_for_google_cloud_services" {
  default     = false
  description = "If true, will allow Google Cloud Services access over private IP."
}

variable "enable_insights_config_on_replica" {
  default     = false
  description = "If true, will allow enable insights config on replica"
}

variable "replica_availability_type" {
  default     = "ZONAL"
  description = "Allow setting availability configuration of replica"
}

variable "custom_replica_name" {
  default     = ""
  description = "Custom database replica name."
}

variable "replica_db_cpu" {
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing"
  default     = "2"
}

variable "replica_db_mem_gb" {
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing"
  default     = "12"
}

variable "replica_tier_override" {
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing. This OVERRIDES var.replica_db_cpu and var.replica_db_mem_gb"
  default     = null
}

variable "replica_region_override" {
  description = "This OVERRIDES var.region for replicas (replicas use var.region per default)."
  default     = null
}
