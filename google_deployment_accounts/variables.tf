variable "account_id" {
  type        = string
  description = "Name of the service account. Defaults to deploy-ENV."
  default     = null
}

variable "display_name" {
  type        = string
  description = "Display name for the service account. Defaults to \"Deployment to the ENV environment\"."
  default     = null
}

variable "environment" {
  description = "Environment e.g., stage. Not used for OIDC configuration in CircleCI."
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

# For CircleCI, the default options are to deploy from certain repositories
# (any branch) or allow deploys via a CircleCI Context. You can also limit
# CircleCI to deploy from specific branches. For more complex use
# cases (such as CI access to a service account across multiple repositories)
# you can specify those attribute specifiers explicitly instead of the
# convenience variables.
variable "circleci_branches" {
  description = "(CircleCI only) Branches to allow deployments from. If unspecified, allow deployment from all branches."
  type        = set(string)
  default     = []
}

variable "circleci_context_ids" {
  description = "(CircleCI only) Contexts to allow deployments from. Not recommended when using merge queues since CircleCI Contexts are only accessible to members of your organization."
  type        = set(string)
  default     = []
}

variable "circleci_attribute_specifiers" {
  description = "(CircleCI only) Set of attribute specifiers to allow deploys from, in the form ATTR/ATTR_VALUE. If specified, this overrides the github_repository variable and any other CircleCI-specific variables."
  type        = set(string)
  default     = []
  validation {
    condition = alltrue(
      [for attribute_specifier in var.circleci_attribute_specifiers :
        contains(
          [
            "subject",
            "attribute.aud",
            "attribute.vcs",
            "attribute.project",
            "attribute.vcs_origin",
            "attribute.vcs_ref",
            "attribute.context_id"
        ], split("/", attribute_specifier)[0])
      ]
    )
    error_message = "Attribute specifiers must contain a valid attribute prefix."
  }
}

variable "project" {
  type    = string
  default = null
}

variable "wip_project_number" {
  type        = number
  description = "The project number of the project the workload identity provider lives in."
}

variable "wip_name" {
  type        = string
  description = "The name of the workload identity provider. This value implicitly controls whether to provision access to github-actions or circleci."
  default     = "github-actions"
  validation {
    condition     = contains(["github-actions", "circleci"], var.wip_name)
    error_message = "The value of wip_name must be either github-actions or circleci."
  }
}

variable "github_repository" {
  type        = string
  description = "The Github repository running the deployment workflows in the format org/repository. Optional for CircleCI or when github_repositories is specified."
  default     = null
}

variable "github_repositories" {
  type        = list(string)
  description = "The Github repositories running the deployment workflows in the format org/repository, will be used if github_repository is not defined."
  default     = []
}
