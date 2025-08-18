# Create Service account for invoke and run the cloud function - if not provided
resource "google_service_account" "runtime_function_sa" {
  for_each = local.runtime_service_accounts

  account_id   = each.value.name
  display_name = "Service account for function ${each.key}"
  project      = each.value.project
}

# Create Service account for building the cloud function - if not provided
resource "google_service_account" "build_sa" {
  for_each = local.build_service_accounts

  account_id   = each.value.name
  display_name = "Build SA for ${each.key}"
  project      = each.value.project
}

# IAM: allow  run service account to access secrets
resource "google_secret_manager_secret_iam_member" "secret_access" {
  for_each = { for fn in local.synthetic_monitors : fn.name => fn }

  secret_id = google_secret_manager_secret.secret[each.key].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${each.value.used_runtime_sa_email}"

  depends_on = [google_service_account.runtime_function_sa]
}

# IAM: allow  run service account to invoke cloud function
resource "google_project_iam_member" "cloudfunctions_invoker" {
  for_each = { for fn in local.synthetic_monitors : fn.name => fn }

  project = var.project_id
  role    = "roles/cloudfunctions.invoker"
  member  = "serviceAccount:${each.value.used_runtime_sa_email}"

  depends_on = [google_service_account.runtime_function_sa]
}

# IAM : add the roles needed for the build service account

resource "google_project_iam_member" "cloudbuild_builder" {
  for_each = { for fn in local.synthetic_monitors : fn.name => fn }

  project = var.project_id
  role    = "roles/cloudbuild.builds.builder"
  member  = "serviceAccount:${each.value.used_build_sa_email}"

  depends_on = [google_service_account.build_sa]
}

resource "google_project_iam_member" "articfactregistry_writer" {
  for_each = { for fn in local.synthetic_monitors : fn.name => fn }

  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${each.value.used_build_sa_email}"

  depends_on = [google_service_account.build_sa]
}

resource "google_project_iam_member" "logging_logwriter" {
  for_each = { for fn in local.synthetic_monitors : fn.name => fn }

  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${each.value.used_build_sa_email}"

  depends_on = [google_service_account.build_sa]
}


# IAM : add the role objectviewer to the build service account with conditions

resource "google_project_iam_member" "build_sa_storage" {
  for_each = {
    for fn in local.synthetic_monitors :
    fn.name => {
      email = fn.used_build_sa_email
    }
  }

  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${each.value.email}"

  condition {
    title       = "RestrictToFunctionStorageBuckets"
    description = "Restrict to Cloud Functions and Cloud Run source buckets"
    expression  = <<-EOT
      resource.type == "storage.googleapis.com/Bucket" &&
      (
        resource.name.startsWith("projects/_/buckets/gcf-v2-sources-") ||
        resource.name.startsWith("projects/_/buckets/gcf-v2-uploads-") ||
        resource.name.startsWith("projects/_/buckets/run-sources-")
      )
    EOT
  }
  depends_on = [google_service_account.build_sa]
}