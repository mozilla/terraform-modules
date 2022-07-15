variable "project_id" {
  default     = null
  description = "The project ID in which we're doing this work."
  type        = string
}

variable "environment" {
  default     = null
  description = "Environment to create (like, 'dev', 'stage', or 'prod')"
  type        = string
}

variable "cluster_project_id" {
  default     = null
  description = "The project ID for the GKE cluster this app uses"
  type        = string
}

variable "application" {
  default     = null
  description = "The namespace prefix for the app's namespaces in k8s. Probably just a short name for the app."
  type        = string
}

