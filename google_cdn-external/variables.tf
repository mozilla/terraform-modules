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
    hosts                = list(string)
    paths                = list(string)
    target               = string
    backend_bucket_paths = optional(list(string))
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

variable "bypass_cache_on_request_headers" {
  description = "Headers to match when bypassing cache"
  type        = list(string)
  default     = []
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

variable "custom_response_headers" {
  type        = list(string)
  default     = null
  description = "Headers that the HTTP/S load balancer should add to proxied responses."
}

variable "backend_type" {
  type        = string
  default     = "service"
  description = "Backend type to create. Must be set to one of [service, bucket, service_and_bucket]. When service_and_bucket, the default backend is the service"
}

variable "bucket_name" {
  type        = string
  default     = ""
  description = "Name of GCS bucket to use as CDN backend. Required if backend_type is set to 'bucket' or 'service_and_bucket'."
}

variable "backend_bucket_name_override" {
  type        = string
  default     = ""
  description = "Force a particular name for CDN backend bucket. Should only be used for legacy infra."
}

variable "load_balancing_scheme" {
  type        = string
  default     = "EXTERNAL"
  description = "Load balancing scheme for the backend service and global forwarding rules. One of `EXTERNAL`, `EXTERNAL_MANAGED`, `EXTERNAL_PASSTHROUGH`, `INTERNAL_MANAGED` or `INTERNAL_SELF_MANAGED`. Defaults to `EXTERNAL`, which was the Google provider's default before v8.0. Moving an existing load balancer from `EXTERNAL` to `EXTERNAL_MANAGED` requires the `external_managed_*migration*` variables to be set first."

  validation {
    condition     = contains(["EXTERNAL", "EXTERNAL_MANAGED", "EXTERNAL_PASSTHROUGH", "INTERNAL_MANAGED", "INTERNAL_SELF_MANAGED"], var.load_balancing_scheme)
    error_message = "load_balancing_scheme must be one of: EXTERNAL, EXTERNAL_MANAGED, EXTERNAL_PASSTHROUGH, INTERNAL_MANAGED, INTERNAL_SELF_MANAGED."
  }
}

variable "external_managed_migration_state" {
  type        = string
  default     = null
  description = "Canary migration state of the backend service when moving a live load balancer from `EXTERNAL` to `EXTERNAL_MANAGED`. One of `PREPARE`, `TEST_BY_PERCENTAGE` or `TEST_ALL_TRAFFIC`. Migrate in order: `PREPARE`, then `TEST_ALL_TRAFFIC`, then set `load_balancing_scheme` to `EXTERNAL_MANAGED` and leave this at `TEST_ALL_TRAFFIC`. Leave null for new load balancers."

  validation {
    condition     = var.external_managed_migration_state == null ? true : contains(["PREPARE", "TEST_BY_PERCENTAGE", "TEST_ALL_TRAFFIC"], var.external_managed_migration_state)
    error_message = "external_managed_migration_state must be null or one of: PREPARE, TEST_BY_PERCENTAGE, TEST_ALL_TRAFFIC."
  }
}

variable "external_managed_migration_testing_percentage" {
  type        = number
  default     = null
  description = "Percentage (0-100) of requests the backend service sends through the `EXTERNAL_MANAGED` stack while `external_managed_migration_state` is `TEST_BY_PERCENTAGE`. Only valid while `load_balancing_scheme` is `EXTERNAL`."

  validation {
    condition     = var.external_managed_migration_testing_percentage == null ? true : (var.external_managed_migration_testing_percentage >= 0 && var.external_managed_migration_testing_percentage <= 100)
    error_message = "external_managed_migration_testing_percentage must be null or between 0 and 100."
  }
}

variable "external_managed_backend_bucket_migration_state" {
  type        = string
  default     = null
  description = "Canary migration state of the backend buckets attached to the global forwarding rules when moving a live load balancer from `EXTERNAL` to `EXTERNAL_MANAGED`. Only needed when `backend_type` is `bucket` or `service_and_bucket`. One of `PREPARE`, `TEST_BY_PERCENTAGE` or `TEST_ALL_TRAFFIC`, migrated in the same order as `external_managed_migration_state`. Leave null for new load balancers."

  validation {
    condition     = var.external_managed_backend_bucket_migration_state == null ? true : contains(["PREPARE", "TEST_BY_PERCENTAGE", "TEST_ALL_TRAFFIC"], var.external_managed_backend_bucket_migration_state)
    error_message = "external_managed_backend_bucket_migration_state must be null or one of: PREPARE, TEST_BY_PERCENTAGE, TEST_ALL_TRAFFIC."
  }
}

variable "external_managed_backend_bucket_migration_testing_percentage" {
  type        = number
  default     = null
  description = "Percentage (0-100) of requests to backend buckets that the global forwarding rules send through the `EXTERNAL_MANAGED` stack while `external_managed_backend_bucket_migration_state` is `TEST_BY_PERCENTAGE`. Only valid while `load_balancing_scheme` is `EXTERNAL`."

  validation {
    condition     = var.external_managed_backend_bucket_migration_testing_percentage == null ? true : (var.external_managed_backend_bucket_migration_testing_percentage >= 0 && var.external_managed_backend_bucket_migration_testing_percentage <= 100)
    error_message = "external_managed_backend_bucket_migration_testing_percentage must be null or between 0 and 100."
  }
}
