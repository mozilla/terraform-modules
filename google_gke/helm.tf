locals {
  helm_stable_repository           = "https://kubernetes-charts.storage.googleapis.com"
  helm_incubator_repository        = "http://storage.googleapis.com/kubernetes-charts-incubator"
  helm_vmware_tanzu_repository     = "https://vmware-tanzu.github.io/helm-charts"
  helm_external_secrets_repository = "https://godaddy.github.io/kubernetes-external-secrets"
}

resource "helm_release" "velero" {
  count      = local.cluster_features["velero"] ? 1 : 0
  name       = "velero"
  repository = local.helm_vmware_tanzu_repository
  chart      = "velero"
  namespace  = "velero"

  dynamic "set" {
    iterator = item
    for_each = local.velero_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [
    module.gke,
    module.velero_workload_identity,
    google_storage_bucket.bucket,

  ]
}

resource "helm_release" "external_secrets" {
  count      = local.cluster_features["external_secrets"] ? 1 : 0
  name       = "kubernetes-external-secrets"
  repository = local.helm_external_secrets_repository
  chart      = "kubernetes-external-secrets"
  namespace  = "kube-system"

  dynamic "set" {
    iterator = item
    for_each = local.external_secrets_settings

    content {
      name  = item.key
      value = item.value
    }
  }

  depends_on = [
    module.gke,
    module.external-secrets-workload-identity
  ]

}
