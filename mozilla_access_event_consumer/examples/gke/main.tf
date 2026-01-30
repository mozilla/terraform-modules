# module "tenant" {
#   source = "../../../modules/tenant"
#   # ... tenant configuration ...
# }

module "exit_consumer" {
  source = "github.com/mozilla/terraform-modules//mozilla_employee_exit_consumer?ref=main"

  project_id  = local.project_id
  application = local.application
  environment = local.environment

  # Provide GKE service account for GKE mode (required when function_source_dir is not specified)
  service_account = module.tenant.deploy_service_account_email
}

# The module only creates the Pub/Sub subscription.
# You must deploy the Kubernetes workload separately.
# See the k8s/ directory for an example manifest.
output "pubsub_subscription_id" {
  value = module.exit_consumer.subscription_id
}
