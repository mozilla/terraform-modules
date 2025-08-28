# Provider configuration outputs
output "project_id" {
  description = "The configured GCP project ID"
  value       = var.project_id
}

output "region" {
  description = "The configured GCP region"
  value       = var.region
}

output "zone" {
  description = "The configured GCP zone"
  value       = var.zone
}

# Label outputs
output "default_labels" {
  description = "The computed default labels applied to all resources"
  value       = local.final_labels
}

