
# google_datastream
## WARNING! This is very un-customized. You will probably have to modify the module to suit your own needs if you're not using postgresql.



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 4.51.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 4.51.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application e.g., bouncer. | `any` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | n/a | `string` | `"datastream"` | no |
| <a name="input_datastream_subnet"></a> [datastream\_subnet](#input\_datastream\_subnet) | The subnet in our VPC for datastream to use. Like '172.19.0.0/29'. See https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/27920489/GCP+Subnet+Allocations for what's been allocated. | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment e.g., stage. | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Where to create the datastream profiles and the destination datasets | `string` | `"us-west1"` | no |
| <a name="input_postgresql_profile"></a> [postgresql\_profile](#input\_postgresql\_profile) | PostgreSQL profile | <pre>list(object({<br>    hostname = string<br>    username = string<br>    database = string<br>  }))</pre> | `[]` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Name of the project | `any` | n/a | yes |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm e.g., nonprod. | `string` | `""` | no |
| <a name="input_vpc_network"></a> [vpc\_network](#input\_vpc\_network) | The id of the default VPC shared by all our projects | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_stream_id"></a> [stream\_id](#output\_stream\_id) | n/a |
| <a name="output_stream_name"></a> [stream\_name](#output\_stream\_name) | n/a |
