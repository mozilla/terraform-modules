
resource "google_storage_bucket" "bucket" {
  for_each = { for fn in var.synthetic_monitors : fn.name => fn }
  name     = each.value.bucket_name  # Every bucket name must be globally unique
  location = "US"
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "object" {
  for_each = { for fn in var.synthetic_monitors : fn.name => fn }
  name   = each.key
  bucket = google_storage_bucket.bucket[each.key].name
  source = each.value.object_source # Add path to the zipped function source code
}

resource "google_cloudfunctions2_function" "function" {
  for_each = { for fn in var.synthetic_monitors : fn.name => fn }
  name = each.key
  location = each.value.function_location
  description = each.value.function_description

  build_config {
    runtime = each.value.runtime
    entry_point = each.value.entry_point
    source {
      storage_source {
        bucket = google_storage_bucket.bucket[each.key].name
        object = google_storage_bucket_object.object[each.key].name
      }
    }
  }

  service_config {
    max_instance_count  = 1
    available_memory    = each.value.memory
    timeout_seconds     = each.value.timeout
    service_account_email = google_service_account.function_sa[each.key].email

    secret_environment_variables {
      key        = each.value.secret_key
      project_id = var.project_id
      secret     = google_secret_manager_secret.secret[each.key].secret_id
      version    = "latest"
    }
  }
  depends_on = [google_secret_manager_secret.secret]
}

resource "google_secret_manager_secret" "secret" {
  for_each = { for fn in var.synthetic_monitors : fn.name => fn }
  secret_id = each.value.secret_name

  replication {
    auto {}
  }
}

# Service account per function
resource "google_service_account" "function_sa" {
  for_each = { for fn in var.synthetic_monitors : fn.name => fn }

  account_id   = "${each.key}-sa"
  display_name = "Service account for function ${each.key}"
  project      = var.project_id
}

# IAM: allow service account to access secrets
resource "google_project_iam_member" "secret_access" {
  for_each = { for fn in var.synthetic_monitors : fn.name => fn }

  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.function_sa[each.key].email}"
}

resource "google_project_iam_member" "cloudfunctions_invoker" {
  for_each = { for fn in var.synthetic_monitors : fn.name => fn }

  project = var.project_id
  role    = "roles/cloudfunctions.invoker"
  member  = "serviceAccount:${google_service_account.function_sa[each.key].email}"
}

resource "google_monitoring_uptime_check_config" "synthetic_monitor" {
  for_each = { for fn in var.synthetic_monitors : fn.name => fn }
  display_name = "${each.key}-synthetic-monitor"
  timeout = each.value.timeout

  synthetic_monitor {
    cloud_function_v2 {
      name = google_cloudfunctions2_function.function[each.key].id
    }
  }
}