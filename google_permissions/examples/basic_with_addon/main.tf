module "permissions" {
  source = "../../../google_permissions"
  // it is assumed that you loaded and have available a local.project
  google_folder_id          = local.project.folder.id
  google_prod_project_id    = local.project["prod"].id
  google_nonprod_project_id = local.project["nonprod"].id
  admin_ids                 = ["workgroup:my-project/admins"]
  developer_ids             = ["workgroup:my-project/developers"]
  folder_roles = [
    "roles/bigquery.jobUser",
  ]
  prod_roles = [
    "roles/storage.objectAdmin",
    "roles/storage.admin",
    "roles/cloudsql.admin"
  ]
  nonprod_roles = [
    "roles/editor",
    "roles/storage.admin",
    "roles/cloudsql.admin"
  ]
}