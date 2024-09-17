output "ca_certificate" {
  description = "CA Certificate for the Cluster"
  value       = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}

output "endpoint" {
  description = "Cluster endpoint"
  sensitive   = true
  value       = google_container_cluster.primary.endpoint
}

output "location" {
  description = "Cluster location (region)"
  value       = google_container_cluster.primary.location
}

output "master_version" {
  description = "Current Kubernetes master version"
  value       = google_container_cluster.primary.master_version
}

output "name" {
  description = "Cluster name"
  value       = google_container_cluster.primary.name
}

output "node_pools" {
  description = "List of node pools"
  value       = google_container_cluster.primary.node_pool
}

output "service_account" {
  description = "Cluster Service Account"
  value       = google_service_account.cluster_service_account.email
}

output "k8s_api_proxy_dns_name" {
  description = "K8s api proxy dns record"
  value       = var.enable_k8s_api_proxy_ip ? google_dns_record_set.k8s_api_proxy_dns_name[0].name : "N/A"
}
