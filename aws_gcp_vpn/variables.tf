variable "aws_private_asn" {
  description = "ASN for AWS VPN gateway"
  type        = number

  validation {
    condition     = var.aws_private_asn >= 64512 && var.aws_private_asn <= 65534
    error_message = "ASN must be between 64512 and 65534."
  }
}

variable "aws_vpc_id" {
  description = "AWS VPC id"
  type        = string
}

variable "aws_vpn_gateway_id" {
  description = "AWS VPN Gateway ID"
  type        = string
}

variable "gcp_advertised_ip_ranges" {
  default     = []
  description = "value"
  type        = set(object({ description = string, range = string }))
}

variable "gcp_network_name" {
  default     = "default"
  description = "GCP VPN network name"
  type        = string
}

variable "gcp_private_asn" {
  description = "ASN for GCP VPN gateway"
  type        = number

  validation {
    condition     = var.gcp_private_asn >= 64512 && var.gcp_private_asn <= 65534
    error_message = "ASN must be between 64512 and 65534."
  }
}

variable "gcp_project_id" {
  description = "GCP project id"
  type        = string
}
