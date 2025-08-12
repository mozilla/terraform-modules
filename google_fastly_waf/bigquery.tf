resource "google_bigquery_dataset" "fastly" {
  project    = var.project_id
  dataset_id = "${replace(var.application, "-", "_")}_${var.realm}_${var.environment}_fastly_cdn_logs"
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
    env = "default"
  }

  schema = <<EOF
[
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE",
    "description": "The timestamp"
  },
  {
    "name": "response_state",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "State of Response"
  },
  {
    "name": "response_status",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Status of Response"
  },
  {
    "name": "response_reason",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Response reason"
  },
  {
    "name": "request_referer",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Referrer Information"
  },
  {
    "name": "request_method",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "request_protocol",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "request_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "url",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "URL"
  },
  {
    "name": "waf_executed",
    "type": "BOOLEAN",
    "mode": "NULLABLE",
    "description": "Waf Executed"
  },
  {
    "name": "ngwaf_agentresponse",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Response of Agent"
  },
  {
    "name": "ngwaf_decision_ms",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Decision in MS"
  },
  {
    "name": "ngwaf_signals",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Signals"
  },
  {
    "name": "response_body_bytes_writen",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "Size of body written to request"
  },
]
EOF
}
