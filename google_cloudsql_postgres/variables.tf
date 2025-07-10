#
# See https://www.terraform.io/docs/providers/google/r/sql_database_instance.html
# for argument reference for 'sql_database_instance' resource.
#

variable "application" {
  description = "Application e.g., bouncer."
  type        = string
}

variable "authorized_networks" {
  default     = []
  description = "A list of authorized_network maps: https://www.terraform.io/docs/providers/google/r/sql_database_instance.html"
  type        = list(any)
}

variable "availability_type" {
  default     = "REGIONAL"
  description = "high availability (REGIONAL) or single zone (ZONAL)"
  type        = string
}

variable "component" {
  default     = "db"
  description = "A logical component of an application"
  type        = string
}

variable "connector_enforcement" {
  default     = null
  description = "Enables the enforcement of Cloud SQL Auth Proxy or Cloud SQL connectors for all the connections. If enabled, all the direct connections are rejected."
  type        = string

  validation {
    condition     = var.connector_enforcement == null ? true : contains(["NOT_REQUIRED", "REQUIRED"], var.connector_enforcement)
    error_message = "Valid values for connector_enforcement: NOT_REQUIRED, REQUIRED"
  }
}

variable "custom_database_name" {
  default     = ""
  description = "Use this field for custom database name."
  type        = string
}

variable "custom_replica_name" {
  default     = ""
  description = "Custom database replica name."
  type        = string
}

variable "data_cache_enabled" {
  default     = true
  description = "Whether data cache is enabled for the instance. Only available for `ENTERPRISE_PLUS` edition instances."
  type        = bool
}

variable "database_flags" {
  default     = []
  description = "A list of database flag maps: https://www.terraform.io/docs/providers/google/r/sql_database_instance.html"
  type        = list(any)
}

variable "database_version" {
  default     = "POSTGRES_17"
  description = "Postgres version e.g., POSTGRES_17"
  type        = string
}

variable "db_cpu" {
  default     = "2"
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing"
  type        = string
}

variable "db_mem_gb" {
  default     = "12"
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing"
  type        = string
}

variable "deletion_protection" {
  default     = true
  description = "Whether the instance is protected from deletion (TF)"
  type        = bool
}

variable "deletion_protection_enabled" {
  default     = true
  description = "Whether the instance is protected from deletion (API)"
  type        = bool
}

variable "edition" {
  default     = "ENTERPRISE"
  description = "The edition of the instance, can be `ENTERPRISE` or `ENTERPRISE_PLUS`."
  type        = string
}

variable "enable_insights_config_on_replica" {
  default     = false
  description = "If true, will allow enable insights config on replica"
  type        = bool
}

variable "enable_private_path_for_google_cloud_services" {
  default     = false
  description = "If true, will allow Google Cloud Services access over private IP."
  type        = bool
}

variable "enable_public_ip" {
  default     = false
  description = "If true, will assign a public IP to database instance."
  type        = bool
}

variable "environment" {
  description = "Environment e.g., stage."
  type        = string
}

variable "instance_version" {
  default     = "v1"
  description = "Version of database. Use this field if you need to spin up a new database instance."
  type        = string
}

variable "ip_configuration_ssl_mode" {
  default     = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"
  description = "Specify how SSL connection should be enforced in DB connections. Supported values are ALLOW_UNENCRYPTED_AND_ENCRYPTED, ENCRYPTED_ONLY, and TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
  type        = string
  validation {
    condition     = contains(["ALLOW_UNENCRYPTED_AND_ENCRYPTED", "ENCRYPTED_ONLY", "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"], var.ip_configuration_ssl_mode)
    error_message = "The ip_configuration_ssl_mode value must be one of ALLOW_UNENCRYPTED_AND_ENCRYPTED, ENCRYPTED_ONLY, or TRUSTED_CLIENT_CERTIFICATE_REQUIRED. Also ensure that ip_configuration_require_ssl value matches this variable."
  }
}

variable "maintenance_window_day" {
  # Monday
  default     = 1
  description = "Maintenance window day"
  type        = number
}

variable "maintenance_window_hour" {
  # UTC hour
  default     = 17
  description = "Maintenance window hour"
  type        = number
}

variable "maintenance_window_update_track" {
  default     = "stable"
  description = "Receive updates after one week (canary) or after two weeks (stable) or after five weeks (week5) of notification."
  type        = string
}

variable "network" {
  default     = "default"
  description = "Network where the private peering should attach."
  type        = string
}

variable "password_validation_policy_complexity" {
  default     = false
  description = "Require complex password, must contain an uppercase letter, lowercase letter, number, and symbol"
  type        = bool
}

variable "password_validation_policy_disallow_username_substring" {
  default     = false
  description = "Prevents the use of the username in the password"
  type        = bool
}

variable "password_validation_policy_enable" {
  default     = false
  description = "Enable password validation policy"
  type        = bool
}

variable "password_validation_policy_min_length" {
  default     = 0
  description = "Min length for password"
  type        = number
}

variable "password_validation_policy_password_change_interval" {
  default     = "0s"
  description = "Specifies the minimum duration after which you can change the password in hours"
  type        = string
}

variable "password_validation_policy_reuse_interval" {
  default     = 0
  description = "Specifies the number of previous passwords that can't be reused"
  type        = number
}

variable "project_id" {
  default     = null
  description = "GCP Project ID"
  type        = string
}

variable "psc_allowed_consumer_projects" {
  default     = []
  description = "List of consumer projects that are allow-listed for PSC connections to this instance"
  type        = list(string)
}

variable "psc_auto_connections" {
  default     = []
  description = "List of consumer networks and projects to automatically create PSC connections in. Requires a service connection policy in the consumer network project to work"
  type        = list(object({ consumer_network = string, consumer_service_project_id = string }))
}

variable "psc_enabled" {
  default     = false
  description = "Whether PSC connectivity is enabled for this instance"
  type        = bool
}

variable "query_plans_per_minute" {
  description = "Query Insights: sampling rate"
  default     = 5
  type        = number
}

variable "query_string_length" {
  description = "Query Insights: length of queries"
  default     = 1024
  type        = number
}

variable "realm" {
  description = "Realm e.g., nonprod."
  type        = string
}

variable "record_client_address" {
  description = "Query Insights: store client IP address"
  default     = true
  type        = bool
}

variable "region" {
  default     = "us-west1"
  description = "Region where database should be provisioned."
  type        = string
}

variable "replica_availability_type" {
  default     = "ZONAL"
  description = "Allow setting availability configuration of replica"
  type        = string
}

variable "replica_count" {
  default     = 0
  description = "Number of instances"
  type        = number
}

variable "replica_data_cache_enabled" {
  default     = true
  description = "Whether data cache is enabled for the replica instance. Only available for `ENTERPRISE_PLUS` edition instances."
  type        = bool
}

variable "replica_db_cpu" {
  default     = "2"
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing"
  type        = string
}

variable "replica_db_mem_gb" {
  default     = "12"
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing"
  type        = string
}

variable "replica_edition" {
  default     = "ENTERPRISE"
  description = "The edition of the replica instance, can be `ENTERPRISE` or `ENTERPRISE_PLUS`."
  type        = string
}

variable "replica_region_override" {
  default     = null
  description = "This OVERRIDES var.region for replicas (replicas use var.region per default)."
  type        = string
}

variable "replica_tier_override" {
  default     = null
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing. This OVERRIDES var.replica_db_cpu and var.replica_db_mem_gb"
  type        = string
}

variable "tier_override" {
  default     = ""
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing. This OVERRIDES var.db_cpu and var.db_mem_gb"
  type        = string
}
