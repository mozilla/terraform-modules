/**
* # Terraform module for Workload Identity
* Creates identity mapping and optionally the service
* accounts to go with it
*/

locals {
  gcp_given_name = var.gcp_sa_name != null ? var.gcp_sa_name : substr(var.name, 0, 30)
  gcp_sa_email   = var.use_existing_gcp_sa ? data.google_service_account.cluster_service_account[0].email : google_service_account.cluster_service_account[0].email
  gcp_sa_fqn     = "serviceAccount:${local.gcp_sa_email}"

  # This will cause Terraform to block returning outputs until the service account is created
  k8s_given_name       = var.k8s_sa_name != null ? var.k8s_sa_name : var.name
  output_k8s_name      = var.use_existing_k8s_sa ? local.k8s_given_name : kubernetes_service_account.main[0].metadata[0].name
  output_k8s_namespace = var.use_existing_k8s_sa ? var.namespace : kubernetes_service_account.main[0].metadata[0].namespace

  k8s_sa_gcp_derived_name = "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/${local.output_k8s_name}]"
}

data "google_service_account" "cluster_service_account" {
  count = var.use_existing_gcp_sa ? 1 : 0

  account_id = local.gcp_given_name
  project    = var.project_id
}

resource "google_service_account" "cluster_service_account" {
  count = var.use_existing_gcp_sa ? 0 : 1

  account_id   = local.gcp_given_name
  display_name = substr("GCP SA bound to K8S SA ${local.k8s_given_name}", 0, 100)
  project      = var.project_id
}

resource "kubernetes_service_account" "main" {
  count = var.use_existing_k8s_sa ? 0 : 1

  automount_service_account_token = var.automount_service_account_token
  metadata {
    name      = local.k8s_given_name
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = local.gcp_sa_email
    }
  }
}

resource "google_service_account_iam_member" "main" {
  service_account_id = var.use_existing_gcp_sa ? data.google_service_account.cluster_service_account[0].name : google_service_account.cluster_service_account[0].name
  role               = "roles/iam.workloadIdentityUser"
  member             = local.k8s_sa_gcp_derived_name
}

resource "google_project_iam_member" "workload_identity_sa_bindings" {
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.value
  member  = local.gcp_sa_fqn
}