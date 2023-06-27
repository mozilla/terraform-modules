resource "google_logging_project_bucket_config" "_default" {
  project          = google_project.project.project_id
  location         = "global"
  retention_days   = var._default_bucket_log_retention
  enable_analytics = var._default_bucket_enable_analytics
  bucket_id        = "_Default"
}
