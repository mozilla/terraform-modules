variable "gcp_region" {
  description = "GCP region"
  type        = string
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
  type        = optional(string)
}

variable "subnetwork_name" {
  description = "VPC subnetwork name"
  type        = string
}
