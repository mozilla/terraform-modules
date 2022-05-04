# Terraform Module: Google Artifact Registry repository
Creates a GAR repository and a service account to access it.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.0 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_artifact_registry_repository.repository](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository) | resource |
| [google-beta_google_artifact_registry_repository_iam_member.reader](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository_iam_member) | resource |
| [google-beta_google_artifact_registry_repository_iam_member.writer](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository_iam_member) | resource |
| [google_project_service.gar](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_service) | resource |
| [google_service_account.writer_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application, e.g. bouncer. | `string` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm, e.g. nonprod. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | n/a | `string` | `null` | no |
| <a name="input_format"></a> [format](#input\_format) | n/a | `string` | `"DOCKER"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location of the repository. Should generally be set to a multi-region location like 'us' or 'europe'. | `string` | `"us"` | no |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `null` | no |
| <a name="input_repository_id"></a> [repository\_id](#input\_repository\_id) | n/a | `string` | `null` | no |
| <a name="input_repository_readers"></a> [repository\_readers](#input\_repository\_readers) | List of principals that should be granted read access to the respository. | `list(string)` | `[]` | no |
| <a name="input_writer_service_account_id"></a> [writer\_service\_account\_id](#input\_writer\_service\_account\_id) | n/a | `string` | `"artifact-writer"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository"></a> [repository](#output\_repository) | n/a |
| <a name="output_writer_service_account"></a> [writer\_service\_account](#output\_writer\_service\_account) | n/a |
