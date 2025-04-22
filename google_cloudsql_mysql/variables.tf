variable "application" {
  description = "Application e.g., bouncer."
  type        = string
}

variable "authorized_networks" {
  description = "A list of authorized_network maps: https://www.terraform.io/docs/providers/google/r/sql_database_instance.html"
  default     = []
  type        = list(any)
}

variable "availability_type" {
  default     = "ZONAL"
  description = "https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#availability_type"
  type        = string
}

variable "component" {
  description = "A logical component of an application"
  default     = "db"
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
  description = "The database flags for the primary instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags#list-flags-mysql)"
  default     = []
  type        = list(object({ name = string, value = string }))
}

variable "database_version" {
  default     = "MYSQL_8_0"
  description = "Version of MySQL to run"
  type        = string
}

variable "db_cpu" {
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing"
  default     = "2"
  type        = string
}

variable "db_mem_gb" {
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing"
  default     = "12"
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

variable "force_ha" {
  description = "If set to true, create a mysql replica for HA. Currently the availability_type works only for postgres"
  default     = false
  type        = bool
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
  # Tuesday
  default     = 2
  description = "Maintenance window day"
  type        = number
}

variable "maintenance_window_hour" {
  # UTC hour
  default     = 16
  description = "Maintenance window hour"
  type        = number
}

variable "maintenance_window_update_track" {
  default     = "stable"
  description = "Receive updates earlier (canary) or later (stable)"
  type        = string
}

variable "network" {
  description = "Network where the private peering should attach."
  default     = "default"
  type        = string
}

variable "project_id" {
  default     = null
  description = "GCP Project ID"
  type        = string
}

variable "query_insights_enabled" {
  description = "Enable / disable Query Insights (See: https://cloud.google.com/sql/docs/mysql/using-query-insights)"
  default     = true
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
  default     = ""
  description = "Realm e.g., nonprod."
  type        = string
}

variable "record_application_tags" {
  description = "Query Insights: storage application tags"
  default     = false
  type        = bool
}

variable "record_client_address" {
  description = "Query Insights: store client IP address"
  default     = false
  type        = bool
}

variable "region" {
  default     = "us-west1"
  description = "Region to use for Google SQL instance"
  type        = string
}

variable "replica_availability_type_override" {
  description = "This OVERRIDES var.availability_type for replicas (replicas use var.availability_type per default).)"
  default     = ""
  type        = string
}

variable "replica_count" {
  default     = 0
  description = "Number of replicas to create"
  type        = number
}

variable "replica_db_cpu" {
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing"
  default     = "2"
  type        = string
}

variable "replica_db_mem_gb" {
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing"
  default     = "12"
  type        = string
}

variable "replica_edition" {
  default     = "ENTERPRISE"
  description = "The edition of the replica instance, can be `ENTERPRISE` or `ENTERPRISE_PLUS`."
  type        = string
}

variable "replica_enable_private_path_for_google_cloud_services" {
  description = "This OVERRIDES var.enable_private_path_for_google_cloud_services for replicas (replicas use var.enable_private_path_for_google_cloud_services per default)."
  default     = null
  type        = bool
}

variable "replica_region_override" {
  description = "This OVERRIDES var.region for replicas (replicas use var.region per default)."
  default     = ""
  type        = string
}

variable "replica_tier_override" {
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing. This OVERRIDES var.replica_db_cpu and var.replica_db_mem_gb"
  default     = ""
  type        = string
}

variable "tier_override" {
  description = "See: https://cloud.google.com/sql/pricing#2nd-gen-pricing. This OVERRIDES var.db_cpu and var.db_mem_gb"
  default     = ""
  type        = string
}
