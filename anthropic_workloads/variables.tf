variable "application" {
  description = "The name of the application (tenant app_code). Every workload name must start with it."
  type        = string
}

variable "workloads" {
  description = <<-EOT
    Workloads that call the Anthropic API with their own OIDC token. The key is the name of the
    service account and federation rule, in the form <app_code>-<env_code>-<component_code>.
    claims are the exact claims the identity token must carry.
  EOT
  type = map(object({
    issuer_id    = string
    workspace_id = string
    claims       = map(string)
  }))
  default = {}

  validation {
    condition     = alltrue([for name in keys(var.workloads) : can(regex("^[a-z0-9-]{1,255}$", name))])
    error_message = "Workload names use lowercase letters, numbers, and hyphens only."
  }

  validation {
    condition     = alltrue([for name in keys(var.workloads) : startswith(name, "${var.application}-")])
    error_message = "Workload names must start with the application name followed by a hyphen."
  }

  validation {
    condition     = alltrue([for w in values(var.workloads) : length(w.claims) > 0])
    error_message = "Each workload needs at least one claim to match."
  }
}

variable "audience" {
  description = "Audience the identity token must carry."
  type        = string
  default     = "https://api.anthropic.com"
}
