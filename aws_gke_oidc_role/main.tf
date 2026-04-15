/*
 * # AWS-GKE OIDC Role
 * This module will create an AWS role that will allow a specified GKE service account & Spacelift space(s) to assume it.
 *
 * Requires that `../aws_gke_oidc_config` has been applied for a given AWS account + GKE cluster combination
 * if you get an error about the `aws_iam_openid_connect_provider` data source being missing, apply that module.
 *
 * After creating these resources, add the following environment variables, volumes, and volume mounts to your pod definition:
 * * env:
 * ```
 * - name: AWS_REGION
 *   value: <YOUR_AWS_REGION_HERE>
 * - name: AWS_ROLE_ARN
 *   value: <ROLE_ARN FROM OUTPUT HERE>
 * - name: AWS_WEB_IDENTITY_TOKEN_FILE
 *   value: /var/run/secrets/eks.amazonaws.com/serviceaccount/token
 * - name: AWS_STS_REGIONAL_ENDPOINTS
 *   value: regional
 * ```
 * * volumes:
 * ```
 * - name: aws-token
 *   projected:
 *     defaultMode: 420
 *     sources:
 *     - serviceAccountToken:
 *         audience: sts.amazonaws.com
 *         expirationSeconds: 86400
 *         path: token
 * ```
 * * volumeMounts:
 * ```
 * - mountPath: /var/run/secrets/eks.amazonaws.com/serviceaccount/
 *   name: aws-token
 * ```
*/

locals {
  k8s_service_accounts = [for k, v in var.k8s_service_accounts : "system:serviceaccount:${v.namespace}:${v.service_account}"]

  gke_providers = { for k, v in var.gke_clusters : k => {
    data_url   = "https://container.googleapis.com/v1/projects/${v.gcp_project_id}/locations/${v.gcp_region}/clusters/${v.gke_cluster_name}"
    lookup_url = "container.googleapis.com/v1/projects/${v.gcp_project_id}/locations/${v.gcp_region}/clusters/${v.gke_cluster_name}"
  } }
  spacelift_provider = length(var.spacelift_prefixes) > 0 ? { spacelift = {
    data_url   = "https://${var.spacelift_instance}"
    lookup_url = var.spacelift_instance
  } } : {}
  oidc_providers = merge(local.gke_providers, local.spacelift_provider)
}

module "iam_assumable_role_for_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "~> v6.2.1"

  description        = "Role for GKE clusters and Spacelift to assume"
  enable_oidc        = true
  name               = var.role_name
  oidc_provider_urls = values(local.oidc_providers)[*].lookup_url
  # TODO - look into using https://registry.terraform.io/modules/terraform-aws-modules/iam/aws/latest/submodules/iam-role#input_trust_policy_conditions for the Spacelift subject
  # GKE subject doesn't need wildcards so it can be an `oidc_subject`, but setting both `oidc_subjects` and `wilcard_subjects` results in an AND
  oidc_wildcard_subjects = setunion(
    local.k8s_service_accounts,
    var.spacelift_prefixes,
  )
  policies        = var.iam_policy_arns
  use_name_prefix = false
}

data "aws_iam_openid_connect_provider" "oidc_providers" {
  for_each = local.oidc_providers

  url = each.value.data_url
}
