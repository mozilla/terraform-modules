<!-- BEGIN_TF_DOCS -->
# anthropic\_workloads

Service accounts and federation rules that let workloads call the Anthropic API with their own OIDC token instead of an API key.

Issuers and workspaces are created elsewhere and passed in by ID. The provider must authenticate with an `org:admin` token.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | The name of the application (tenant app\_code). Every workload name must start with it. | `string` | n/a | yes |
| <a name="input_audience"></a> [audience](#input\_audience) | Audience the identity token must carry. | `string` | `"https://api.anthropic.com"` | no |
| <a name="input_workloads"></a> [workloads](#input\_workloads) | Workloads that call the Anthropic API with their own OIDC token. The key is the name of the<br/>service account and federation rule, in the form <app\_code>-<env\_code>-<component\_code>.<br/>claims are the exact claims the identity token must carry. | <pre>map(object({<br/>    issuer_id    = string<br/>    workspace_id = string<br/>    claims       = map(string)<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_workloads"></a> [workloads](#output\_workloads) | Federation rule and service account IDs that each workload exchanges its OIDC token against. |
<!-- END_TF_DOCS -->
