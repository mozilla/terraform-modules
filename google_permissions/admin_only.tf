resource "google_folder_iam_binding" "folder" {
  count   = var.admin_only ? 1 : 0
  folder  = var.google_folder_id
  role    = "roles/owner"
  members = module.admins_workgroup.members
}
