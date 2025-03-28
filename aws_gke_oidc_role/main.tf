/* 
 * # AWS-GKE OIDC Role 
 * This module will create an AWS role that will allow a specified GKE service account to assume it.
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

module "iam_assumable_role_for_oidc" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v5.9"
  create_role                   = true
  role_name                     = var.role_name
  role_description              = "Role for ${var.gke_cluster_name}/${var.gke_namespace}/${var.gke_service_account} to assume"
  provider_url                  = replace(data.aws_iam_openid_connect_provider.gke_oidc.url, "https://", "")
  role_policy_arns              = var.iam_policy_arns
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.gke_namespace}:${var.gke_service_account}"]
}

data "aws_iam_openid_connect_provider" "gke_oidc" {
  url = "https://container.googleapis.com/v1/projects/${var.gcp_project_id}/locations/${var.gcp_region}/clusters/${var.gke_cluster_name}"
}
