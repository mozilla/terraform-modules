
output "k8s_service_account_name" {
  description = "Name of k8s service account."
  value       = local.output_k8s_name
}

output "k8s_service_account_namespace" {
  description = "Namespace of k8s service account."
  value       = local.output_k8s_namespace
}

output "gcp_service_account_email" {
  description = "Email address of GCP service account."
  value       = local.gcp_sa_email
}

output "gcp_service_account_fqn" {
  description = "FQN of GCP service account."
  value       = local.gcp_sa_member
}

output "gcp_service_account_name" {
  description = "Name of GCP service account."
  value       = local.k8s_sa_gcp_derived_name
}
