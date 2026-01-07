# AWS-GKE OIDC Config
This module will create 2 AWS OIDC configs that create a trust relationship between a GKE cluster & AWS account, and our Spacelift instance with the same AWS account.

Once this module has been invoked for a given account + GKE cluster, the `aws_gke_oidc_role` module can be used
to create any number of roles to be used by GKE workloads & Spacelift.

See the `aws_gke_oidc_role` for complete usage instructions

## Example

```hcl
/*
 * Creates an OIDC trust relationship between the global-platform-admin-mgmt cluster & the authenticated AWS account.
 */

module "oidc_config" {
  source           = "../."
  gcp_region       = "us-west1"
  gcp_project_id   = "moz-fx-platform-mgmt-global"
  gke_cluster_name = "global-platform-admin-mgmt"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_project_id"></a> [gcp\_project\_id](#input\_gcp\_project\_id) | ID of the GKE cluster's project | `string` | n/a | yes |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GKE cluster's GCP region | `string` | n/a | yes |
| <a name="input_gke_cluster_name"></a> [gke\_cluster\_name](#input\_gke\_cluster\_name) | GKE cluster name | `string` | n/a | yes |
| <a name="input_spacelift_instance"></a> [spacelift\_instance](#input\_spacelift\_instance) | Spacelift instance to establish OIDC trust relationship | `string` | `"mozilla.app.spacelift.io"` | no |

## Outputs

No outputs.
