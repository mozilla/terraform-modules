#
# Cluster Metadata
#
variable "description" {
  default     = null
  description = "The description of the cluster"
  type        = string
}

variable "kubernetes_version" {
  default     = "latest"
  description = "The Kubernetes version of the masters. If set to 'latest' it will pull latest available version. Defaults to 'latest'."
  type        = string
}

variable "labels" {
  default     = {}
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster & other cluster-related resources. Merged with default labels (see locals.tf)."
  type        = map(string)
}

variable "name" {
  description = "Name of the cluster or application (required)."
  type        = string
}

variable "project_id" {
  default     = null
  description = "The project ID to host the cluster in."
  type        = string
}

variable "realm" {
  description = "Name of infrastructure realm (e.g. prod or nonprod)."
  type        = string

  validation {
    condition     = contains(["mgmt", "nonprod", "prod"], var.realm)
    error_message = "Valid values for realm: mgmt, nonprod, prod."
  }
}

variable "region" {
  default     = "us-central1"
  description = "Region where cluster & other regional resources should be provisioned. Defaults to us-central1."
  type        = string
}

variable "release_channel" {
  default     = "REGULAR"
  description = "The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `REGULAR`."
  type        = string
}

variable "tags" {
  default     = []
  description = "The GCE resource tags (a list of strings) to be applied to the cluster & other cluster-related resources. Merged with default tags (see locals.tf)."
  type        = list(string)
}


#
# Cluster Maintenance Settings
#
variable "maintenance_exclusions" {
  default     = []
  description = "List of maintenance exclusions. A cluster can have up to three"
  type        = list(object({ name = string, start_time = string, end_time = string }))
}

variable "maintenance_start_time" {
  default     = "21:00" # 1 or 2pm pacific, which is typically the low traffic point.
  description = "Time window specified for daily or recurring maintenance operations in RFC3339 format"
  type        = string
}


#
# Cluster Networking
#
variable "shared_vpc_outputs" {
  default     = null
  description = "Sets networking-related variables based on a homegrown Shared VPC Terraform outputs data structure."
  type = object({
    ip_cidr_range = object({
      master  = string
      pod     = string
      primary = string
      service = string
    })
    network    = string
    project_id = string
    region     = string
    secondary_ip_ranges = object({
      pod = object({
        ip_cidr_range = string
        range_name    = string
      })
      service = object({
        ip_cidr_range = string
        range_name    = string
      })
    })
    subnet_name   = string
    subnetwork    = string
    subnetwork_id = string
  })
}

variable "master_authorized_networks" {
  default     = []
  description = "List of master authorized networks that can access the GKE Master Plane. If none are provided, it defaults to known Bastion hosts for the given realm. See locals.tf for defaults."
  type        = list(object({ cidr_block = string, display_name = string }))
}

variable "master_ipv4_cidr_block" {
  default     = null
  description = "The IP range in CIDR notation to use for the hosted master network. Overidden by shared_vpc_outputs."
  type        = string
}

variable "network" {
  default     = null
  description = "Shared VPC Network (formulated as a URL) wherein the cluster will be created. Overidden by shared_vpc_outputs."
  type        = string
}

variable "pods_ip_cidr_range_name" {
  default     = null
  description = "The Name of the IP address range for cluster pods IPs. Overidden by shared_vpc_outputs."
  type        = string
}

variable "services_ip_cidr_range_name" {
  default     = null
  description = "The Name of the IP address range for cluster services IPs. Overidden by shared_vpc_outputs."
  type        = string
}

variable "subnetwork" {
  default     = null
  description = "Shared VPC Subnetwork (formulated as a URL) wherein the cluster will be created. Overidden by shared_vpc_outputs."
  type        = string
}


#
# Cluster Nodes
#
variable "node_pools" {
  description = "Map containing node pools, with each node pool's name being the key and the values being that node pool's configurations. Configurable options per node pool include: `disk_size_gb` (string), `machine_type` (string), `max_count` (number), `max_surge` (number), `max_unavailable` (number), `min_count` (number). See locals.tf for defaults."
  type        = list(map(string))
  default = [
    {
      name = "tf-default-node-pool"
    }
  ]
}

variable "node_pools_labels" {
  description = "Map containing node pools non-default labels (as a map of strings). Each node pool's name is the key. See locals.tf for defaults."
  type        = map(map(map(string)))
  default = {
    tf-default-node-pool = {}
  }
}

variable "node_pools_oauth_scopes" {
  description = "Map containing node pools non-default OAuth scopes (as an list). Each node pool's name is the key. See locals.tf for defaults."
  type        = map(list(string))
  default = {
    tf-default-node-pool = []
  }
}

variable "node_pools_sysctls" {
  description = "Map containing node pools non-default linux node config sysctls (as a map of maps). Each node pool's name is the key."
  type        = map(map(any))
  default = {
    tf-default-node-pool = {}
  }
}

variable "node_pools_tags" {
  description = "Map containing node pools non-default tags (as an list). Each node pool's name is the key. See locals.tf for defaults."
  type        = map(list(string))
  default = {
    tf-default-node-pool = []
  }
}

#
# Monitoring
#
variable "create_resource_usage_export_dataset" {
  default     = false
  description = "The ID of a BigQuery Dataset for using BigQuery as the destination of resource usage export. Defaults to empty string."
  type        = bool
}

variable "enable_network_egress_export" {
  default     = false
  description = "Whether to enable network egress metering for this cluster. If enabled, a daemonset will be created in the cluster to meter network egress traffic. Doesn't work with Shared VPC (https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-usage-metering). Defaults to false."
  type        = bool
}

variable "enable_resource_consumption_export" {
  default     = true
  description = "Whether to enable resource consumption metering on this cluster. When enabled, a table will be created in the resource export BigQuery dataset to store resource consumption data. The resulting table can be joined with the resource usage table or with BigQuery billing export. Defaults to true."
  type        = bool
}

variable "resource_usage_export_dataset_id" {
  default     = null
  description = "The ID of a BigQuery Dataset for using BigQuery as the destination of resource usage export. Defaults to null."
  type        = string
}


#
# Cluster Permissions & Service Account(s)
#
variable "grant_registry_access" {
  default     = true
  description = "Grants created cluster-specific service account storage.objectViewer and artifactregistry.reader roles."
  type        = bool
}

variable "node_pool_sa_roles" {
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ]
}

variable "registry_project_ids" {
  default     = []
  description = "Projects holding Google Container Registries. If empty, we use the cluster project. If a service account is created and the `grant_registry_access` variable is set to `true`, the `storage.objectViewer` and `artifactregsitry.reader` roles are assigned on these projects."
  type        = list(string)
}
