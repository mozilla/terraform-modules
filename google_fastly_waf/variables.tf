variable "backends" {
  description = "A list of backends"
  type        = list(any)
  default     = []
}

variable "environment" {
  description = "The environment this module is deployed into"
  type        = string
}

variable "realm" {
  description = "The realm this module is deployed into"
  type        = string
}

variable "application" {
  description = "Application name"
  type        = string
}

variable "domains" {
  description = "A list of domains"
  type        = list(any)
  default     = []
}

variable "conditions" {
  description = "List of Fastly conditions to create (REQUEST, RESPONSE or CACHE)."
  type = list(object({
    name      = string           # required, unique
    statement = string           # VCL conditional expression
    type      = string           # one of: REQUEST, RESPONSE, CACHE
    priority  = optional(number) # lower runs first, default 10
  }))
  default = []
}

variable "snippets" {
  description = "snippets"
  type        = list(any)
  default     = []
}

variable "project_id" {
  description = "The GCP project_ id for BigQuery logging"
  type        = string
}

variable "subscription_domains" {
  description = "Domains to issue SSL certificates for"
  type        = list(any)
  default     = []
}

variable "subscription_domains_force_update" {
  default     = false
  description = "Force update the subscription even if it has active domains. Warning: this can disable production traffic if used incorrectly."
  type        = bool
}

variable "response_objects" {
  description = "List of synthetic response objects to attach to the Fastly service."
  type = list(object({
    name              = string           # required
    status            = optional(number) # e.g. 503
    response          = optional(string) # e.g. "Ok"
    content           = optional(string)
    content_type      = optional(string)
    request_condition = optional(string) # name of an existing REQUEST condition
    cache_condition   = optional(string) # name of an existing CACHE   condition
  }))
  default = []
}

variable "cache_settings" {
  description = "List of cache settings for the Fastly service."
  type = list(object({
    name            = string
    action          = optional(string)
    cache_condition = optional(string)
    stale_ttl       = optional(number)
    ttl             = optional(number)
  }))
  default = []
}

variable "stage" {
  description = "Determine if something should be deployed to stage"
  type        = bool
  default     = false
}

variable "service_account" {
  type    = string
  default = null
}

variable "log_sampling_percent" {
  type    = string
  default = "10"
}

variable "log_sampling_enabled" {
  type    = bool
  default = false
}

variable "https_redirect_enabled" {
  type    = bool
  default = true
}

variable "cache_header" {
  type        = string
  default     = ""
  description = "A cache header to check to toggle cache lookup"
}

variable "bot_management" {
  description = "Bot Management configuration for the Fastly service product enablement."
  type = object({
    enabled      = bool
    contentguard = string
  })
  default = null
  validation {
    condition     = var.bot_management == null || contains(["off", "on"], var.bot_management.contentguard)
    error_message = "bot_management.contentguard must be either off or on."
  }
}

variable "ddos_protection" {
  description = "Optional DDoS Protection configuration for the Fastly service product enablement."
  type = object({
    enabled = bool
    mode    = string
  })
  default = null
  validation {
    condition     = var.ddos_protection == null || contains(["off", "log", "block"], var.ddos_protection.mode)
    error_message = "ddos_protection.mode must be one of: off, log, or block."
  }
}

variable "ddos_protection_alert" {
  description = <<-EOT
    Optional Slack alerting for Fastly DDoS Protection. When set, the module
    creates a Slack `fastly_integration` and a `fastly_alert` on the
    `ddos_detected_requests` stats metric that notifies the channel behind the
    webhook. Intended to be paired with `ddos_protection` being enabled.
    Set to `null` (the default) to create no alerting resources.
  EOT
  type = object({
    enabled       = optional(bool, true)   # set false to keep config but tear the alert down
    slack_webhook = string                 # Slack incoming-webhook URL (sensitive)
    threshold     = optional(number, 1)    # ddos_detected_requests count that fires the alert
    period        = optional(string, "5m") # evaluation window: 2m, 3m, 5m, 15m, or 30m
  })
  default = null
  validation {
    condition = var.ddos_protection_alert == null || contains(
      ["2m", "3m", "5m", "15m", "30m"], var.ddos_protection_alert.period
    )
    error_message = "ddos_protection_alert.period must be one of: 2m, 3m, 5m, 15m, or 30m."
  }
}

## NGWAF
variable "legacy_edge_deployment" {
  type        = bool
  default     = true
  description = "If true (default), deploy NGWAF via the legacy sigsci EdgeDeployment APIs and Fastly dynamic snippets. If false, deploy via Fastly's product_enablement ngwaf block. Default preserves behavior for services still on the legacy method."
}

variable "ngwaf_agent_level" {
  type        = string
  default     = "log"
  description = "This is the site wide blocking level"
}

variable "ngwaf_immediate_block" {
  type    = bool
  default = true
}

variable "ngwaf_percent_enabled" {
  type    = number
  default = 100
}

variable "ngwaf_baseline_protection" {
  type        = bool
  default     = false
  description = "When true, disables immediate blocking and enables baseline attack threshold alerts."
}

variable "ngwaf_attack_thresholds" {
  type = list(object({
    interval  = number
    threshold = number
  }))
  # To override the default thresholds, pass a custom list. Example:
  # ngwaf_attack_thresholds = [
  #   { interval = 1,  threshold = 50  },
  #   { interval = 10, threshold = 200 },
  #   { interval = 60, threshold = 1000 },
  # ]
  default = [
    { interval = 1, threshold = 10 },
    { interval = 10, threshold = 100 },
    { interval = 60, threshold = 600 },
  ]
  description = "Attack threshold configurations applied when ngwaf_baseline_protection is enabled."
  validation {
    condition     = length(var.ngwaf_attack_thresholds) == 3
    error_message = "ngwaf_attack_thresholds must contain exactly 3 entries (one each for the 1, 10, and 60 minute intervals)."
  }
}

variable "brotli_compression" {
  type        = bool
  default     = true
  description = "Enable brotli compression or not"
}
