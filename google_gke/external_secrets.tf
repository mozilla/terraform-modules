#TODO: Remove this resource and use `random_string.random` instead
resource "random_string" "external_secrets_suffix" {
  length  = 4
  lower   = true
  number  = false
  upper   = false
  special = false
}

module "external-secrets-workload-identity" {
  source      = "github.com/mozilla-it/terraform-modules//gcp/identity?ref=master"
  enabled     = local.cluster_features["external_secrets"]
  create_ksa  = false                                                              # Allow chart to create
  name        = "external-secrets-${random_string.external_secrets_suffix.result}" # Select hash to randomize name
  ksa_name    = "kubernetes-external-secrets"                                      # If this value changes make sure local.tf value changes too
  namespace   = "kube-system"
  gke_cluster = module.gke.name
  project_id  = var.project_id
}
