resource "google_service_account" "log_uploader" {
  project      = var.project_id
  account_id   = var.service_account != null ? var.service_account : substr("${var.application}-${var.realm}-${var.environment}-fastly", 0, 28)
  display_name = "Fastly Service account for uploading logs"
}

resource "google_bigquery_dataset_iam_member" "edit_datasets" {
  project    = var.project_id
  dataset_id = google_bigquery_dataset.fastly.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_service_account.log_uploader.member
}

resource "google_storage_bucket_iam_member" "fastly_service_account" {
  bucket = google_storage_bucket.fastly.name
  role   = "roles/storage.objectCreator"
  member = google_service_account.log_uploader.member
}

# See https://docs.fastly.com/en/guides/configuring-google-iam-service-account-impersonation-for-fastly-logging
# for the Fastly service account
resource "google_service_account_iam_member" "allow-fastly-to-assume" {
  service_account_id = google_service_account.log_uploader.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:fastly-logging@datalog-bulleit-9e86.iam.gserviceaccount.com"
}
