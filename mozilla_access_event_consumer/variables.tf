variable "project_id" {
  description = "GCP project ID where the consumer resources will be created"
  type        = string
}

variable "application" {
  description = "Name of the application consuming access event notifications (used for resource naming)"
  type        = string
}

variable "environment" {
  description = "Environment name. Used to differentiate resources when deploying multiple environments in the same project."
  type        = string

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "environment must be one of: dev, stage, or prod."
  }
}

variable "central_topic_id" {
  description = "Full resource ID of the central access event topic. Automatically retrieved from remote state. Only override for testing purposes."
  type        = string
  default     = null
}


variable "function_source_dir" {
  description = "Path to the directory containing Cloud Function source code. If provided, deploys a Cloud Function. If not specified, only creates a subscription for GKE usage."
  type        = string
  default     = null

  validation {
    condition     = var.function_source_dir == null || var.function_source_dir != ""
    error_message = "function_source_dir must be either null (for GKE mode) or a non-empty string (for Cloud Function mode). Empty string is not allowed."
  }
}

# Service Account Configuration
variable "service_account_name" {
  description = "Service account ID (defaults to {application}-{environment}-access)"
  type        = string
  default     = null
}

variable "service_account_display_name" {
  description = "Display name for the service account"
  type        = string
  default     = null
}

# Pub/Sub Subscription Configuration
variable "subscription_name" {
  description = "Name of the Pub/Sub subscription (defaults to {application}-{environment}-access-events)"
  type        = string
  default     = null
}

variable "message_retention_duration" {
  description = "How long to retain unacknowledged messages (default: 7 days)"
  type        = string
  default     = "604800s"
}

variable "ack_deadline_seconds" {
  description = "Maximum time after a subscriber receives a message before the subscriber should acknowledge"
  type        = number
  default     = 300
}

variable "retry_minimum_backoff" {
  description = "Minimum delay between retry attempts"
  type        = string
  default     = "10s"
}

variable "retry_maximum_backoff" {
  description = "Maximum delay between retry attempts"
  type        = string
  default     = "600s"
}

variable "dead_letter_topic" {
  description = "Pub/Sub topic for dead letter messages (optional)"
  type        = string
  default     = null
}

variable "max_delivery_attempts" {
  description = "Maximum number of delivery attempts for dead letter policy"
  type        = number
  default     = 5
}

variable "subscription_filter" {
  description = "Filter expression for the subscription (e.g., 'attributes.event_type = \"employee_exit\"')"
  type        = string
  default     = null
}

# Cloud Function Configuration
variable "function_name" {
  description = "Name of the Cloud Function (defaults to {application}-{environment}-access-event-processor)"
  type        = string
  default     = null
}

variable "function_description" {
  description = "Description of the Cloud Function"
  type        = string
  default     = null
}

variable "function_region" {
  description = "GCP region for the Cloud Function, see https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/1286176831/GCP+Regions"
  type        = string
  default     = "us-west1"

  validation {
    condition     = contains(["us-west1", "us-central1", "europe-west1"], var.function_region)
    error_message = "function_region must be one of: us-west1, us-central1, or europe-west1. See https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/1286176831/GCP+Regions for approved regions."
  }
}

variable "function_runtime" {
  description = "Runtime for the Cloud Function (e.g., python312, nodejs20)"
  type        = string
  default     = "python312"
}

variable "function_entry_point" {
  description = "Entry point function name"
  type        = string
  default     = "process_access_event"
}

variable "function_memory" {
  description = "Memory allocated to the function"
  type        = string
  default     = "256Mi"
}

variable "function_timeout" {
  description = "Function timeout in seconds"
  type        = number
  default     = 60
}

variable "function_max_instances" {
  description = "Maximum number of function instances"
  type        = number
  default     = 10
}

variable "function_min_instances" {
  description = "Minimum number of function instances"
  type        = number
  default     = 0
}

variable "function_concurrency" {
  description = "Maximum concurrent requests per instance"
  type        = number
  default     = 1
}

variable "function_environment_variables" {
  description = "Environment variables for the Cloud Function"
  type        = map(string)
  default     = {}
}

variable "function_gsm_environment_variables" {
  description = "Environment variables sourced from Google Secret Manager for the Cloud Function. References existing GSM resources. The consumer is responsible for granting the service account access via roles/secretmanager.secretAccessor. Map of environment variable name to {name = GSM resource name, version = 'latest' or version number}"
  type = map(object({
    name    = string
    version = string
  }))
  default = {}
}

# Alternative Service Account (for GKE mode)
variable "service_account_email" {
  description = "Service account email to use instead of creating one. Required for GKE mode with GKE Workload Identity (e.g., gke-prod@project.iam.gserviceaccount.com). Only used if function_source_dir is null."
  type        = string
  default     = null
}
