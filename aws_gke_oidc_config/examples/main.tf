module "oidc_config" {
  source = "../."
  gcp_region = "us-west1"
  gcp_project_id = "moz-fx-platform-mgmt-global"
  gke_cluster_name = "global-platform-admin-mgmt"
}
