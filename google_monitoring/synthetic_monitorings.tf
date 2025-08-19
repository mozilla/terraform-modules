
resource "google_storage_bucket" "bucket" {
  for_each                    = { for fn in var.synthetic_monitors : fn.name => fn }
  name                        = each.value.bucket_name # Every bucket name must be globally unique
  location                    = "US"
  uniform_bucket_level_access = true
  labels = {
    application = var.application
    realm       = var.realm
    environment = var.environment
  }
}

resource "google_storage_bucket_object" "object" {
  for_each = { for fn in var.synthetic_monitors : fn.name => fn }
  name     = each.key
  bucket   = google_storage_bucket.bucket[each.key].name
  source   = each.value.object_source
}

resource "google_cloudfunctions2_function" "function" {
  for_each    = { for fn in local.synthetic_monitors : fn.name => fn }
  name        = each.value.function_name
  location    = each.value.function_location
  description = each.value.function_description

  build_config {
    runtime         = each.value.runtime
    entry_point     = each.value.entry_point
    service_account = "projects/${var.project_id}/serviceAccounts/${each.value.used_build_sa_email}"
    source {
      storage_source {
        bucket = google_storage_bucket.bucket[each.key].name
        object = google_storage_bucket_object.object[each.key].name
      }
    }
  }

  service_config {
    max_instance_count    = 1
    available_memory      = each.value.memory
    timeout_seconds       = each.value.timeout
    service_account_email = each.value.used_runtime_sa_email

    secret_environment_variables {
      key        = each.value.secret_key
      project_id = var.project_id
      secret     = google_secret_manager_secret.secret[each.key].secret_id
      version    = "latest"
    }
  }

  labels = {
    application = var.application
    realm       = var.realm
    environment = var.environment
  }

  depends_on = [google_secret_manager_secret.secret]
}

resource "google_secret_manager_secret" "secret" {
  for_each  = { for fn in var.synthetic_monitors : fn.name => fn }
  secret_id = each.value.secret_name

  replication {
    auto {}
  }

  labels = {
    application = var.application
    realm       = var.realm
    environment = var.environment
  }
}



resource "google_monitoring_uptime_check_config" "synthetic_monitor" {
  for_each     = { for fn in var.synthetic_monitors : fn.name => fn }
  display_name = "${each.key}-synthetic-monitor"
  timeout      = "60s"

  synthetic_monitor {
    cloud_function_v2 {
      name = google_cloudfunctions2_function.function[each.key].id
    }
  }
  user_labels = {
    application = var.application
    realm       = var.realm
    environment = var.environment
  }
}