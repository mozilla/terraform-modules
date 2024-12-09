/**
 * # Google Permissions
 *
 * This module provides an interface to adding permissions to your google projects and folders.
 *
 * For information on how to add new roles to the modules, please see [this document](./ADDING_NEW_ROLE.md)
 */

// ROLES

resource "google_folder_iam_binding" "viewer" {
  count  = var.admin_only ? 0 : 1
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
  count  = var.admin_only ? 0 : 1
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
  //for_each = module.developers_workgroup.members
  for_each = !var.admin_only && var.google_nonprod_project_id != "" ? toset(module.developers_workgroup.members) : toset([])
  project  = var.google_nonprod_project_id
  role     = "roles/secretmanager.secretAccessor"
  member   = each.value
}

resource "google_project_iam_member" "developers_secretmanager_secretVersionAdder" {
  for_each = !var.admin_only && var.google_nonprod_project_id != "" ? toset(module.developers_workgroup.members) : toset([])
  project  = var.google_nonprod_project_id
  role     = "roles/secretmanager.secretVersionAdder"
  member   = each.value
}

// legacy code

// if admin_only is true OR var.use_entitlements is true, we don't create these permissions at all
resource "google_folder_iam_binding" "owner" {
  count   = var.admin_only || var.entitlement_enabled == true ? 0 : 1
  folder  = var.google_folder_id
  role    = "roles/owner"
  members = module.admins_workgroup.members
}
