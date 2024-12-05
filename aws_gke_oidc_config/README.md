<!-- BEGIN_TF_DOCS -->
# AWS-GKE OIDC Config
This module will create an AWS OIDC config that creates a trust relationship between a GKE cluster & AWS account.

Once this module has been invoked for a given account + GKE cluster, the `aws_gke_oidc_role` module can be used
to create any number of roles to be used by GKE workloads.

See the `aws_gke_oidc_role` for complete usage instructions

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.76.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.gke_oidc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [tls_certificate.gke_oidc](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | ID of the GKE cluster's project | `string` | n/a | yes |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GKE cluster's GCP region | `string` | n/a | yes |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | GKE cluster name | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->