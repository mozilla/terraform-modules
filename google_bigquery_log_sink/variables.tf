variable "environment" {
  type        = string
  description = "Application environment"
}

variable "project" {
  type        = string
  description = "GCP project ID"
}

variable "sink_name_override" {
  type        = string
  description = "Override the default logging sink name"
  default     = ""
}

variable "dataset_id_override" {
  type        = string
  description = "Override the default dataset id"
  default     = ""
}

variable "use_partitioned_tables" {
  type        = bool
  description = "Enable/disable bigquery partition tables"
  default     = true
}

variable "log_filter" {
  type        = string
  description = "Log filter string, because presumably you don't want everything? Maybe you do? Example: 'resource.type=\"http_load_balancer\" resource.labels.target_proxy_name=\"productdelivery-prod-cdn\"'"
}
