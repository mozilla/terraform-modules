/**
 * # Google Permissions
 * 
 * This module provides an interface to adding permissions to your google projects and folders.
 * 
 * For information on how to add new roles to the modules, please see [this document](./ADDING_NEW_ROLE.md)
 */

// ENTITLEMENTS

// can't enable API at folder level so have to enable it for each project in folder :(
resource "google_project_service" "pam_prod" {
  count = var.use_entitlements && !var.admin_only ? 1 : 0 // check the flag and only create the module if it is true
  project = var.google_prod_project_id
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "pam_nonprod" {
  count = var.use_entitlements && !var.admin_only ? 1 : 0 // check the flag and only create the module if it is true
  project = var.google_nonprod_project_id
  service = "cloudresourcemanager.googleapis.com"
}

// if create_entitlements is true, we import the entitlements module
module "entitlements" {
  source = "../entitlements"
  count = var.use_entitlements && !var.admin_only ? 1 : 0 // check the flag and only create the module if it is true
  entitlement_name = var.entitlement_name
  entitlement_users = var.entitlement_users
  entitlement_parent = coalesce(var.entitlement_parent, var.google_folder_id) // if entitlement_parent is not set, use the folder id
  number_of_approvals = var.number_of_approvals
  approver_principals = var.approver_principals
  approval_email_recipients = var.approval_email_recipients
  // we use the folder_roles variable to set the roles in the entitlement
  entitlement_role_list = var.entitlement_additional_roles
}

// ROLES

// now we want to set the roles for the users that aren't based on the entitlement, but are their baseline roles - var.user_base_additional_roles

// Iterate over user_base_additional_roles and create google_folder_iam_binding for each role
resource "google_folder_iam_binding" "user_base_roles" {
  for_each = toset(var.user_base_additional_roles)
  count    = var.admin_only ? 0 : 1
  folder   = var.google_folder_id
  role     = each.value
  // apply this to ALL admins, developers, and viewers
  members = setunion(setunion(
    module.developers_workgroup.members,
    module.viewers_workgroup.members
    ), module.admins_workgroup.members)
}


resource "google_folder_iam_binding" "viewer" {
  count   = var.admin_only ? 0 : 1
  folder = var.google_folder_id
  role   = "roles/viewer"
  members = setunion(
    module.developers_workgroup.members,
    module.viewers_workgroup.members
  )
}

//
// additional permissions, folder level
//

// required to grant access to data logs
resource "google_folder_iam_binding" "developers_logging_privateLogViewer" {
  count   = var.admin_only ? 0 : 1
  folder = var.google_folder_id
  role   = "roles/logging.privateLogViewer"
  members = setunion(
    module.developers_workgroup.members,
    module.viewers_workgroup.members
  )
}

//
// Grant the ability to open support tickets to the developers
//
resource "google_folder_iam_binding" "developers_techsupport_editor" {
  count   = var.admin_only ? 0 : 1
  folder  = var.google_folder_id
  role    = "roles/cloudsupport.techSupportEditor"
  members = module.developers_workgroup.members
}

//
// additional permissions, project level
//

// Give developers access to r/w secrets in nonprod
resource "google_project_iam_member" "developers_secretmanager_secretAccessor" {
  count   = var.admin_only ? 0 : 1
  //for_each = module.developers_workgroup.members
  for_each = !var.admin_only && var.google_nonprod_project_id != "" ? toset(module.developers_workgroup.members) : toset([])
  project  = var.google_nonprod_project_id
  role     = "roles/secretmanager.secretAccessor"
  member   = each.value
}

resource "google_project_iam_member" "developers_secretmanager_secretVersionAdder" {
  count   = var.admin_only ? 0 : 1
  for_each = !var.admin_only && var.google_nonprod_project_id != "" ? toset(module.developers_workgroup.members) : toset([])
  project  = var.google_nonprod_project_id
  role     = "roles/secretmanager.secretVersionAdder"
  member   = each.value
}

// legacy code

// if admin_only is true OR var.use_entitlements is true, we don't create these permissions at all
resource "google_folder_iam_binding" "owner" {
  count   = var.admin_only || var.use_entitlements ? 0 : 1
  folder  = var.google_folder_id
  role    = "roles/owner"
  members = module.admins_workgroup.members
}
