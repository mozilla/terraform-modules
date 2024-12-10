data "terraform_remote_state" "projects" {
  backend = "gcs"

  config = {
    bucket                      = "moz-fx-sandbox-terraform-state-global"
    prefix                      = "projects/projects/global"
    impersonate_service_account = "tf-sandbox@moz-fx-sandbox-terraform-admin.iam.gserviceaccount.com"
  }
}

data "terraform_remote_state" "platform_shared" {
  backend = "gcs"

  config = {
    prefix                      = "projects/platform-shared/global"
    bucket                      = "moz-fx-platform-terraform-state-global"
    impersonate_service_account = "tf-sandbox@moz-fx-sandbox-terraform-admin.iam.gserviceaccount.com"
  }
}
