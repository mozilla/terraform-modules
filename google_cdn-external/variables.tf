variable "application" {
  type        = string
  description = "Application name."
}

variable "environment" {
  type        = string
  description = "Environment name."
}

variable "name" {
  type        = string
  description = "Optional name of distribution."
  default     = ""
}

variable "origin_fqdn" {
  type        = string
  description = "Origin's fqdn: e.g., 'mozilla.org'."
}

variable "origin_port" {
  type        = number
  default     = 443
  description = "Port to use for origin."
}

variable "origin_protocol" {
  type        = string
  default     = "HTTPS"
  description = "Protocol for the origin."
}

variable "primary_hostname" {
  type        = string
  description = "Primary hostname of service."
}

variable "certs" {
  type        = list(string)
  description = "List of certificates ids. If this list is empty, this will be HTTP only."
}

variable "https_redirect" {
  type        = bool
  default     = true
  description = "Redirect from http to https."
}

variable "addresses" {
  type = object({
    ipv4 = string,
    ipv6 = string,
  })
  description = "IP Addresses."
}

variable "path_rewrites" {
  description = "Dictionary of path matchers."
  type = map(object({
    hosts  = list(string)
    paths  = list(string)
    target = string
  }))
  default = {}
}

variable "security_policy" {
  description = "Security policy as defined by google_compute_security_policy"
  type        = string
  default     = null
}

variable "compression_mode" {
  description = "Can be AUTOMATIC or DISABLED"
  type        = string
  default     = "DISABLED"
}

variable "cdn_policy" {
  description = "CDN policy config to be passed to backend service."
  type        = map(any)
  default     = {}
}

variable "cache_key_policy" {
  description = "Cache key policy config to be passed to backend service."
  type        = map(any)
  default     = {}
}

variable "negative_caching_policy" {
  description = "Negative caching policy config to be passed to backend service."
  type = list(object({
    code = string
    ttl  = string
  }))
  default = []
}

variable "log_sample_rate" {
  description = "Sample rate for Cloud Logging. Must be in the interval [0, 1]."
  type        = number
  default     = 1.0
}

variable "backend_timeout_sec" {
  type        = number
  default     = 10
  description = "Timeout for backend service."
}

variable "quic_override" {
  description = "Specifies the QUIC override policy. Possible values `NONE`, `ENABLE`, `DISABLE`"
  type        = string
  default     = "DISABLE"
}
