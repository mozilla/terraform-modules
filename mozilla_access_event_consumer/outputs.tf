output "service_account_email" {
  description = "Email of the service account used by the consumer. Returns the created service account in Cloud Function mode, or the provided service_account_email in GKE mode."
  value       = local.consumer_service_account
}

output "subscription_id" {
  description = "Full resource path of the Pub/Sub subscription"
  value       = google_pubsub_subscription.access_consumer.id
}

output "function_url" {
  description = "URL of the Cloud Function (null if using GKE mode)"
  value       = length(google_cloudfunctions2_function.access_consumer) > 0 ? google_cloudfunctions2_function.access_consumer[0].service_config[0].uri : null
}
