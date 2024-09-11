variable "entitlement_role_list" {
  default     = []
  description = "List of roles to apply to the admin entitlement in addition to the local default_admin_role_list values."
  type        = list(string)

  validation {
    condition = alltrue([
      for role in var.entitlement_role_list : contains([
        "roles/redis.admin",
        "roles/logging.admin",
        "roles/storage.admin",
        "roles/secretmanager.admin",
        "roles/run.admin"
      ], role)
    ])
    error_message = "Each role in entitlement_role_list must exist in the local allowed_admin_roles_list."
  }
}

variable "entitlement_name" {
  description = "The name of the entitlement."
  type        = string
  default     = "admin-entitlement-01"
}

variable "entitlement_users" {
  description = "List of users to add to the entitlement. Requires 'user:' or 'group:' prefix."
  type        = list(string)
  default     = []
}

variable "admin_email_recipients" {
  description = "List of email addresses to be notified when a principal(requester) is granted access to send admin notifications to. Optional."
  type        = list(string)
  default     = []
}

variable "requester_email_recipients" {
  description = "List of email addresses to be notified to be notified about an eligible entitlement. Optional."
  type        = list(string)
  default     = []
}

variable "require_approver_justification" {
  description = "Whether or not to require approver justification."
  type        = bool
  default     = false
}

variable "number_of_approvals" {
  description = "The number of approvals needed."
  type        = number
  default     = 0
}

variable "approver_principals" {
  description = "List of approver principals. Requires 'user:' or 'group:' prefix."
  type        = list(string)
  default     = []
}

# Additional email addresses to be notified when a grant is pending approval.
variable "approval_email_recipients" {
  description = "Additional email addresses to be notified when a grant is pending approval."
  type        = list(string)
  default     = []
}

variable "entitlement_parent" {
  description = "The parent resource of the entitlement."
  type        = string
  default     = ""  

  validation {
    condition = can(regex("^(projects|folders|organizations)/.*$", var.entitlement_parent))
    error_message = "The entitlement parent must be a project, folder, or organization."
  }
}

variable "max_request_duration" {
  description = "The maximum request duration for the entitlement in seconds."
  type        = number 
  default     = 14400
}
