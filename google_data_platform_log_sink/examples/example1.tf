# send all logs in this project to the Data Platform's stage logging topic
module "stage" {
  source      = "github.com/mozilla/terraform-modules//google_data_platform_log_sink?ref=main"
  project     = "my-project"
  environment = "stage"
  realm       = "nonprod"
  log_filter  = "TRUE"
}
