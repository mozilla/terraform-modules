module "workgroup" {
  source                        = "../mozilla_workgroup"
  ids                           = var.ids
  roles                         = {}
  workgroup_outputs             = ["members", "google_groups"]
  terraform_remote_state_bucket = "moz-fx-platform-mgmt-global-tf"
  terraform_remote_state_prefix = "projects/google-workspace-management"
}
