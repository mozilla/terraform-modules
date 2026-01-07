### Required

variable "iam_policy_arns" {
  description = "One or more policy arns to attach to created AWS role"
  type        = map(string)
}

variable "role_name" {
  description = "Name to give the AWS role"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "gcp_project_id" {
  description = "GKE cluster's project ID"
  type        = string
}

variable "gcp_region" {
  description = "GKE cluster's GCP region"
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

variable "spacelift_instance" {
  description = "Spacelift instance to grant role assumption privilleges"
  default     = "mozilla.app.spacelift.io"
  type        = string
}

variable "space_prefix" {
  description = "Prefix for Spacelift spaces that are allowed to assume role. Spacelift role will not be created if not set"
  default     = ""
  type        = string
}
