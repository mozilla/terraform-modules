
output "name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.gke.endpoint
}

output "location" {
  description = "Cluster location (region if regional cluster, zone if zonal cluster)"
  value       = module.gke.location
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = module.gke.master_version
}

output "node_pools_names" {
  description = "List of node pools names"
  value       = module.gke.node_pools_names
}

output "node_pools_versions" {
  description = "List of node pools versions"
  value       = module.gke.node_pools_versions
}

output "zones" {
  description = "List of zones in which the cluster resides"
  value       = module.gke.zones
}

output "kubeconfig" {
  description = "Raw kubeconfig value"
  value       = module.gke_auth.kubeconfig_raw
}
