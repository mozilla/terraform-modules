<!-- BEGIN_TF_DOCS -->
# Terraform Module: Google Artifact Registry repository
Creates a GAR repository and a service account to access it.

## Examples

```hcl
module "gar" {
  source = "github.com/mozilla/terraform-modules//google_gar?ref=main"

  description        = "Default repository for test project"
  application        = "glonk"
  realm              = "nonprod"
  repository_readers = ["user:jdoe@firefox.gcp.mozilla.com"]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application, e.g. bouncer. | `string` | n/a | yes |
| <a name="input_cleanup_policies"></a> [cleanup\_policies](#input\_cleanup\_policies) | n/a | <pre>map(object({<br/>    id     = string<br/>    action = string<br/>    condition = optional(object({<br/>      tag_state             = string<br/>      tag_prefixes          = string<br/>      version_name_prefixes = any<br/>      package_name_prefixes = any<br/>      older_than            = any<br/>      newer_than            = any<br/>    }))<br/>    most_recent_versions = optional(object({<br/>      package_name_prefixes = any<br/>      keep_count            = any<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `null` | no |
| <a name="input_format"></a> [format](#input\_format) | n/a | `string` | `"DOCKER"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the repository. Should generally be set to a multi-region location like 'us' or 'europe'. | `string` | `"us"` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `null` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm, e.g. nonprod. | `string` | n/a | yes |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | n/a | `string` | `null` | no |
| <a name="input_repository_readers"></a> [repository\_readers](#input\_repository\_readers) | List of principals that should be granted read access to the repository. | `list(string)` | `[]` | no |
| <a name="input_writer_service_account_id"></a> [writer\_service\_account\_id](#input\_writer\_service\_account\_id) | n/a | `string` | `"artifact-writer"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository"></a> [repository](#output\_repository) | n/a |
| <a name="output_writer_service_account"></a> [writer\_service\_account](#output\_writer\_service\_account) | n/a |
<!-- END_TF_DOCS -->
