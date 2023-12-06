variable "google_folder_id" {
  description = "The ID of the folder to create the project in."
  type        = string
}

/*
* Possible to only create non-prod or prod projects as well as creating both
* code later checks for this.
*/

variable "google_prod_id" {
  description = "The ID of the prod project."
  type        = string
  default     = ""
}

variable "google_nonprod_id" {
  description = "The ID of the nonprod project."
  type        = string
  default     = ""
}

/*
// Optional - if you want to set addtional permissions beyond the core set
*/
variable "other_permissions" {
  default     = []
  description = "List of other additional permissions beyond the core set to allow on the project."
  type        = list(string)
}



/*
// Optional - this sets a special flag that sets permissions on a project as admin only. It is mutually 
// exclusive with the other_permissions variable and with the core set of permissions.
*/
variable "admin_only" {
  default     = false
  description = "Whether or not to create a project with admin-only permissions."
  type        = bool
}

/*
// The following are sets of member lists to add to your project
*/
variable "admin_members" {
  default     = []
  description = "List of admin members to add to the project."
  type        = list(string)
}

variable "developer_members" {
  default     = []
  description = "List of developer members to add to the project."
  type        = list(string)
}

variable "viewer_members" {
  default     = []
  description = "List of viewer members to add to the project."
  type        = list(string)
}