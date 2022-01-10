variable "additional_principals" {
  default     = []
  description = "List of additional principals' (user, role) ARNs allowed to assume the itse roles defined here."
  type        = list(string)
}

variable "atlantis_principal" {
  description = "AWS account role ARN linked to Atlantis GCP Workload Identity (e.g. entrypoint to all AWS accounts by a given Atlantis)."
  type        = string
}

variable "external_account_id" {
  default     = "177680776199"
  description = "The AWS Account ID whose root user or Terraform role can assume the itse roles. Defaults to mozilla-itsre account."
  type        = string
}

variable "max_session_duration" {
  default     = "43200"
  description = "Maximum session time (in seconds). Defaults to 12 hours (43,200 seconds)."
  type        = string
}

variable "region" {
  default     = "us-west-2"
  description = "Region for AWS Resources (defaults to us-west-2)."
  type        = string
}

