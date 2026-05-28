module "datastream" {
  source = "github.com/mozilla/terraform-modules//google_datastream?ref=google_datastream-0.3.0"

  application = var.application
  environment = var.environment
  location    = "us-west1"
  project_id  = var.project_id
  realm       = var.realm

  vpc_network       = local.network
  datastream_subnet = "172.19.0.0/29"
}
