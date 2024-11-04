module "admins_workgroup" {
  source                        = "../google_workgroup"
  ids                           = var.admin_ids
  terraform_remote_state_bucket = "moz-fx-platform-mgmt-global-tf"
  terraform_remote_state_prefix = "projects/google-workspace-management"
}

module "developers_workgroup" {
  source                        = "../google_workgroup"
  ids                           = var.developer_ids
  terraform_remote_state_bucket = "moz-fx-platform-mgmt-global-tf"
  terraform_remote_state_prefix = "projects/google-workspace-management"
}

module "viewers_workgroup" {
  source                        = "../google_workgroup"
  ids                           = var.viewer_ids
  terraform_remote_state_bucket = "moz-fx-platform-mgmt-global-tf"
  terraform_remote_state_prefix = "projects/google-workspace-management"
}