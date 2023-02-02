variable "application" {
  description = "Application e.g., bouncer."
}

variable "environment" {
  description = "Environment e.g., stage."
}

variable "location" {
  default     = "us-west1"
  description = "Where to create the datastream profiles and the destination datasets"
}

variable "realm" {
  default     = ""
  description = "Realm e.g., nonprod."
}

variable "component" {
  default = "datastream"
}

variable "vpc_network" {
  description = "The id of the default VPC shared by all our projects"
}

variable "datastream_subnet" {
  description = "The subnet in our VPC for datastream to use. Like '172.19.0.0/29'. See https://mozilla-hub.atlassian.net/wiki/spaces/SRE/pages/27920489/GCP+Subnet+Allocations for what's been allocated."
}
