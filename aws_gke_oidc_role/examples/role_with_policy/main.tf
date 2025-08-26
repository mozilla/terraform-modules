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
