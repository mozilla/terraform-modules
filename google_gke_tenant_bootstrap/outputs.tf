output "gke_service_account" {
  value = module.google_gke_tenant.gke-service-account
}

output "deploy_service_account" {
  value = module.google_deployment_accounts.service_account
}

output "gar_service_account" {
  value = module.google_gar.writer_service_account
}

output "gar_repository" {
  value = module.google_gar.repository
}
