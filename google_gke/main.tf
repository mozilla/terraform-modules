resource "random_shuffle" "zones" {
  input        = data.google_compute_zones.available.names
  result_count = 3
}

module "gke" {
  # We are using this module path to take advantage of workload identity
  source                          = "terraform-google-modules/kubernetes-engine/google//modules/beta-public-cluster"
  version                         = "~> 10"
  kubernetes_version              = var.kubernetes_version
  release_channel                 = var.release_channel
  project_id                      = var.project_id
  name                            = var.name
  region                          = var.region
  regional                        = var.regional
  zones                           = random_shuffle.zones.result
  network                         = var.network
  subnetwork                      = var.subnetwork
  ip_range_pods                   = var.ip_range_pods
  ip_range_services               = var.ip_range_services
  remove_default_node_pool        = true
  grant_registry_access           = true
  horizontal_pod_autoscaling      = local.cluster_addons["horizontal_pod_autoscaling"]
  http_load_balancing             = local.cluster_addons["http_load_balancing"]
  dns_cache                       = local.cluster_addons["dns_cache"]
  istio                           = local.cluster_addons["istio"]
  cloudrun                        = local.cluster_addons["cloudrun"]
  enable_vertical_pod_autoscaling = local.cluster_addons["vertical_pod_autoscaling"]
  cluster_resource_labels         = local.cluster_resource_labels

  # Node configs
  node_metadata = "GKE_METADATA_SERVER"
  node_pools    = var.node_pools
  node_pools_labels = {
    all = {
      "cluster"     = var.name
      "environment" = var.environment
      "node"        = "managed"
      "costcenter"  = var.costcenter
      "terraform"   = "true"
    }
  }

  node_pools_tags = {
    all = [
      var.project_id, var.name, var.region
    ]
  }

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"

  project_id   = var.project_id
  cluster_name = module.gke.name
  location     = module.gke.location
}

resource "kubernetes_storage_class" "ssd" {
  metadata {
    name = "faster"
  }
  storage_provisioner = "kubernetes.io/gce-pd"
  reclaim_policy      = "Retain"

  parameters = {
    type = "pd-ssd"
  }
}

resource "random_string" "random" {
  length  = 4
  lower   = true
  number  = false
  upper   = false
  special = false
}

