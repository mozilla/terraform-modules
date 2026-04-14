/*
 * # AWS-GKE OIDC Config
 * This module will create 2 AWS OIDC configs that create a trust relationship between a GKE cluster & AWS account, and our Spacelift instance with the same AWS account.
 *
 * Once this module has been invoked for a given account + GKE cluster, the `aws_gke_oidc_role` module can be used
 * to create any number of roles to be used by GKE workloads & Spacelift.
 *
 * See the `aws_gke_oidc_role` for complete usage instructions
*/

locals {
  gke_oidc_providers = { for k, v in var.oidc_providers : k => {
    client_id_list = ["sts.amazonaws.com"]
    url            = "https://container.googleapis.com/v1/projects/${v.gcp_project_id}/locations/${v.gcp_region}/clusters/${v.gke_cluster_name}"
  } if v.gcp_project_id != null && v.gcp_region != null && v.gke_cluster_name != null }
  spacelift_oidc_providers = { for k, v in var.oidc_providers : k => {
    client_id_list = [v.spacelift_instance]
    url            = "https://${v.spacelift_instance}"
  } if v.spacelift_instance != null }
}

resource "aws_iam_openid_connect_provider" "oidc_providers" {
  for_each = merge(local.gke_oidc_providers, local.spacelift_oidc_providers)

  url = each.value.url

  client_id_list = each.value.client_id_list

  thumbprint_list = [
    data.tls_certificate.oidc_providers[each.key].certificates.0.sha1_fingerprint
  ]
}

data "tls_certificate" "oidc_providers" {
  for_each = merge(local.gke_oidc_providers, local.spacelift_oidc_providers)

  url = each.value.url
}
