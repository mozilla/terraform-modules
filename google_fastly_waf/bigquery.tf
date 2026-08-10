resource "google_bigquery_dataset" "fastly" {
  project    = var.project_id
  dataset_id = "${replace(var.application, "-", "_")}_${var.realm}_${replace(var.environment, "-", "_")}_fastly_cdn_logs"
  location   = "US"

  access {
    role          = "OWNER"
    special_group = "projectOwners"
  }

  access {
    role          = "OWNER"
    user_by_email = "tf-webservices@moz-fx-websvc-terraform-admin.iam.gserviceaccount.com"
  }

  access {
    role          = "WRITER"
    special_group = "projectWriters"
  }

  access {
    role          = "WRITER"
    user_by_email = google_service_account.log_uploader.email
  }

  labels = {
    env_code       = var.environment
    realm          = var.realm
    app_code       = var.application
    component_code = "fastly-logs"
  }
}

resource "google_bigquery_table" "fastly" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.fastly.dataset_id
  table_id   = "fastly"

  time_partitioning {
    type          = "DAY"
    expiration_ms = 7776000000 # 90 days
    field         = "timestamp"
  }

  labels = {
    env_code       = var.environment
    realm          = var.realm
    app_code       = var.application
    component_code = "fastly-logs"
  }

  # The base schema lives in logging/bq_schema.json alongside the log formats it mirrors.
  # Optional columns are appended here, gated on the same variable that adds the matching
  # field to the log format in locals.tf. The two must stay in sync: a field present in the
  # format but missing from the schema will make BigQuery reject the insert and drop the log line.
  schema = jsonencode(concat(
    jsondecode(file("${path.module}/logging/bq_schema.json")),
    var.log_response_content_encoding ? [{
      name        = "response_content_encoding"
      type        = "STRING"
      mode        = "NULLABLE"
      description = "Content-Encoding negotiated for the response (e.g. gzip, br, dcb, dcz)"
    }] : [],
  ))
}
