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
  # Extra columns come from var.extra_log_fields, which also drives the matching log-format
  # fields in locals.tf, so the two cannot drift: a field present in the format but missing from
  # the schema would make BigQuery reject the insert and drop the whole log line.
  schema = jsonencode(concat(
    local.base_bq_schema,
    [for f in var.extra_log_fields : {
      name        = f.name
      type        = "STRING"
      mode        = "NULLABLE"
      description = f.description
    }],
  ))

  lifecycle {
    precondition {
      condition = length(setintersection(
        toset([for c in local.base_bq_schema : c.name]),
        toset([for f in var.extra_log_fields : f.name]),
      )) == 0
      error_message = "extra_log_fields names must not duplicate a base column in logging/bq_schema.json."
    }
  }
}
