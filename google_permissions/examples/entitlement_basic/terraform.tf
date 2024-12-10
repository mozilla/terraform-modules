terraform {
  backend "gcs" {
    bucket                      = "moz-fx-sandbox-terraform-state-global"
    prefix                      = "projects/testapp5/global"
    impersonate_service_account = "tf-sandbox@moz-fx-sandbox-terraform-admin.iam.gserviceaccount.com"
  }
}
