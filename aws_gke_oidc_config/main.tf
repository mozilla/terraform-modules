/* 
 * # AWS-GKE OIDC Config 
 * This module will create an AWS OIDC config that creates a trust relationship between a GKE cluster & AWS account.
 *
 * Once this module has been invoked for a given account + GKE cluster, the `aws_gke_oidc_role` module can be used
 * to create any number of roles to be used by GKE workloads.
 *
 * See the `aws_gke_oidc_role` for complete usage instructions
*/

resource "aws_iam_openid_connect_provider" "gke_oidc" {
  url = "https://container.googleapis.com/v1/projects/${var.gcp_project_id}/locations/${var.gcp_region}/clusters/${var.gke_cluster_name}"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.gke_oidc.certificates.0.sha1_fingerprint
  ]
}

data "tls_certificate" "gke_oidc" {
  url = "https://container.googleapis.com/v1/projects/${var.gcp_project_id}/locations/${var.gcp_region}/clusters/${var.gke_cluster_name}"
}
