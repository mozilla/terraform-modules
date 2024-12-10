variable "app_code" {
  description = "The application code for the permissions. See https://github.com/mozilla-services/inventory/blob/master/application_component_registry.csv."
  type        = string
  default     = ""
}

variable "entitlement_enabled" {
  description = "Whether or not to enable entitlements."
  type        = bool
  default     = false
}

variable "entitlement_data" {
  description = "The entitlement data for the project."
  type = object({
    enabled          = bool
    additional_roles = list(string)
    additional_entitlements = list(object({
      name       = string
      roles      = list(string)
      principals = list(string)
      approval_workflow = optional(object({
        principals = list(string)
      }))
    }))
  })
  default = {
    enabled                 = false
    additional_roles        = []
    additional_entitlements = []
  }
}

variable "entitlement_slack_topic" {
  description = "The name of the pubsub topic to use for slack notifications."
  type        = string
  default     = ""
}

variable "feed_id" {
  description = "The ID of the feed to be created"
  type        = string
  default     = "grant_feed"
}

variable "google_folder_id" {
  description = "The ID of the folder to create the project in."
  type        = string
}

/*
* Possible to only create non-prod or prod projects as well as creating both
* code later checks for this.
*/


// default for both of these is to pull these values from the remote state
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

// roles that are folder-only in scope are in this list
variable "folder_roles" {
  description = "List of roles to apply at the folder level. Also used as the roles in the entitlement."
  type        = list(string)
  default     = []
}

// roles that are intended for the production project are in this list
variable "prod_roles" {
  description = "List of roles to apply to the prod project."
  type        = list(string)
  default     = []
}


// roles that are intended for the non-production project are in this list
variable "nonprod_roles" {
  description = "List of roles to apply to the nonprod project."
  type        = list(string)
  default     = []
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
