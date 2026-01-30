output "service_account_email" {
  description = "Email of the service account created for the Cloud Function. Use this to grant IAM permissions for secrets, databases, and other resources (null if using GKE mode)"
  value       = length(google_service_account.consumer) > 0 ? google_service_account.consumer[0].email : null
}

output "subscription_id" {
  description = "Full resource path of the Pub/Sub subscription (null if using Cloud Function mode with Eventarc)"
  value       = length(google_pubsub_subscription.exit_consumer) > 0 ? google_pubsub_subscription.exit_consumer[0].id : null
}

output "function_url" {
  description = "URL of the Cloud Function (null if using GKE mode)"
  value       = length(google_cloudfunctions2_function.exit_consumer) > 0 ? google_cloudfunctions2_function.exit_consumer[0].service_config[0].uri : null
}
