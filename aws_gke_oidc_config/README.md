<!-- BEGIN_TF_DOCS -->
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
  source = "../."

  oidc_providers = {
    mgmt = {
      gcp_region       = "us-west1"
      gcp_project_id   = "moz-fx-platform-mgmt-global"
      gke_cluster_name = "global-platform-admin-mgmt"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_oidc_providers"></a> [oidc\_providers](#input\_oidc\_providers) | Map of GKE clusters and/or Spacelift instances to provision OIDC provider for | <pre>map(object({<br/>    gcp_project_id     = optional(string)<br/>    gcp_region         = optional(string)<br/>    gke_cluster_name   = optional(string)<br/>    spacelift_instance = optional(string)<br/>  }))</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->