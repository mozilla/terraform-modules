data "google_project" "project" {
  project_id = var.project_id
}

locals {
  cluster_name        = "${var.name}-${var.realm}"
  cluster_network_tag = "gke-${local.cluster_name}"
  cluster_type        = var.enable_private_cluster ? "private" : "public"

  k8s_api_proxy_name = "api-proxy-${local.cluster_type}-${var.region}"

  labels_defaults = {
    "realm"     = var.realm
    "name"      = var.name
    "region"    = var.region
    "terraform" = "true"
  }
  labels     = merge(local.labels_defaults, var.labels)
  project_id = data.google_project.project.project_id

  tags_defaults = [var.realm, var.name, var.region, "terraform", "gke-${local.cluster_name}", "gke-clusters"]
  tags          = setunion(local.tags_defaults, var.tags)

  # internal networking setup
  datapath_provider = var.enable_dataplane ? "ADVANCED_DATAPATH" : "DATAPATH_PROVIDER_UNSPECIFIED"

  # monitoring setup
  resource_usage_export_dataset_id = var.create_resource_usage_export_dataset ? google_bigquery_dataset.dataset[0].dataset_id : var.resource_usage_export_dataset_id

  # networking setup
  master_ipv4_cidr_block      = var.shared_vpc_outputs == null ? var.master_ipv4_cidr_block : var.shared_vpc_outputs.ip_cidr_range.master
  network                     = var.shared_vpc_outputs == null ? var.network : var.shared_vpc_outputs.network
  pods_ip_cidr_range_name     = var.shared_vpc_outputs == null ? var.pods_ip_cidr_range_name : var.shared_vpc_outputs.secondary_ip_ranges.pod.range_name
  services_ip_cidr_range_name = var.shared_vpc_outputs == null ? var.services_ip_cidr_range_name : var.shared_vpc_outputs.secondary_ip_ranges.service.range_name
  subnetwork                  = var.shared_vpc_outputs == null ? var.subnetwork : var.shared_vpc_outputs.subnetwork

  node_pool_defaults = {
    disk_size_gb       = 100
    disk_type          = "pd-balanced"
    initial_node_count = 2
    machine_type       = "n2-standard-4"
    max_count          = 20
    max_pods_per_node  = 32
    max_surge          = 3
    max_unavailable    = 1
    min_count          = 1
    use_name_prefix    = true
  }
  node_pools                   = { for node_pool in var.node_pools : node_pool.name => merge(local.node_pool_defaults, node_pool) }
  node_pools_labels            = { for node_pool in var.node_pools : node_pool.name => merge(local.labels, lookup(var.node_pools_labels, node_pool.name, {})) }
  node_pools_oauth_scopes      = { for node_pool in var.node_pools : node_pool.name => lookup(var.node_pools_oauth_scopes, node_pool.name, ["https://www.googleapis.com/auth/cloud-platform"]) }
  node_pools_sysctls           = { for node_pool in var.node_pools : node_pool.name => lookup(var.node_pools_sysctls, node_pool.name, {}) }
  node_pools_guest_accelerator = { for node_pool in var.node_pools : node_pool.name => lookup(var.node_pools_guest_accelerator, node_pool.name, {}) }
  node_pools_tags              = { for node_pool in var.node_pools : node_pool.name => setunion(local.tags, lookup(var.node_pools_tags, node_pool.name, [])) }
  node_pools_taints            = { for node_pool in var.node_pools : node_pool.name => lookup(var.node_pools_taints, node_pool.name, []) }
  node_pools_spot_enabled      = { for node_pool in var.node_pools : node_pool.name => lookup(var.node_pools_spot_enabled, node_pool.name, false) }

  # Google Group for RBAC
  cluster_authenticator_security_group = var.google_group_name == null ? [] : [{
    security_group = var.google_group_name
  }]
}
