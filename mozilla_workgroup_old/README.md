# Mozilla Workgroup

Builds on top of the [google workgroup module](../google_workgroup/) and contains constants for mozilla environments. This is the default to use for creating our internal tenants.

<!-- START_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_workgroup"></a> [workgroup](#module\_workgroup) | github.com/mozilla/terraform-modules//google_workgroup | OPST-682 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ids"></a> [ids](#input\_ids) | List of workgroup identifiers to look up access for | `set(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_google_groups"></a> [google\_groups](#output\_google\_groups) | google groups associated with the input workgroups, unqualified |
| <a name="output_members"></a> [members](#output\_members) | authoritative, fully-qualified list of members associated with the input workgroups |

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_workgroup"></a> [workgroup](#module\_workgroup) | github.com/mozilla/terraform-modules//google_workgroup | main |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ids"></a> [ids](#input\_ids) | List of workgroup identifiers to look up access for | `set(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_google_groups"></a> [google\_groups](#output\_google\_groups) | google groups associated with the input workgroups, unqualified |
| <a name="output_members"></a> [members](#output\_members) | authoritative, fully-qualified list of members associated with the input workgroups |
<!-- END_TF_DOCS -->