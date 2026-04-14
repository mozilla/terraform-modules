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

variable "gke_clusters" {
  default     = {}
  description = "GKE clusters to grant role assumption privileges"
  type = map(object({
    gcp_project_id   = string
    gcp_region       = string
    gke_cluster_name = string
  }))
}

variable "k8s_service_accounts" {
  default     = {}
  description = "Map of Kubernetes service accounts that are allowed to assume role. Sub claim format is `system:serviceaccount:$${namespace}:$${service_account}`"
  type = map(object({
    namespace       = string
    service_account = string
  }))
}

variable "spacelift_instance" {
  description = "Spacelift instance to grant role assumption privilleges"
  default     = "mozilla.app.spacelift.io"
  type        = string
}

variable "spacelift_prefixes" {
  description = "List of prefixes for Spacelift spaces/stacks that are allowed to assume role. See sub claim at https://docs.spacelift.io/integrations/cloud-providers/oidc#standard-claims for format"
  default     = []
  type        = list(string)
}
