<!-- BEGIN_TF_DOCS -->
# AWS-GKE OIDC Connector
This module will create an AWS role + an OIDC configuration that will allow a specified GKE service account to assume it.

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

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.76.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.6 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_iam_assumable_role_for_oidc"></a> [iam\_assumable\_role\_for\_oidc](#module\_iam\_assumable\_role\_for\_oidc) | terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc | ~> v5.9 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.gke_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [tls_certificate.gke_oidc](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region | `string` | n/a | yes |
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | ID of the GKE cluster's project | `string` | n/a | yes |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GKE cluster's GCP region | `string` | n/a | yes |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | GKE cluster name | `string` | n/a | yes |
| <a name="input_gke_namespace"></a> [gke\_namespace](#input\_gke\_namespace) | Namespace for GKE workload | `string` | n/a | yes |
| <a name="input_gke_service_account"></a> [gke\_service\_account](#input\_gke\_service\_account) | GKE service account to grant role assumption privilleges | `string` | n/a | yes |
| <a name="input_iam_policy_arns"></a> [iam\_policy\_arns](#input\_iam\_policy\_arns) | One or more policy arns to attach to created AWS role | `list(string)` | n/a | yes |
| <a name="input_role_name"></a> [role\_name](#input\_role\_name) | Name to give the AWS role | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to all AWS resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_role_arn"></a> [role\_arn](#output\_role\_arn) | ARN for the GKE-AWS connector role |
<!-- END_TF_DOCS -->
