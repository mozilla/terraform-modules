/*
 * # AWS-GKE OIDC Config
 * This module will create 2 AWS OIDC configs that create a trust relationship between a GKE cluster & AWS account, and our Spacelift instance with the same AWS account.
 *
 * Once this module has been invoked for a given account + GKE cluster, the `aws_gke_oidc_role` module can be used
 * to create any number of roles to be used by GKE workloads & Spacelift.
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


resource "aws_iam_openid_connect_provider" "spacelift_oidc" {
  url = "https://${var.spacelift_instance}"

  client_id_list = [
    var.spacelift_instance
  ]

  thumbprint_list = [
    data.tls_certificate.spacelift_oidc.certificates.0.sha1_fingerprint
  ]
}

data "tls_certificate" "spacelift_oidc" {
  url = "https://${var.spacelift_instance}"
}
