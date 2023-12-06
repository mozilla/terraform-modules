module "permissions" {
  source            = "../../../google_permissions"
  # it is assumed that you loaded and have available a local.project
  google_folder_id  = local.project.folder.id
  google_prod_id    = local.project["prod"].id
  google_nonprod_id = local.project["nonprod"].id
  admin_members     = ["workgroup:my-project/admins"]
  developer_members = ["workgroup:my-project/developers"]
}