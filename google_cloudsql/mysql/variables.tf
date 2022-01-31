variable "availability_type" {
  type        = string
  default     = "ZONAL"
  description = "https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance#availability_type"
}

variable "custom_database_name" {
  default     = ""
  description = "Use this field for custom database name."
}

variable "custom_replica_name" {
  default     = ""
  description = "Custom database replica name."
}

variable "replica_count" {
  default     = 0
  description = "Number of replicas to create"
}

variable "application" {
  description = "Application e.g., bouncer."
}

variable "environment" {
  description = "Environment e.g., stage."
}

variable "realm" {
  default     = ""
  description = "Realm e.g., nonprod."
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

variable "instance_version" {
  default     = "v1"
  description = "Version of database. Use this field if you need to spin up a new database instance."
}

variable "database_version" {
  default     = "MYSQL_8_0"
  description = "Version of MySQL to run"
}

variable "enable_public_ip" {
  default     = false
  description = "If true, will assign a public IP to database instance."
}

variable "region" {
  default = "us-west1"
}

variable "disk_size" {
  default     = "10"
  description = "Disk size in gigabytes."
}

variable "database_flags" {
  description = "The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)"
  default     = []
  type        = list(object({ name = string, value = string }))
}

variable "network" {
  description = "Network where the private peering should attach."
  default     = "default"
}

variable "force_ha" {
  description = "If set to true, create a mysql replica for HA. Currently the availability_type works only for postgres"
  default     = false
}

variable "authorized_networks" {
  description = "A list of authorized_network maps: https://www.terraform.io/docs/providers/google/r/sql_database_instance.html"
  default     = []
}

variable "ip_configuration_require_ssl" {
  default = true
}
