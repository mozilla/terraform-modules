### Required 

variable "iam_policy_arns" {
  description = "One or more policy arns to attach to created AWS role" 
  type        = list(string)
}

variable "role_name" {
  description = "Name to give the AWS role"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

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

variable "gke_namespace" {
  description = "Namespace for GKE workload"
  type        = string
}

variable "gke_service_account" {
  description = "GKE service account to grant role assumption privilleges" 
  type        = string
}

### Optional

variable "tags" {
  description = "Tags to apply to all AWS resources"
  type        = map(string)
  default     = {}
}
