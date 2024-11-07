variable "ids" {
  type        = set(string)
  description = "List of workgroup identifiers to look up access for"

  validation {
    condition     = alltrue([for i in var.ids : length(regexall("^workgroup:[a-zA-Z0-9-]+(/[a-zA-Z0-9\\.-]+)?$|^subgroup:[a-zA-Z0-9\\.-]+$", i)) > 0])
    error_message = "Bad workgroup identifier format, must match workgroup:WORKGROUP[/SUBGROUP] or subgroup:SUBGROUP."
  }
}

/* roles can be BigQuery roles and/or basic  roles for dataset"
  https://cloud.google.com/bigquery/docs/access-control-basic-roles
  https://cloud.google.com/bigquery/docs/access-control#bigquery
  example
    metadata_viewer = "roles/bigquery.metadataViewer"
    read            = "READER"
    write           = "WRITER"
  */

variable "roles" {
  type        = map(string)
  description = "List of roles to generate bigquery acls for"
  default     = {}
}

variable "terraform_remote_state_bucket" {
  type        = string
  description = "The GCS bucket used for terraform state that contains the expected workgroups output"
  default     = "moz-fx-platform-mgmt-global-tf"
}

variable "terraform_remote_state_prefix" {
  type        = string
  description = "The path prefix where the terraform state file is located"
  default     = "projects/google-workspace-management"
}

variable "workgroup_outputs" {
  default     = ["members", "google_groups"]
  type        = list(any)
  description = "Expected outputs from workgroup output definition"
  # output can be ["bigquery_acls", "members", "service_accounts", "google_groups"]
}
