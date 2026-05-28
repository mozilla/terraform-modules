# module "tenant" {
#   source = "../../../modules/tenant"
#   # ... tenant configuration ...
# }

module "access_consumer" {
  # Use the latest version of this module from https://github.com/mozilla/terraform-modules/tags
  source = "github.com/mozilla/terraform-modules//mozilla_access_event_consumer?ref=mozilla_access_event_consumer-1.3.0"

  project_id            = local.project_id
  application           = local.application
  environment           = local.environment
  service_account_email = module.tenant.gke_service_account_email
}

# The module only creates the Pub/Sub subscription.
# You must deploy the Kubernetes workload separately.
# See the k8s/ directory for an example manifest.
output "pubsub_subscription_id" {
  value = module.access_consumer.subscription_id
}
