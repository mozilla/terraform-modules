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

variable "load_balancing_scheme" {
  type        = string
  default     = "EXTERNAL"
  description = "Load balancing scheme for the global forwarding rules. One of `EXTERNAL`, `EXTERNAL_MANAGED`, `EXTERNAL_PASSTHROUGH`, `INTERNAL_MANAGED` or `INTERNAL_SELF_MANAGED`. Defaults to `EXTERNAL`, which was the Google provider's default before v8.0. Moving an existing load balancer from `EXTERNAL` to `EXTERNAL_MANAGED` requires the `external_managed_backend_bucket_migration_*` variables to be set first."

  validation {
    condition     = contains(["EXTERNAL", "EXTERNAL_MANAGED", "EXTERNAL_PASSTHROUGH", "INTERNAL_MANAGED", "INTERNAL_SELF_MANAGED"], var.load_balancing_scheme)
    error_message = "load_balancing_scheme must be one of: EXTERNAL, EXTERNAL_MANAGED, EXTERNAL_PASSTHROUGH, INTERNAL_MANAGED, INTERNAL_SELF_MANAGED."
  }
}

variable "external_managed_backend_bucket_migration_state" {
  type        = string
  default     = null
  description = "Canary migration state of the backend bucket behind the global forwarding rules when moving a live load balancer from `EXTERNAL` to `EXTERNAL_MANAGED`. One of `PREPARE`, `TEST_BY_PERCENTAGE` or `TEST_ALL_TRAFFIC`. Migrate in order: `PREPARE`, then `TEST_ALL_TRAFFIC`, then set `load_balancing_scheme` to `EXTERNAL_MANAGED` and leave this at `TEST_ALL_TRAFFIC`. Leave null for new load balancers."

  validation {
    condition     = var.external_managed_backend_bucket_migration_state == null ? true : contains(["PREPARE", "TEST_BY_PERCENTAGE", "TEST_ALL_TRAFFIC"], var.external_managed_backend_bucket_migration_state)
    error_message = "external_managed_backend_bucket_migration_state must be null or one of: PREPARE, TEST_BY_PERCENTAGE, TEST_ALL_TRAFFIC."
  }
}

variable "external_managed_backend_bucket_migration_testing_percentage" {
  type        = number
  default     = null
  description = "Percentage (0-100) of requests to the backend bucket that the global forwarding rules send through the `EXTERNAL_MANAGED` stack while `external_managed_backend_bucket_migration_state` is `TEST_BY_PERCENTAGE`. Only valid while `load_balancing_scheme` is `EXTERNAL`."

  validation {
    condition     = var.external_managed_backend_bucket_migration_testing_percentage == null ? true : (var.external_managed_backend_bucket_migration_testing_percentage >= 0 && var.external_managed_backend_bucket_migration_testing_percentage <= 100)
    error_message = "external_managed_backend_bucket_migration_testing_percentage must be null or between 0 and 100."
  }
}
