variable "region" {
  default = "us-central1"
}

variable "environment" {
  default = ""
}

variable "kubernetes_version" {
  description = "Version of kubernetes to setup"
  default     = "latest"
}

variable "release_channel" {
  type        = string
  description = "(Beta) The release channel of this cluster. Accepted values are `UNSPECIFIED`, `RAPID`, `REGULAR` and `STABLE`. Defaults to `UNSPECIFIED`."
  default     = "REGULAR"
}

variable "costcenter" {}

variable "project_id" {}

variable "name" {}

variable "network" {}

variable "subnetwork" {}

variable "ip_range_pods" {
  default = ""
}

variable "ip_range_services" {
  default = ""
}

variable "regional" {
  description = "Configure cluster as a regional or zonal cluster"
  default     = false
}

variable "cluster_resource_labels" {
  description = "The GCE resource labels (a map of key/value pairs) to be applied to the cluster"
  type        = map(string)
  default     = {}
}

variable "cluster_addons" {
  description = "List of addons to install on cluster"
  type        = map(string)
  default     = {}
}

variable "cluster_features" {
  description = "Additional packages to install via helm onto cluster"
  type        = map(string)
  default     = {}
}

variable "node_pools" {
  description = "List of maps containing node pools"
  type        = list(map(string))
  default = [
    {
      name               = "default-node-pool",
      machine_type       = "n2-standard-4"
      min_count          = "1"
      max_count          = "20"
      max_surge          = "3"
      autoscaling        = true
      auto_repair        = true
      auto_upgrade       = true
      initial_node_count = 2
    }
  ]
}

variable "velero_settings" {
  description = "Settings for velero helm chart"
  type        = map(string)
  default     = {}
}

variable "flux_settings" {
  description = "Settings for flux helm chart"
  type        = map(string)
  default     = {}
}

variable "prometheus_settings" {
  description = "Settings for prometheus helm chart"
  type        = map(string)
  default     = {}
}

variable "external_secrets_settings" {
  description = "Settings for external secrets helm chart"
  type        = map(string)
  default     = {}
}
