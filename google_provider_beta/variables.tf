# Core provider configuration
variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The default GCP region"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The default GCP zone"
  type        = string
  default     = null
}

# Application and environment configuration
variable "domain" {
  description = "The domain name"
  type        = string
  default     = null
}

variable "system" {
  description = "The system/application name"
  type        = string
  default     = null
}

variable "component_code" {
  description = "The component code for this infrastructure"
  type        = string
  default     = "notset"
}

variable "realm" {
  description = "The realm (e.g., sandbox, production)"
  type        = string
  default     = "notset"
}

variable "env_code" {
  description = "The environment code (e.g., dev, staging, prod)"
  type        = string
  default     = "notset"
}

# Provider credentials (optional - can use environment variables instead)
variable "credentials" {
  description = "Path to service account key file or JSON string"
  type        = string
  default     = null
  sensitive   = true
}

variable "impersonate_service_account" {
  description = "Service account to impersonate"
  type        = string
  default     = null
}

#
# HOW BEST TO SUPPORT THIS?
#
variable "override_current_tf_version" {
  description = "Override the current Terraform version"
  type        = string
  default     = null
}