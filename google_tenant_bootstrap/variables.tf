variable "project_id" {
  default     = null
  description = "Tenant project ID"
  type        = string
}

variable "realm" {
  description = "Realm: nonprod, prod, mgmt, or global"
  type        = string

  validation {
    condition     = contains(["mgmt", "global", "nonprod", "prod"], var.realm)
    error_message = "Valid values for realm: nonprod, prod, mgmt, or global."
  }
}

variable "circleci_build_repositories" {
  type        = list(string)
  default     = []
  description = "CircleCI repositories (org/repository) that push images"
  validation {
    condition = alltrue([
      for repo in var.circleci_build_repositories :
      can(regex("^\\S+/\\S+$", repo))
    ])
    error_message = "Valid values are in the following format: org/repository."
  }
}

variable "environment" {
  description = "Environment, such as dev, stage, or prod"
  type        = string
}

variable "gha_environments" {
  description = <<-EOT
    GitHub environments the deploy service account accepts. Overrides `environment`.
    Prod deploys need a manual approval step. Do not use this to bypass it.
  EOT
  type        = list(string)
  default     = []
}

variable "function" {
  description = "Function: aiservices, dataservices, sandbox, or webservices"
  type        = string

  validation {
    condition     = contains(["aiservices", "dataservices", "sandbox", "webservices"], var.function)
    error_message = "Valid values for function: aiservices, dataservices, sandbox, webservices."
  }
}

variable "disable_shared_integrations" {
  description = "Skip shared GKE resources. Set for lightweight tenants."
  type        = bool
  default     = false
}

variable "risk_level" {
  description = "Risk level, high or low. Required unless disable_shared_integrations is set."
  type        = string
  default     = null
}

variable "application" {
  description = "Application name (app_code)"
  type        = string
}

variable "wip_project_number" {
  description = "Project number of the workload identity pool"
  type        = number
}

variable "wip_name" {
  default     = "github-actions"
  description = "Workload identity pool name"
  type        = string
}

variable "github_repository" {
  type        = string
  default     = null
  description = <<-EOT
    GitHub repository (org/repository) that builds and deploys. `github_build_repositories`
    and `github_deploy_repositories` override it.
  EOT
  validation {
    condition = (
      var.github_repository == null || can(regex("^\\S+/\\S+$", var.github_repository))
    )
    error_message = "Valid values are in the following format: org/repository."
  }
}

variable "github_deploy_repositories" {
  type        = list(string)
  default     = []
  description = <<-EOT
    GitHub repositories (org/repository) that deploy. Overrides `github_repository` for the
    deploy service account.
  EOT
  validation {
    condition = alltrue([
      for repo in var.github_deploy_repositories :
      can(regex("^\\S+/\\S+$", repo))
    ])
    error_message = "Valid values are in the following format: org/repository."
  }
}

variable "github_build_repositories" {
  type        = list(string)
  default     = []
  description = <<-EOT
    GitHub repositories (org/repository) that push images. Overrides `github_repository` for
    the artifact-writer service account.
  EOT
  validation {
    condition = alltrue([
      for repo in var.github_build_repositories :
      can(regex("^\\S+/\\S+$", repo))
    ])
    error_message = "Valid values are in the following format: org/repository."
  }
}

variable "github_require_build_env" {
  type        = bool
  default     = true
  description = <<-EOT
    Require the GitHub Actions environment "build" to use the artifact-writer service account.
  EOT
}

variable "log_retention_days" {
  type        = number
  description = "Log retention in days"
  default     = 90
}
