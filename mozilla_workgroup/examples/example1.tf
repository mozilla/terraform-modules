module "workgroup" {
  source = "github.com/mozilla/terraform-modules//mozilla_workgroup?ref=main"

  ids                           = ["workgroup:app/admins"]
  roles                         = {}
  workgroup_outputs             = ["members", "google_groups"]
  terraform_remote_state_bucket = "moz-bucket"
  terraform_remote_state_prefix = "projects/workgroups"
}
