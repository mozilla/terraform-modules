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
  description = "Conditions"
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
