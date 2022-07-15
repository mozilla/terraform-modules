variable "project" {
  default     = null
  description = "The project ID in which we're doing this work."
  type        = string
}

variable "realm" {
  description = "Name of infrastructure realm (e.g. prod, nonprod, mgmt, or global)."
  type        = string

  validation {
    condition     = contains(["mgmt", "global", "nonprod", "prod"], var.realm)
    error_message = "Valid values for realm: nonprod, prod, mgmt, or global."
  }
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

variable "wip_project_number" {
  type        = number
  description = "The project number of the project the workload identity provider lives in"
}

variable "wip_name" {
  type        = string
  description = "The name of the workload identity provider"
  default     = "github-actions"
}

variable "github_repository" {
  type        = string
  description = "The Github repository running the deployment workflows in the format org/repository"
}
