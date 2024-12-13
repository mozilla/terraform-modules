provider "google" {
  impersonate_service_account = "tf-sandbox@moz-fx-sandbox-terraform-admin.iam.gserviceaccount.com"
  region                      = "us-west1"
}

provider "google-beta" {
  impersonate_service_account = "tf-sandbox@moz-fx-sandbox-terraform-admin.iam.gserviceaccount.com"
  region                      = "us-west1"
}