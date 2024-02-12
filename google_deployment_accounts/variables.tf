variable "account_id" {
  type        = string
  description = "Name of the service account. Defaults to deploy-<env>"
  default     = null
}

variable "environment" {
  description = "Environment e.g., stage."
  type        = string
}

# Note that it is never wise to use the gha_environments variable to bypass
# any required protection rules you may have for pushing to the production
# environment. Ideally, you should have at least one Github environment that
# requires manual approval for deploying to production, and that particular
# Github environment should be included in the gha_environments list.
variable "gha_environments" {
  description = "Github environments from which to deploy. If specified, this overrides the environment variable."
  type        = list(string)
  default     = []
}

variable "project" {
  type    = string
  default = null
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
  default     = null
}

variable "github_repositories" {
  type        = list(string)
  description = "The Github repositories running the deployment workflows in the format org/repository, will be used if github_repository is not defined"
  default     = []
}