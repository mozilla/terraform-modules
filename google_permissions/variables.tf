variable "google_folder_id" {
  description = "The ID of the folder to create the project in."
  type        = string
}

/*
* Possible to only create non-prod or prod projects as well as creating both
* code later checks for this.
*/

variable "google_prod_project_id" {
  description = "The ID of the prod project."
  type        = string
  default     = ""
}

variable "google_nonprod_project_id" {
  description = "The ID of the nonprod project."
  type        = string
  default     = ""
}


/*
//
// ADDITIONAL ROLES - these are roles added in addition to the core roles.
//
*/


locals {
  // This is a list of all the roles that we allow to be added to the projects
  // and that already have have existing supporting resource definitions.
  allowed_roles = [
    "roles/bigquery.jobUser",      // folder level
    "roles/automl.editor",         // project
    "roles/cloudtranslate.editor", // project
    "roles/storage.objectAdmin",   // project
    "roles/translationhub.admin",  // project
    "roles/storage.admin",         // project 
    "roles/cloudsql.admin"         // project 
  ]
}

// roles that are folder-only in scope are in this list
variable "folder_roles" {
  description = "List of roles to apply at the folder level."
  type        = list(string)
  default     = []
}

output "validate_folder_roles" {
  value = null
  precondition {
    condition = alltrue([
      for x in var.folder_roles : contains(local.allowed_roles, x)
    ])
    error_message = "You have specified an invalid folder role."
  }
}

// roles that are intended for the production project are in this list
variable "prod_roles" {
  description = "List of roles to apply to the prod project."
  type        = list(string)
  default     = []
}

output "validate_prod_roles" {
  value = null
  precondition {
    condition = alltrue([
      for x in var.prod_roles : contains(local.allowed_roles, x)
    ])
    error_message = "You have specified an invalid prod role."
  }
}

// roles that are intended for the non-production project are in this list
variable "nonprod_roles" {
  description = "List of roles to apply to the nonprod project."
  type        = list(string)
  default     = []
}

output "validate_nonprod_roles" {
  value = null
  precondition {
    condition = alltrue([
      for x in var.nonprod_roles : contains(local.allowed_roles, x)
    ])
    error_message = "You have specified an invalid nonprod role."
  }
}

/*
// Optional - this sets a special flag that sets  the role on a project as admin only. It is mutually 
// exclusive with the other roles variables and with the core set of roles.
*/
variable "admin_only" {
  default     = false
  description = "Whether or not to create a project with admin-only role."
  type        = bool
}

/*
// The following are sets of user ids to add to your project
*/
variable "admin_ids" {
  default     = []
  description = "List of admin IDs to add to the project."
  type        = list(string)
}

variable "developer_ids" {
  default     = []
  description = "List of developer IDs to add to the project."
  type        = list(string)
}

variable "viewer_ids" {
  default     = []
  description = "List of viewer IDs to add to the project."
  type        = list(string)
}