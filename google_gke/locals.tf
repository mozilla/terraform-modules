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

  # Authoritative per-family boot-disk compatibility, from:
  # https://docs.cloud.google.com/compute/docs/general-purpose-machines
  # https://docs.cloud.google.com/compute/docs/compute-optimized-machines
  # Families not listed here (g2, a2, a3, m1-m3, ...) are not validated/defaulted
  # and keep today's behavior (pd-balanced default, no constraint).
  node_pool_disk_types_by_family = {
    n1  = ["pd-standard", "pd-balanced", "pd-ssd"]
    n2  = ["pd-standard", "pd-balanced", "pd-ssd", "pd-extreme", "hyperdisk-extreme", "hyperdisk-throughput"]
    n2d = ["pd-standard", "pd-balanced", "pd-ssd", "hyperdisk-throughput"]
    e2  = ["pd-standard", "pd-balanced", "pd-ssd"]
    c2  = ["pd-standard", "pd-balanced", "pd-ssd"]
    c2d = ["pd-standard", "pd-balanced", "pd-ssd"]
    t2a = ["pd-standard", "pd-balanced", "pd-ssd"]
    t2d = ["pd-standard", "pd-balanced", "pd-ssd", "hyperdisk-throughput"]
    c3  = ["pd-balanced", "pd-ssd", "hyperdisk-balanced", "hyperdisk-balanced-high-availability", "hyperdisk-extreme", "hyperdisk-ml", "hyperdisk-throughput"]
    c3d = ["pd-balanced", "pd-ssd", "hyperdisk-balanced", "hyperdisk-balanced-high-availability", "hyperdisk-extreme", "hyperdisk-ml", "hyperdisk-throughput"]
    n4  = ["hyperdisk-balanced", "hyperdisk-balanced-high-availability", "hyperdisk-throughput"]
    n4d = ["hyperdisk-balanced", "hyperdisk-balanced-high-availability", "hyperdisk-throughput"]
    n4a = ["hyperdisk-balanced", "hyperdisk-balanced-high-availability", "hyperdisk-throughput"]
    c4  = ["hyperdisk-balanced", "hyperdisk-balanced-high-availability", "hyperdisk-throughput", "hyperdisk-extreme"]
    c4d = ["hyperdisk-balanced", "hyperdisk-throughput"]
    c4a = ["hyperdisk-balanced", "hyperdisk-balanced-high-availability", "hyperdisk-throughput", "hyperdisk-extreme", "hyperdisk-ml"]
  }
  # Used only when a node pool's machine_type family isn't a key in
  # node_pool_disk_types_by_family at all (i.e. we have no compatibility data
  # for it, e.g. g2, a2, a3, m1-m3) - preserves today's behavior for those.
  node_pool_default_disk_type_unknown_family_fallback = "pd-balanced"

  node_pool_defaults = {
    disk_size_gb       = 100
    initial_node_count = 2
    machine_type       = "n2-standard-4"
    max_count          = 20
    max_pods_per_node  = 32
    max_surge          = 3
    max_unavailable    = 1
    min_count          = 1
    use_name_prefix    = true
    # disk_type is resolved per machine-type family below, not a flat default
  }
  node_pools = {
    for node_pool in var.node_pools : node_pool.name => merge(
      local.node_pool_defaults,
      {
        disk_type = lookup(
          { for family, types in local.node_pool_disk_types_by_family : family => (
            contains(types, "hyperdisk-balanced") ? "hyperdisk-balanced" :
            contains(types, "pd-balanced") ? "pd-balanced" :
            types[0]
            )
          },
          split("-", lookup(node_pool, "machine_type", local.node_pool_defaults.machine_type))[0],
          local.node_pool_default_disk_type_unknown_family_fallback
        )
      },
      node_pool
    )
  }
  node_pools_labels            = { for node_pool in var.node_pools : node_pool.name => merge(local.labels, lookup(var.node_pools_labels, node_pool.name, {})) }
  node_pools_oauth_scopes      = { for node_pool in var.node_pools : node_pool.name => lookup(var.node_pools_oauth_scopes, node_pool.name, ["https://www.googleapis.com/auth/cloud-platform"]) }
  node_pools_sysctls           = { for node_pool in var.node_pools : node_pool.name => lookup(var.node_pools_sysctls, node_pool.name, {}) }
  node_pools_guest_accelerator = { for node_pool in var.node_pools : node_pool.name => lookup(var.node_pools_guest_accelerator, node_pool.name, {}) }
  node_pools_tags              = { for node_pool in var.node_pools : node_pool.name => setunion(local.tags, lookup(var.node_pools_tags, node_pool.name, [])) }
  node_pools_taints            = { for node_pool in var.node_pools : node_pool.name => lookup(var.node_pools_taints, node_pool.name, []) }
  node_pools_spot_enabled      = { for node_pool in var.node_pools : node_pool.name => lookup(var.node_pools_spot_enabled, node_pool.name, false) }

  node_pools_shielded_instance_config = { for node_pool in var.node_pools : node_pool.name => lookup(var.node_pools_shielded_instance_config, node_pool.name, null) }

  node_pools_metadata = { for node_pool in var.node_pools : node_pool.name => lookup(var.node_pools_metadata, node_pool.name, {}) }

  # Google Group for RBAC
  cluster_authenticator_security_group = var.google_group_name == null ? [] : [{
    security_group = var.google_group_name
  }]
}
