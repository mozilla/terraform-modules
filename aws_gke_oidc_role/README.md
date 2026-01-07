# AWS-GKE OIDC Role
This module will create an AWS role that will allow a specified GKE service account to assume it.

Requires that `../aws_gke_oidc_config` has been applied for a given AWS account + GKE cluster combination
if you get an error about the `aws_iam_openid_connect_provider` data source being missing, apply that module.

After creating these resources, add the following environment variables, volumes, and volume mounts to your pod definition:
* env:
```
- name: AWS_REGION
  value: <YOUR_AWS_REGION_HERE>
- name: AWS_ROLE_ARN
  value: <ROLE_ARN FROM OUTPUT HERE>
- name: AWS_WEB_IDENTITY_TOKEN_FILE
  value: /var/run/secrets/eks.amazonaws.com/serviceaccount/token
- name: AWS_STS_REGIONAL_ENDPOINTS
  value: regional
```
* volumes:
```
- name: aws-token
  projected:
    defaultMode: 420
    sources:
    - serviceAccountToken:
        audience: sts.amazonaws.com
        expirationSeconds: 86400
        path: token
```
* volumeMounts:
```
- mountPath: /var/run/secrets/eks.amazonaws.com/serviceaccount/
  name: aws-token
```

## Example

```hcl
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
  depends_on          = [module.oidc_config]
  source              = "../.././"
  role_name           = "opst-1509-oidc-test"
  aws_region          = "us-west-1"
  gcp_region          = "us-west1"
  gke_cluster_name    = "global-platform-admin-mgmt"
  gcp_project_id      = "moz-fx-platform-mgmt-global"
  gke_namespace       = "atlantis-sandbox"
  gke_service_account = "atlantis-sandbox"
  iam_policy_arns     = {}
}
```

```hcl
/*
* Example of creating just the role. The module will infer the OIDC url from vars.
* Attaches an inline ec2 policy & managed AWS ViewOnly policy.
* Resulting role will be assumable by the "foo" service account in the "bar" namespace of the "baz" cluster
*/

module "oidc_role" {
  source              = "../.././"
  role_name           = "oidc-example-role"
  aws_region          = "us-west-1"
  gcp_region          = "us-west1"
  gke_cluster_name    = "baz"
  gcp_project_id      = "example-project"
  gke_namespace       = "bar"
  gke_service_account = "foo"
  iam_policy_arns = {
    example_policy = aws_iam_policy.example_policy.arn
    ViewOnlyAccess = data.aws_iam_policy.view_only.arn
  }
}

resource "aws_iam_policy" "example_policy" {
  name        = "example_policy"
  path        = "/"
  description = "My example policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

data "aws_iam_policy" "view_only" {
  arn = "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | GKE cluster's project ID | `string` | n/a | yes |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GKE cluster's GCP region | `string` | n/a | yes |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | GKE cluster name | `string` | n/a | yes |
| <a name="input_gke_namespace"></a> [gke\_namespace](#input\_gke\_namespace) | Namespace for GKE workload | `string` | n/a | yes |
| <a name="input_gke_service_account"></a> [gke\_service\_account](#input\_gke\_service\_account) | GKE service account to grant role assumption privilleges | `string` | n/a | yes |
| <a name="input_iam_policy_arns"></a> [iam\_policy\_arns](#input\_iam\_policy\_arns) | One or more policy arns to attach to created AWS role | `map(string)` | n/a | yes |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name to give the AWS role | `string` | n/a | yes |
| <a name="input_space_prefix"></a> [space\_prefix](#input\_space\_prefix) | Prefix for Spacelift spaces that are allowed to assume role. Spacelift role will not be created if not set | `string` | `""` | no |
| <a name="input_spacelift_instance"></a> [spacelift\_instance](#input\_spacelift\_instance) | Spacelift instance to grant role assumption privilleges | `string` | `"mozilla.app.spacelift.io"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN for the GKE-AWS connector role |
| <a name="output_role_name"></a> [role\_name](#output\_role\_name) | Name for the GKE-AWS connector role |
