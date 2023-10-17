variable "location" {
  type        = string
  default     = "global"
  description = "Location of the logging bucket. Supported regions https://cloud.google.com/logging/docs/region-support#bucket-regions"
}

variable "retention_days" {
  type        = number
  default     = 90
  description = "Log retention for logs, values between 1 and 3650 days"
}

variable "application" {
  type        = string
  description = "Application, e.g. bouncer."
}

variable "environment" {
  type        = string
  description = "Environment, e.g. dev, stage, prod"
}

variable "project" {
  type    = string
  default = null
}

variable "logging_writer_service_account_member" {
  type        = string
  description = "The unique_writer_identity service account that is provisioned when creating a Logging Sink"
}

variable "log_destination" {
  type        = string
  description = "Destination for tenant application logs. Can be bucket or bigquery"
  default     = "bucket"
}

variable "log_analytics" {
  type        = bool
  description = "Enable log analytics for log bucket"
  default     = false
}