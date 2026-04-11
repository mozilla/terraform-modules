/*
* Example of creating both an OIDC config & role to utilize it
*/

module "oidc_config" {
  source           = "../../../aws_gke_oidc_config/"
  gcp_region       = "us-west1"
  gcp_project_id   = "moz-fx-platform-mgmt-global"
  gke_cluster_name = "global-platform-admin-mgmt"
}

module "oidc_role" {
  depends_on = [module.oidc_config]
  source     = "../.././"
  role_name  = "opst-1509-oidc-test"
  aws_region = "us-west-1"

  gke_clusters = {
    mgmt = {
      gcp_project_id   = "moz-fx-platform-mgmt-global"
      gcp_region       = "us-west1"
      gke_cluster_name = "global-platform-admin-mgmt"
    }
  }

  k8s_service_accounts = {
    atlantis-sandbox = {
      namespace       = "atlantis-sandbox"
      service_account = "atlantis-sandbox"
    }
  }

  iam_policy_arns = {}
}
