variable "project" {
  default     = null
  description = "The project ID in which we're doing this work."
  type        = string
}

variable "realm" {
  description = "Name of infrastructure realm (e.g. prod or nonprod)."
  type        = string

  validation {
    condition     = contains(["mgmt", "nonprod", "prod"], var.realm)
    error_message = "Valid values for realm: mgmt, nonprod, prod."
  }
}

variable "region" {
  default     = null
  description = "Region where cluster & other regional resources should be provisioned."
  type        = string
}

variable "environment" {
  default     = null
  description = "Environment to create (like, 'dev', 'stage', or 'prod')"
  type        = string
}

variable "gke_cluster_project_id" {
  default     = null
  description = "The project ID for the GKE cluster this app uses"
  type        = string
}

variable "application" {
  default     = null
  description = "The name of the application."
  type        = string
}

