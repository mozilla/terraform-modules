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
  description = "Application name, eg. bouncer"
  type        = string
}

variable "gke_sa_secret_ids" {
  description = "list of secret ids gke service account needs to have access to"
  type        = list(string)
  default     = []
}
