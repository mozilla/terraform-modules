# Shared VPC-based GKE Module

Module creates an opinionated GKE cluster plus related resources within a Shared VPC context.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.35 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | ~> 5.35 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.35 |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | ~> 5.35 |

## Resources

| Name | Type |
|------|------|
| [google-beta_google_compute_address.static_v4_k8s_api_proxy_ip](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_compute_address) | resource |
| [google-beta_google_container_cluster.primary](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_container_cluster) | resource |
| [google-beta_google_container_node_pool.pools](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_container_node_pool) | resource |
| [google_bigquery_dataset.dataset](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset) | resource |
| [google_dns_record_set.k8s_api_proxy_dns_name](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_project_iam_member.cluster_service_account-defaults](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.cluster_service_account-gar](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.cluster_service_account-gcfs](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_project_iam_member.cluster_service_account-gcr](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.cluster_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_project.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_resource_usage_export_dataset"></a> [create\_resource\_usage\_export\_dataset](#input\_create\_resource\_usage\_export\_dataset) | The ID of a BigQuery Dataset for using BigQuery as the destination of resource usage export. Defaults to empty string. | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the cluster | `string` | `null` | no |
| <a name="input_disable_snat_status"></a> [disable\_snat\_status](#input\_disable\_snat\_status) | Whether the cluster disables default in-node sNAT rules. Defaults to false. | `bool` | `false` | no |
| <a name="input_dns_cache"></a> [dns\_cache](#input\_dns\_cache) | The status of the NodeLocal DNSCache addon. | `bool` | `true` | no |
| <a name="input_enable_cost_allocation"></a> [enable\_cost\_allocation](#input\_enable\_cost\_allocation) | Enables Cost Allocation Feature and the cluster name and namespace of your GKE workloads appear in the labels field of the billing export to BigQuery | `bool` | `false` | no |
| <a name="input_enable_dataplane"></a> [enable\_dataplane](#input\_enable\_dataplane) | Whether to enable dataplane v2 on the cluster. Sets DataPath field. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_gcfs"></a> [enable\_gcfs](#input\_enable\_gcfs) | Enable Google Container File System (gcfs) image streaming. | `bool` | `true` | no |
| <a name="input_enable_k8s_api_proxy_ip"></a> [enable\_k8s\_api\_proxy\_ip](#input\_enable\_k8s\_api\_proxy\_ip) | Whether we reserve an internal private ip for the k8s\_api\_proxy. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_network_egress_export"></a> [enable\_network\_egress\_export](#input\_enable\_network\_egress\_export) | Whether to enable network egress metering for this cluster. If enabled, a daemonset will be created in the cluster to meter network egress traffic. Doesn't work with Shared VPC (https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering). Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_private_cluster"></a> [enable\_private\_cluster](#input\_enable\_private\_cluster) | Determines whether the cluster is private or public. Defaults to private | `bool` | `true` | no |
| <a name="input_enable_public_cidrs_access"></a> [enable\_public\_cidrs\_access](#input\_enable\_public\_cidrs\_access) | Whether the control plane is open to Google public IPs. Defaults to false. | `bool` | `false` | no |
| <a name="input_enable_resource_consumption_export"></a> [enable\_resource\_consumption\_export](#input\_enable\_resource\_consumption\_export) | Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export. Defaults to true. | `bool` | `true` | no |
| <a name="input_filestore_csi_driver"></a> [filestore\_csi\_driver](#input\_filestore\_csi\_driver) | The status of the Filestore CSI driver addon, which allows the usage of filestore instance as volumes | `bool` | `false` | no |
| <a name="input_fuse_csi_driver"></a> [fuse\_csi\_driver](#input\_fuse\_csi\_driver) | The status of the GCSFuse CSI driver addon, which allows the usage of a gcs bucket as volumes | `bool` | `false` | no |
| <a name="input_gateway_api_enabled"></a> [gateway\_api\_enabled](#input\_gateway\_api\_enabled) | Enabled Gateway in the GKE Cluster | `bool` | `false` | no |
| <a name="input_google_group_name"></a> [google\_group\_name](#input\_google\_group\_name) | Name of the Google security group for use with Kubernetes RBAC. Must be in format: gke-security-groups@yourdomain.com | `string` | `null` | no |
| <a name="input_grant_registry_access"></a> [grant\_registry\_access](#input\_grant\_registry\_access) | Grants created cluster-specific service account storage.objectViewer and artifactregistry.reader roles. | `bool` | `true` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The Kubernetes version of the masters. If set to 'latest' it will pull latest available version. Defaults to 'latest'. | `string` | `"latest"` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | The GCE resource labels (a map of key/value pairs) to be applied to the cluster & other cluster-related resources. Merged with default labels (see locals.tf). | `map(string)` | `{}` | no |
| <a name="input_maintenance_exclusions"></a> [maintenance\_exclusions](#input\_maintenance\_exclusions) | List of maintenance exclusions. A cluster can have up to three | `list(object({ name = string, start_time = string, end_time = string }))` | `[]` | no |
| <a name="input_maintenance_start_time"></a> [maintenance\_start\_time](#input\_maintenance\_start\_time) | Time window specified for daily or recurring maintenance operations in RFC3339 format | `string` | `"21:00"` | no |
| <a name="input_master_authorized_networks"></a> [master\_authorized\_networks](#input\_master\_authorized\_networks) | List of master authorized networks that can access the GKE Master Plane. If none are provided, it defaults to known Bastion hosts for the given realm. See locals.tf for defaults. | `list(object({ cidr_block = string, display_name = string }))` | <pre>[<br/>  {<br/>    "cidr_block": "192.0.0.8/32",<br/>    "display_name": "tf module placeholder"<br/>  }<br/>]</pre> | no |
| <a name="input_master_ipv4_cidr_block"></a> [master\_ipv4\_cidr\_block](#input\_master\_ipv4\_cidr\_block) | The IP range in CIDR notation to use for the hosted master network. Overidden by shared\_vpc\_outputs. | `string` | `null` | no |
| <a name="input_monitoring_config_enable_components"></a> [monitoring\_config\_enable\_components](#input\_monitoring\_config\_enable\_components) | Monitoring configuration for the cluster | `list(string)` | <pre>[<br/>  "SYSTEM_COMPONENTS",<br/>  "APISERVER",<br/>  "SCHEDULER",<br/>  "CONTROLLER_MANAGER",<br/>  "STORAGE",<br/>  "HPA",<br/>  "POD",<br/>  "DAEMONSET",<br/>  "DEPLOYMENT",<br/>  "STATEFULSET"<br/>]</pre> | no |
| <a name="input_monitoring_enable_managed_prometheus"></a> [monitoring\_enable\_managed\_prometheus](#input\_monitoring\_enable\_managed\_prometheus) | Configuration for Managed Service for Prometheus. Whether or not the managed collection is enabled. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the cluster or application (required). | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | Shared VPC Network (formulated as a URL) wherein the cluster will be created. Overidden by shared\_vpc\_outputs. | `string` | `null` | no |
| <a name="input_node_pool_sa_roles"></a> [node\_pool\_sa\_roles](#input\_node\_pool\_sa\_roles) | n/a | `list` | <pre>[<br/>  "roles/logging.logWriter",<br/>  "roles/monitoring.metricWriter",<br/>  "roles/monitoring.viewer",<br/>  "roles/stackdriver.resourceMetadata.writer"<br/>]</pre> | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | Map containing node pools, with each node pool's name (or name\_prefix if `use_name_prefix` is true) being the key and the values being that node pool's configurations. Configurable options per node pool include: `disk_size_gb` (string), `disk_type` (string), `machine_type` (string), `max_count` (number), `max_surge` (number), `max_unavailable` (number), `min_count` (number), `use_name_prefix` (bool). See locals.tf for defaults. | `list(map(string))` | <pre>[<br/>  {<br/>    "name": "tf-default-node-pool"<br/>  }<br/>]</pre> | no |
| <a name="input_node_pools_guest_accelerator"></a> [node\_pools\_guest\_accelerator](#input\_node\_pools\_guest\_accelerator) | Map containing node pools guest accelerator. Each node pool's name is the key. See locals.tf for defaults. | `map(map(string))` | <pre>{<br/>  "tf-default-node-pool": {}<br/>}</pre> | no |
| <a name="input_node_pools_labels"></a> [node\_pools\_labels](#input\_node\_pools\_labels) | Map containing node pools non-default labels (as a map of strings). Each key is used as node pool's name prefix. See locals.tf for defaults. | `map(map(string))` | <pre>{<br/>  "tf-default-node-pool": {}<br/>}</pre> | no |
| <a name="input_node_pools_oauth_scopes"></a> [node\_pools\_oauth\_scopes](#input\_node\_pools\_oauth\_scopes) | Map containing node pools non-default OAuth scopes (as an list). Each node pool's name is the key. See locals.tf for defaults. | `map(list(string))` | <pre>{<br/>  "tf-default-node-pool": []<br/>}</pre> | no |
| <a name="input_node_pools_sysctls"></a> [node\_pools\_sysctls](#input\_node\_pools\_sysctls) | Map containing node pools non-default linux node config sysctls (as a map of maps). Each node pool's name is the key. | `map(map(any))` | <pre>{<br/>  "tf-default-node-pool": {}<br/>}</pre> | no |
| <a name="input_node_pools_tags"></a> [node\_pools\_tags](#input\_node\_pools\_tags) | Map containing node pools non-default tags (as an list). Each node pool's name is the key. See locals.tf for defaults. | `map(list(string))` | <pre>{<br/>  "tf-default-node-pool": []<br/>}</pre> | no |
| <a name="input_node_pools_taints"></a> [node\_pools\_taints](#input\_node\_pools\_taints) | Map containing node pools taints. Each node pool's name is the key. See locals.tf for defaults. | `map(list(map(string)))` | <pre>{<br/>  "tf-default-node-pool": [<br/>    {}<br/>  ]<br/>}</pre> | no |
| <a name="input_pods_ip_cidr_range_name"></a> [pods\_ip\_cidr\_range\_name](#input\_pods\_ip\_cidr\_range\_name) | The Name of the IP address range for cluster pods IPs. Overidden by shared\_vpc\_outputs. | `string` | `null` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID to host the cluster in. | `string` | `null` | no |
| <a name="input_project_outputs"></a> [project\_outputs](#input\_project\_outputs) | Sets cluster-related variables based on a homegrown Project outputs data structure. | <pre>object({<br/>    id            = string<br/>    name          = string<br/>    number        = string<br/>    zone_dns_name = string<br/>    zone_name     = string<br/>  })</pre> | `null` | no |
| <a name="input_realm"></a> [realm](#input\_realm) | Name of infrastructure realm (e.g. prod or nonprod). | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region where cluster & other regional resources should be provisioned. Defaults to us-central1. | `string` | `null` | no |
| <a name="input_registry_project_ids"></a> [registry\_project\_ids](#input\_registry\_project\_ids) | Projects holding Google Container Registries. If empty, we use the cluster project. If a service account is created and the `grant_registry_access` variable is set to `true`, the `storage.objectViewer` and `artifactregsitry.reader` roles are assigned on these projects. | `list(string)` | `[]` | no |
| <a name="input_release_channel"></a> [release\_channel](#input\_release\_channel) | The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`. | `string` | `"REGULAR"` | no |
| <a name="input_resource_usage_export_dataset_id"></a> [resource\_usage\_export\_dataset\_id](#input\_resource\_usage\_export\_dataset\_id) | The ID of a BigQuery Dataset for using BigQuery as the destination of resource usage export. Defaults to null. | `string` | `null` | no |
| <a name="input_service_account_id"></a> [service\_account\_id](#input\_service\_account\_id) | Id of the service account to be provisioned, overrides the default 'gke-cluster\_name' value | `string` | `null` | no |
| <a name="input_service_subnetworks"></a> [service\_subnetworks](#input\_service\_subnetworks) | Service subnetworks associated with Shared VPC, segmented by region | <pre>map(object({<br/>    ip_cidr_range = string<br/>    network       = string<br/>    region        = string<br/>    subnet_name   = string<br/>    subnetwork    = string<br/>    subnetwork_id = string<br/>  }))</pre> | `null` | no |
| <a name="input_services_ip_cidr_range_name"></a> [services\_ip\_cidr\_range\_name](#input\_services\_ip\_cidr\_range\_name) | The Name of the IP address range for cluster services IPs. Overidden by shared\_vpc\_outputs. | `string` | `null` | no |
| <a name="input_shared_vpc_outputs"></a> [shared\_vpc\_outputs](#input\_shared\_vpc\_outputs) | Sets networking-related variables based on a homegrown Shared VPC Terraform outputs data structure. | <pre>object({<br/>    ip_cidr_range = object({<br/>      master     = string<br/>      pod        = string<br/>      primary    = string<br/>      service    = string<br/>      additional = map(string)<br/>    })<br/>    network    = string<br/>    project_id = string<br/>    region     = string<br/>    secondary_ip_ranges = object({<br/>      pod = object({<br/>        ip_cidr_range = string<br/>        range_name    = string<br/>      })<br/>      service = object({<br/>        ip_cidr_range = string<br/>        range_name    = string<br/>      })<br/>    })<br/>    additional_ip_ranges = map(map(string))<br/>    subnet_name          = string<br/>    subnetwork           = string<br/>    subnetwork_id        = string<br/>  })</pre> | `null` | no |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Shared VPC Subnetwork (formulated as a URL) wherein the cluster will be created. Overidden by shared\_vpc\_outputs. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The GCE resource tags (a list of strings) to be applied to the cluster & other cluster-related resources. Merged with default tags (see locals.tf). | `list(string)` | `[]` | no |
| <a name="input_vertical_pod_autoscaling"></a> [vertical\_pod\_autoscaling](#input\_vertical\_pod\_autoscaling) | Enables Vertical Pod Autoscaling in the cluster | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ca_certificate"></a> [ca\_certificate](#output\_ca\_certificate) | CA Certificate for the Cluster |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Cluster endpoint |
| <a name="output_k8s_api_proxy_dns_name"></a> [k8s\_api\_proxy\_dns\_name](#output\_k8s\_api\_proxy\_dns\_name) | K8s api proxy dns record |
| <a name="output_location"></a> [location](#output\_location) | Cluster location (region) |
| <a name="output_master_version"></a> [master\_version](#output\_master\_version) | Current Kubernetes master version |
| <a name="output_name"></a> [name](#output\_name) | Cluster name |
| <a name="output_node_pools"></a> [node\_pools](#output\_node\_pools) | List of node pools |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | Cluster Service Account |

## Simple Example

This uses distinct networking variables and the (module) default node pool.

```hcl
data "terraform_remote_state" "vpc" {
  backend = "gcs"

  config = {
    bucket = "my-state-bucket"
    prefix = "projects/my-sharedvpc-project"
  }
}

module "gke" {
  source = "github.com/mozilla/terraform-modules//google_gke?ref=main"

  name       = "my-cluster"
  project_id = "shared-clusters"
  realm      = "nonprod"
  region     = "us-west1"

  master_ipv4_cidr_block      = "1.2.3.4/28"
  network                     = "projects/my-vpc-project/global/networks/my-vpc-network"
  pods_ip_cidr_range_name     = "my-pods-or-cluster-secondary-range-name"
  services_ip_cidr_range_name = "my-services-secondary-range-name"
  subnetwork                  = "projects/my-vpc-project/regions/us-west1/subnetworks/my-subnetwork"

  # don't expect metrics to BQ
  enable_resource_consumption_export = false

  # who can access the k8s control plane
  # adds placeholder bastion network by default
  master_authorized_networks = [
    {
      cidr_block   = "1.2.3.4/32"
      display_name = "bastion"
    }
  ]
}
```

## Complex Example 1

 This uses a Mozilla-internal Shared VPC Terraform outputs variable for networking. It also sets up cluster to be able to access GAR images in a different project.

```hcl
data "terraform_remote_state" "vpc" {
  backend = "gcs"

  config = {
    bucket = "my-state-bucket"
    prefix = "projects/my-sharedvpc-project"
  }
}

module "gke" {
  source = "github.com/mozilla/terraform-modules//google_gke?ref=main"

  name               = "my-cluster"
  project_id         = "shared-clusters"
  realm              = "nonprod"
  region             = "us-west1"
  shared_vpc_outputs = data.terraform_remote_state.projects.outputs.projects.shared.nonprod.id["shared-clusters"].regions["us-west1"]

  # export metrics to a module-created BigQuery dataset
  create_resource_usage_export_dataset = true

  # access docker image GARs in another project
  # (self-same cluster project id included by default)
  registry_project_ids = [
    "team-app1"
  ]

  # who can access the k8s control plane
  # adds placeholder bastion network by default
  master_authorized_networks = [
    {
      cidr_block   = "1.2.3.4/32"
      display_name = "bastion"
    }
  ]
}

```

## Complex Example 2

 This uses a Mozilla-internal Shared VPC Terraform outputs variable for networking. It creates multiple node pools with some defaults changed per node pool.

```hcl
data "terraform_remote_state" "vpc" {
  backend = "gcs"

  config = {
    bucket = "my-state-bucket"
    prefix = "projects/my-sharedvpc-project"
  }
}

module "gke" {
  source = "github.com/mozilla/terraform-modules//google_gke?ref=main"

  name               = "my-cluster"
  project_id         = "shared-clusters"
  realm              = "nonprod"
  region             = "us-west1"
  shared_vpc_outputs = data.terraform_remote_state.projects.outputs.projects.shared.nonprod.id["shared-clusters"].regions["us-west1"]

  # export metrics to a pre-created BigQuery dataset
  resource_usage_export_dataset_id = "cluster_metrics_dataset"

  # Don't use module-defaults node pool
  # second node pool has special labels for np 2 only;
  # see locals.tf for default values
  node_pools = [
    {
      name = "nodepool-1"
    },
    {
      name         = "nodepool-2"
      machine_type = "n2-standard-2"
      max_count    = 6
    }
  ]

  node_pools_labels = {
    nodepool-2 = {
      "my-np2-label" = "some-value"
    }
  }

  # who can access the k8s control plane
  # adds placeholder bastion network by default
  master_authorized_networks = [
    {
      cidr_block   = "1.2.3.4/32"
      display_name = "bastion"
    }
  ]
}
```
