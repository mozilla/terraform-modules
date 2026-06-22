output "ngwaf_edgesite_short_name" {
  value = sigsci_site.ngwaf_edge_site.short_name
}

output "certificate_verification_information" {
  value = fastly_tls_subscription.fastly.*.managed_dns_challenges
}

output "bigquery_dataset_id" {
  value       = google_bigquery_dataset.fastly.dataset_id
  description = "Dataset ID of the fastly_cdn_logs dataset created by this module."
}

output "bigquery_table_id" {
  value       = google_bigquery_table.fastly.table_id
  description = "Table ID of the fastly logs table inside the dataset."
}
