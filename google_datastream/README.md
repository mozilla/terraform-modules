
# google_datastream
## WARNING! This is module only does part of the work. Because setting up postgresql as a source (the only thing I've tested) requires a valid database username and password, and we don't want to store passwords in Terraform, this module will only create a Private Connectivity Connection and a BigQuery Destination profile.
### Prework
- Pick a new /29 network for Datastream to use. This is the datastream_subnet under Inputs below. Add the subnet to https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/27920489/GCP+Subnet+Allocations for tracking
- Create a CloudSQL Auth Proxy so Datastream can connect to Cloud SQL
  - Doing this is outside the scope of these docs (that's convenient!), but see here for an example
    - CloudSQL Auth Proxy Deployment: https://github.com/mozilla-it/webservices-infra/blob/main/moztodon/k8s/moztodon/templates/deployment-cloudsqlauthproxy.yaml
    - CloudSQL Auth Proxy Service: https://github.com/mozilla-it/webservices-infra/blob/main/moztodon/k8s/moztodon/templates/service-cloudsqlauthproxy.yaml
  - **Note the IP Address of the resulting Loadbalancer, you'll need it below**
### After this module runs, you will need to:
- [This might be mostly specific to Cloud SQL and Postgresql specifically]
- Create a SQL user for Datastream to act as in your source database. Save the password
- Create a new Stream (which includes setting up the Source Profile) manually
  - Go to the Datastream console for your project: https://console.cloud.google.com/datastream/streams
  - Choose CREATE STREAM
  - Enter the username, password, IP (this is the IP of the CloudSQL Proxy from above), and database name
  - For Postgresql specifically, you'll also be instructed to:
    - Enable logical replication on the database
    - This involves adding a database flag (which requires a db reboot)
  - Create a publication and a replication slot
    - In SQL you'll need to create a Publication, create a replication slot, and modify permissions for the datastream replication sql user (the console will provide sample queries to accomplish this)



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.71 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.71 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application e.g., bouncer. | `any` | n/a | yes |
| <a name="input_datastream_subnet"></a> [datastream\_subnet](#input\_datastream\_subnet) | The subnet in our VPC for datastream to use. Like '172.19.0.0/29'. See https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/27920489/GCP+Subnet+Allocations for what's been allocated. | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment e.g., stage. | `any` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Name of the project | `any` | n/a | yes |
| <a name="input_vpc_network"></a> [vpc\_network](#input\_vpc\_network) | The id of the default VPC shared by all our projects | `any` | n/a | yes |
| <a name="input_component"></a> [component](#input\_component) | n/a | `string` | `"datastream"` | no |
| <a name="input_location"></a> [location](#input\_location) | Where to create the datastream profiles and the destination datasets | `string` | `"us-west1"` | no |
| <a name="input_postgresql_profile"></a> [postgresql\_profile](#input\_postgresql\_profile) | PostgreSQL profile | <pre>list(object({<br>    hostname = string<br>    username = string<br>    database = string<br>  }))</pre> | `[]` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | Realm e.g., nonprod. | `string` | `""` | no |

## Outputs

No outputs.
