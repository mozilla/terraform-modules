variable "identifier" {
  type = string
}

variable "certificates" {
  type = list(object({
    hostname          = string
    add_wildcard      = optional(bool, false)
    dns_authorization = optional(bool, false)
  }))
}
