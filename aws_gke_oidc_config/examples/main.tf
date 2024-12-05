/*
 * Creates an OIDC trust relationship between the global-platform-admin-mgmt cluster & the authenticated AWS account.
 */

module "oidc_config" {
  source           = "../."
  gcp_region       = "us-west1"
  gcp_project_id   = "moz-fx-platform-mgmt-global"
  gke_cluster_name = "global-platform-admin-mgmt"
}
