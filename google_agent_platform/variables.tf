variable "application" {
  description = "The name of the application (tenant app_code)."
  type        = string
}

variable "environment" {
  description = "Environment to create (like, 'dev', 'stage', or 'prod')."
  type        = string
}

variable "project_id" {
  description = "The project the agents run in."
  type        = string
}

variable "deploy_repositories" {
  description = "GitHub repositories, in org/repository format, that can deploy agents to this environment."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for repo in var.deploy_repositories : can(regex("^\\S+/\\S+$", repo))])
    error_message = "Valid values are in the following format: org/repository."
  }
}

variable "deploy_github_environment" {
  description = <<-EOT
    GitHub Actions environment a deploy job must run in to use the deployer service account.
    Set this for prod. When null, any workflow in deploy_repositories can deploy.
  EOT
  type        = string
  default     = null
}

variable "caller_repositories" {
  description = "GitHub repositories, in org/repository format, that invoke agents from CI without deploying them."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for repo in var.caller_repositories : can(regex("^\\S+/\\S+$", repo))])
    error_message = "Valid values are in the following format: org/repository."
  }
}

variable "create_runtime_service_account" {
  description = "Create an agent-runtime service account for agents deployed with service_account instead of Agent Identity."
  type        = bool
  default     = false
}

variable "secret_readers" {
  description = "Extra members that can read the secrets bag, for example a workgroup in nonprod."
  type        = list(string)
  default     = []
}

variable "image_repository" {
  description = "Artifact Registry repository the Reasoning Engine service agent pulls BYOC images from. Null skips the grant."
  type = object({
    project  = string
    location = string
    name     = string
  })
  default = null
}

variable "gcp_organization_id" {
  description = "GCP organization ID, used in the Agent Identity principal."
  type        = number
  default     = 442341870013
}

variable "wip_project_number" {
  description = "The project number of the project the workload identity provider lives in."
  type        = number
}

variable "wip_name" {
  description = "The name of the workload identity provider."
  type        = string
  default     = "github-actions"
}
