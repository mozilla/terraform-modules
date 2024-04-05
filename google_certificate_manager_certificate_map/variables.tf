variable "custom_name_prefix" {
  description = "use this to set a custom name_prefix for resource names"
  type        = string
  default     = ""
}

variable "application" {
  type = string
}

variable "realm" {
  type = string
}

variable "environment" {
  type = string
}

variable "risk_level" {
  type    = string
  default = "low"
}

variable "certificates" {
  description = "list of objects defining certificates to be added to the certmap"
  type = list(object({
    hostname           = string
    dns_authorization  = optional(bool, false)
    additional_domains = optional(list(string), [])
  }))
  default = []
}
