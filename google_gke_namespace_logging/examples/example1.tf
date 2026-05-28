module "gke_logging" {
  source = "github.com/mozilla/terraform-modules//google_gke_namespace_logging?ref=google_gke_namespace_logging-1.3.0"

  application                           = "glonk"
  realm                                 = "dev"
  logging_writer_service_account_member = "serviceAccount:test@gcp-sa-logging.iam.gserviceaccount.com"
}
