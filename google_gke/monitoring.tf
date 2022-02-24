resource "google_bigquery_dataset" "dataset" {
  count = var.create_resource_usage_export_dataset ? 1 : 0

  dataset_id                  = replace(local.cluster_name, "-", "_")
  friendly_name               = local.cluster_name
  description                 = "Metrics shipped from ${local.cluster_name} GKE Cluster."
  default_table_expiration_ms = 604800000 # 1 week

  labels = local.labels

  access {
    role          = "READER"
    special_group = "projectReaders"
  }

  access {
    role          = "WRITER"
    special_group = "projectWriters"
  }

  access {
    role          = "OWNER"
    special_group = "projectOwners"
  }
}
