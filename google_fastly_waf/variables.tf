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

variable "stage" {
  description = "Determine if something should be deployed to stage"
  type        = bool
  default     = false
}

## NGWAF
variable "ngwaf_agent_level" {
  type        = string
  default     = "log"
  description = "This is the site wide blocking level"
}

variable "ngwaf_immediate_block" {
  type    = bool
  default = true
}
