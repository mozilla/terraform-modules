variable "gcp_region" {
  description = "GCP region"
  type        = string
}

variable "ip_address_purpose" {
  description = "The purpose of the IP address"
  type        = string
  default     = "GCE_ENDPOINT"
}

variable "name" {
  description = "GCP project name"
  type        = string
}

variable "network_name" {
  description = "VPC network name"
  type        = string
}

variable "project_id_for_network" {
  description = "The project ID of the network"
  type        = string
  default     = ""
}

variable "subnetwork_name" {
  description = "VPC subnetwork name"
  type        = string
}
