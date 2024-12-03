### Required 

variable "gcp_region" {
  description = "GKE cluster's GCP region"
  type        = string
}

variable "gcp_project_id" {
  description = "ID of the GKE cluster's project"
  type        = string
}

variable "gke_cluster_name" {
  description = "GKE cluster name"
  type        = string
}
