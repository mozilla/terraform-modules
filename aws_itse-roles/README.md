# Terraform Module for Default AWS Delegated Roles
Module that creates roles on accounts to allow delegated access from another account.

Primarily used by Web SRE on IT-SE inherited resources.

Module will create 4 different roles:
- itsre-admin		- Admin role
- itsre-readonly	- Readonly role
- itsre-poweruser	- Similar to admin but can't do any IAM tasks
- itsre-atlantis	- Atlantis (Terraform automation platform) role

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.admin_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.atlantis_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.poweruser_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.readonly_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.admin_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.atlantis_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.poweruser_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.readonly_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.atlantis_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atlantis_principal"></a> [atlantis\_principal](#input\_atlantis\_principal) | AWS account role ARN linked to Atlantis GCP Workload Identity (e.g. entrypoint to all AWS accounts by a given Atlantis). | `string` | n/a | yes |
| <a name="input_additional_principals"></a> [additional\_principals](#input\_additional\_principals) | List of additional principals' (user, role) ARNs allowed to assume the itse roles defined here. | `list(string)` | `[]` | no |
| <a name="input_external_account_id"></a> [external\_account\_id](#input\_external\_account\_id) | The AWS Account ID whose root user or Terraform role can assume the itse roles. Defaults to mozilla-itsre account. | `string` | `"177680776199"` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | Maximum session time (in seconds). Defaults to 12 hours (43,200 seconds). | `string` | `"43200"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region for AWS Resources (defaults to us-west-2). | `string` | `"us-west-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_role_arn"></a> [admin\_role\_arn](#output\_admin\_role\_arn) | ARN for the IT-SE Delegated Access Admin Role |
| <a name="output_atlantis_role_arn"></a> [atlantis\_role\_arn](#output\_atlantis\_role\_arn) | ARN for the IT-SE Delegated Access Admin Role |
| <a name="output_poweruser_role_arn"></a> [poweruser\_role\_arn](#output\_poweruser\_role\_arn) | ARN for the IT-SE Delegated Access Admin Role |
| <a name="output_readonly_role_arn"></a> [readonly\_role\_arn](#output\_readonly\_role\_arn) | ARN for the IT-SE Delegated Access Admin Role |
