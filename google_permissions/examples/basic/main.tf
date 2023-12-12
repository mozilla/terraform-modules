module "permissions" {
  source = "github.com/mozilla/terraform-modules//google_permissions?ref=main"
  // it is assumed that you loaded and have available a local.project
  google_folder_id          = local.project.folder.id
  google_prod_project_id    = local.project["prod"].id
  google_nonprod_project_id = local.project["nonprod"].id
  admin_ids                 = ["workgroup:my-project/workgroup_subgroup"]
  developer_ids             = ["workgroup:my-project/developers"]
  viewer_ids                = ["workgroup:my-project/viewers"]
}