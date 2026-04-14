### Required

variable "oidc_providers" {
  default     = {}
  description = "Map of GKE clusters and/or Spacelift instances to provision OIDC provider for"
  type = map(object({
    gcp_project_id     = optional(string)
    gcp_region         = optional(string)
    gke_cluster_name   = optional(string)
    spacelift_instance = optional(string)
  }))

  validation {
    condition = alltrue([for k, v in var.oidc_providers :
      (v.gcp_project_id != null && v.gcp_region != null && v.gke_cluster_name != null && v.spacelift_instance == null)
      || (v.gcp_project_id == null && v.gcp_region == null && v.gke_cluster_name == null && v.spacelift_instance != null)
    ])
    error_message = "You must set all variables for GKE clusters (gcp_project_id, gcp_region, and gke_cluster_name) or Spacelift instances (spacelift_instance)"
  }
}
