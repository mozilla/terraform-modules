variable "application" {
  type = string
}

variable "realm" {
  type = string
}

variable "environment" {
  type = string
}

variable "name_prefix" {
  description = "prefix for resource names"
  type        = string
  default     = ""
}

variable "bucket_name" {
  description = "name of bucket to use for the CDN"
  type        = string
}

variable "addresses" {
  description = "loadbalancer ips"
  type        = map(string)
}

variable "certificates" {
  description = "list of certificate ids to use on the https target proxy"
  type        = list(string)
}

variable "compression_mode" {
  type    = string
  default = "DISABLED"
}

variable "cdn_policy" {
  description = "cdn policy"
  type = object({
    cache_mode        = optional(string, "CACHE_ALL_STATIC")
    client_ttl        = optional(number, 3600)
    default_ttl       = optional(number, 3600)
    max_ttl           = optional(number, 86400)
    negative_caching  = optional(bool, true)
    serve_while_stale = optional(number, 86400)
  })
}
