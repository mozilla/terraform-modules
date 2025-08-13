module "synthetic_monitors" {
  source     = "github.com/mozilla/terraform-modules//google_monitoring?ref=main"
  project_id = local.project_id

  synthetic_monitors = [
    {
      name                 = "login-check"
      bucket_name          = "login-monitoring-bucket-unique-123"
      object_name          = "login.zip"
      object_source        = "src/login-check.zip"
      function_name        = "login_function"
      function_description = "test is a test"
      function_location    = "us-central1"
      entry_point          = "LoginCheck"
      memory               = "256M"
      runtime              = "nodejs20"
      timeout              = 60
      secret_key           = "API_KEY"
      secret_name          = "login-monitor-secret"
    },
    {
      name                 = "search-check"
      bucket_name          = "login-monitoring-bucket-unique-123"
      object_name          = "login.zip"
      object_source        = "src/search-check.zip"
      function_name        = "login_function"
      function_description = "test is a test"
      function_location    = "us-central1"
      entry_point          = "LoginCheck"

      runtime     = "nodejs20"
      memory      = "256M"
      timeout     = 60
      secret_key  = "API_KEY"
      secret_name = "search-monitor-secret"
    }
  ]
}