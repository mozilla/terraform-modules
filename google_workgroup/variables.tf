variable "ids" {
  type        = set(string)
  description = "List of workgroup identifiers to look up access for"

  validation {
    condition     = alltrue([for i in var.ids : length(regexall("^workgroup:[a-zA-Z0-9-]+(/[a-zA-Z0-9\\.-]+)?$|^subgroup:[a-zA-Z0-9\\.-]+$", i)) > 0])
    error_message = "Bad workgroup identifier format, must match workgroup:WORKGROUP[/SUBGROUP] or subgroup:SUBGROUP."
  }
}

variable "roles" {
  type        = map(string)
  description = "List of roles to generate bigquery acls for"
  default = {
    metadata_viewer = "roles/bigquery.metadataViewer"
    read            = "READER"
    write           = "WRITER"
  }
}

variable "terraform_remote_state_bucket" {
  type        = string
  description = "The GCS bucket used for terraform state that contains the expected workgroups output"
}

variable "terraform_remote_state_prefix" {
  type        = string
  description = "The path prefix where the terraform state file is located"
}

variable "workgroup_outputs" {
  default     = ["bigquery_acls", "members", "service_accounts", "google_groups"]
  type        = list(any)
  description = "Expected outputs from workgroup output definition"
}
