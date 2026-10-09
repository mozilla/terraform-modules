output "logging_bucket_id" {
  value = try(module.gke_logging[0].logging_bucket_id, null)
}

output "logging_bucket_linked_dataset_id" {
  value = try(module.gke_logging[0].logging_bucket_linked_dataset_id, null)
}

output "logging_dataset_id" {
  value = try(module.gke_logging[0].logging_dataset_id, null)
}

output "gke_cluster_project_id" {
  value = local.gke_cluster_project_id
}

output "gke_service_account_email" {
  value = try(module.google_gke_tenant[0].gke_service_account.email, null)
}

output "gke_service_account_name" {
  value = try(module.google_gke_tenant[0].gke_service_account.name, null)
}

output "deploy_service_account_email" {
  value = try(module.google_deployment_accounts[0].service_account.email, "")
}

output "deploy_service_account_name" {
  value = try(module.google_deployment_accounts[0].service_account.name, "")
}

output "network" {
  value = try(data.terraform_remote_state.vpc[0].outputs.networks.realm[var.realm], null)
}

output "public_ips" {
  value = local.public_ips
}

output "internal_ips" {
  value = local.internal_ips
}
