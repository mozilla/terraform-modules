variable "identifier" {
  type = string
}

variable "certificates" {
  type = list(object({
    hostname     = string
    add_wildcard = optional(bool, false)
  }))
}
