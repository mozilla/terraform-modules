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

variable "project_id" {
  description = "Name of the project"
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

#variable "source_connection_profile_name" {
#  description = "You need to create a source_connection_profile manually (https://console.cloud.google.com/datastream/connection-profiles/create) and provide the Connection profile name you chose here. YOU WON'T BE ABLE TO CREATE THIS UNTIL APPLYING THIS PLAN THE FIRST TIME"
#  default     = "profile"
#}

variable "postgresql_profile" {
  description = "PostgreSQL profile"
  type = list(object({
    hostname = string
    username = string
    database = string
  }))
  default = []
}

