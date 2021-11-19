
locals {

  cluster_resource_labels_defaults = {
    "name"        = var.name
    "region"      = var.region
    "environment" = var.environment
    "costcenter"  = var.costcenter
    "terraform"   = "true"
  }
  cluster_resource_labels = merge(local.cluster_resource_labels_defaults, var.cluster_resource_labels)

  cluster_addons_defaults = {
    horizontal_pod_autoscaling = true
    http_load_balancing        = true
    dns_cache                  = true
    istio                      = false
    vertical_pod_autoscaling   = false
    cloudrun                   = false
  }
  cluster_addons = merge(local.cluster_addons_defaults, var.cluster_addons)

  cluster_features_defaults = {
    "velero"             = true
    "external_secrets"   = true
    "prometheus"         = false
    "flux"               = false
    "flux_helm_operator" = false
  }
  cluster_features = merge(local.cluster_features_defaults, var.cluster_features)

  velero_defaults = {
    "credentials.useSecret"                                                = false
    "configuration.provider"                                               = "gcp"
    "configuration.backupStorageLocation.name"                             = "gcp"
    "configuration.backupStorageLocation.bucket"                           = local.cluster_features["velero"] ? google_storage_bucket.bucket[0].name : ""
    "configuration.backupStorageLocation.config.serviceAccount"            = module.velero_workload_identity.gcp_service_account_email
    "configuration.volumeSnapshotLocation.name"                            = "gcp"
    "initContainers[0].name"                                               = "velero-plugin-for-gcp"
    "initContainers[0].image"                                              = "velero/velero-plugin-for-gcp:v1.1.0"
    "initContainers[0].volumeMounts[0].mountPath"                          = "/target"
    "initContainers[0].volumeMounts[0].name"                               = "plugins"
    "serviceAccount.server.name"                                           = "velero"
    "serviceAccount.server.annotations.iam\\.gke\\.io/gcp-service-account" = module.velero_workload_identity.gcp_service_account_email
    "schedules.daily.schedule"                                             = "0 0 * * *"
    "schedules.daily.template.ttl"                                         = "720h0m0s"
    "schedules.daily.template.storageLocation"                             = "gcp"
    "schedules.daily.template.volumeSnapshotLocations[0]"                  = "gcp"
    "schedules.daily.template.includedNamespaces[0]"                       = "*"
  }
  velero_settings = merge(local.velero_defaults, var.velero_settings)

  external_secrets_defaults = {
    "securityContext.fsGroup"                                       = "65534"
    "env.POLLER_INTERVAL_MILLISECONDS"                              = "300000"
    "serviceAccount.name"                                           = "kubernetes-external-secrets"
    "serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account" = module.external-secrets-workload-identity.gcp_service_account_email

  }
  external_secrets_settings = merge(local.external_secrets_defaults, var.external_secrets_settings)

  flux_defaults = {
    "git.path"                                                      = "k8s/"
    "serviceAccount.name"                                           = "flux"
    "serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account" = module.flux-workload-identity.gcp_service_account_email
  }
  flux_settings = merge(local.flux_defaults, var.flux_settings)

}
