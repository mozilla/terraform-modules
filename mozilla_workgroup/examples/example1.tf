module "workgroup" {
  source = "github.com/mozilla/terraform-modules//mozilla_workgroup?ref=mozilla_workgroup-1.3.0"

  ids                           = ["workgroup:app/admins"]
  roles                         = {}
  workgroup_outputs             = ["members", "google_groups"]
  terraform_remote_state_bucket = "moz-bucket"
  terraform_remote_state_prefix = "projects/workgroups"
}
