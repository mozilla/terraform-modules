resource "google_storage_bucket" "results" {
  project                     = var.project_id
  name                        = "${var.project_id}-ddos-detection"
  location                    = var.region
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  labels                      = var.labels

  lifecycle_rule {
    action { type = "Delete" }
    condition { age = 90 }
  }
}

resource "google_storage_bucket_iam_member" "run_object_creator" {
  bucket = google_storage_bucket.results.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.run.email}"
}
