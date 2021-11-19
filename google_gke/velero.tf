locals {
  bucket_name = "velero-${var.name}-${data.google_project.project.number}"
  sa_name     = "velero-${var.name}-sa"
}

resource "kubernetes_namespace" "velero" {
  count = local.cluster_features["velero"] ? 1 : 0

  metadata {
    name = "velero"

    labels = {
      app = "velero"
    }
  }

  depends_on = [module.gke]
}

# TODO: Figure out encryption at rest stuff
resource "google_storage_bucket" "bucket" {
  count         = local.cluster_features["velero"] ? 1 : 0
  name          = local.bucket_name
  location      = "US"
  storage_class = "STANDARD"

  labels = {
    "name"       = local.bucket_name
    "costcenter" = var.costcenter
    "terraform"  = "true"
  }
}

resource "google_storage_bucket_iam_binding" "object_admin" {
  count  = local.cluster_features["velero"] ? 1 : 0
  bucket = google_storage_bucket.bucket[0].name
  role   = "roles/storage.objectAdmin"
  members = [
    module.velero_workload_identity.gcp_service_account_fqn
  ]
}

module "velero_workload_identity" {
  source                 = "github.com/mozilla-it/terraform-modules//gcp/identity?ref=master"
  enabled                = local.cluster_features["velero"]
  create_ksa             = false
  additional_permissions = false
  name                   = "velero-${module.gke.name}"
  ksa_name               = "velero"
  namespace              = "velero"
  gke_cluster            = module.gke.name
  project_id             = var.project_id
}

resource "google_project_iam_custom_role" "velero" {
  count       = local.cluster_features["velero"] ? 1 : 0
  role_id     = "velero.server.${replace(var.name, "-", "_")}"
  title       = "Velero Server ${var.name}"
  description = "Custom role for velero on cluster ${var.name}"

  permissions = [
    "compute.disks.get",
    "compute.disks.create",
    "compute.disks.createSnapshot",
    "compute.snapshots.get",
    "compute.snapshots.create",
    "compute.snapshots.useReadOnly",
    "compute.snapshots.delete",
    "compute.zones.get",
    "iam.serviceAccounts.signBlob"
  ]
}

resource "google_project_iam_member" "velero" {
  count   = local.cluster_features["velero"] ? 1 : 0
  member  = module.velero_workload_identity.gcp_service_account_fqn
  role    = google_project_iam_custom_role.velero[0].id
  project = var.project_id
}
