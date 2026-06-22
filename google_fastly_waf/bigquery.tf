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

locals {
  # Base column definitions for the fastly logs table. Kept as a structured list
  # so policy tags can be injected per-column via var.column_policy_tags.
  fastly_table_columns = [
    { name = "timestamp", type = "TIMESTAMP", description = "The timestamp" },
    { name = "response_state", type = "STRING", description = "State of Response" },
    { name = "response_status", type = "STRING", description = "Status of Response" },
    { name = "response_reason", type = "STRING", description = "Response reason" },
    { name = "request_referer", type = "STRING", description = "Referrer Information" },
    { name = "request_method", type = "STRING", description = null },
    { name = "request_protocol", type = "STRING", description = null },
    { name = "request_user_agent", type = "STRING", description = null },
    { name = "url", type = "STRING", description = "URL" },
    { name = "waf_executed", type = "BOOLEAN", description = "Waf Executed" },
    { name = "ngwaf_agentresponse", type = "STRING", description = "Response of Agent" },
    { name = "ngwaf_decision_ms", type = "STRING", description = "Decision in MS" },
    { name = "ngwaf_signals", type = "STRING", description = "Signals" },
    { name = "response_bytes_written", type = "STRING", description = "Size of body written to request" },
    { name = "ja3", type = "STRING", description = "ja3 of client" },
    { name = "ja4", type = "STRING", description = "ja4 of client" },
    { name = "request_client_ip", type = "STRING", description = "client IP" },
    { name = "h2fp", type = "STRING", description = "HTTP/2 implementation details" },
    { name = "asn", type = "STRING", description = "Autonomous System Number" },
    { name = "ohfp", type = "STRING", description = "order and structure of HTTP headers" },
    { name = "proxy_type", type = "STRING", description = "proxy type" },
    { name = "proxy_desc", type = "STRING", description = "proxy description" },
    { name = "fastly_request_id", type = "STRING", description = "Fastly Request ID" },
  ]

  # Compose the final schema, attaching policy tags from var.column_policy_tags
  # to matching columns. Columns without a tag entry render as before.
  fastly_table_schema = [
    for col in local.fastly_table_columns : merge(
      {
        name = col.name
        type = col.type
        mode = "NULLABLE"
      },
      col.description == null ? {} : { description = col.description },
      contains(keys(var.column_policy_tags), col.name) ? {
        policyTags = { names = var.column_policy_tags[col.name] }
      } : {}
    )
  ]
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

  schema = jsonencode(local.fastly_table_schema)
}
