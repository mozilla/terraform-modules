resource "kubernetes_namespace" "flux" {
  count = local.cluster_features["flux"] ? 1 : 0
  metadata {
    name = "fluxcd"

    labels = {
      app = "fluxcd"
    }
  }
}

module "flux-workload-identity" {
  source                 = "github.com/mozilla-it/terraform-modules//gcp/identity?ref=master"
  enabled                = local.cluster_features["flux"]
  create_ksa             = false
  additional_permissions = false
  name                   = "flux-${random_string.random.result}"
  ksa_name               = local.flux_settings["serviceAccount.name"]
  namespace              = "fluxcd"
  gke_cluster            = module.gke.name
  project_id             = var.project_id
}

resource "google_project_iam_member" "storage_object_viewer" {
  count   = local.cluster_features["flux"] ? 1 : 0
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = module.flux-workload-identity.gcp_service_account_fqn
}

module "flux" {
  source                    = "github.com/mozilla-it/terraform-modules//helm/flux?ref=master"
  enable_flux               = local.cluster_features["flux"]
  enable_flux_helm_operator = local.cluster_features["flux_helm_operator"]
  flux_settings             = local.flux_settings
}
