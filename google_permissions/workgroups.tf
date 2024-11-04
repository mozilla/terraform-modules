module "admins_workgroup" {
  source                        = "../google_workgroup"
  ids                           = var.admin_ids
  workgroup_outputs             = ["members", "google_groups"]
  terraform_remote_state_bucket = "moz-fx-platform-mgmt-global-tf"
  terraform_remote_state_prefix = "projects/google-workspace-management"
  roles                         = {}
}

module "developers_workgroup" {
  source                        = "../google_workgroup"
  ids                           = var.developer_ids
  roles                         = {}
  workgroup_outputs             = ["members", "google_groups"]
  terraform_remote_state_bucket = "moz-fx-platform-mgmt-global-tf"
  terraform_remote_state_prefix = "projects/google-workspace-management"
}

module "viewers_workgroup" {
  source                        = "../google_workgroup"
  ids                           = var.viewer_ids
  roles                         = {}
  workgroup_outputs             = ["members", "google_groups"]
  terraform_remote_state_bucket = "moz-fx-platform-mgmt-global-tf"
  terraform_remote_state_prefix = "projects/google-workspace-management"

}