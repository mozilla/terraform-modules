output "deployer_service_account_email" {
  value = google_service_account.deployer.email
}

output "runtime_service_account_email" {
  value = try(google_service_account.runtime[0].email, null)
}

output "caller_service_account_email" {
  value = try(google_service_account.caller[0].email, null)
}

output "agent_identity_principal" {
  description = "IAM member covering every Agent Identity agent in the project. Grant to it in other projects."
  value       = local.agent_identity_principal
}

output "secret_id" {
  value = google_secret_manager_secret.agents.secret_id
}
