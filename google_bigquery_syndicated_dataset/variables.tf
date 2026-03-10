variable "dataset_id" {
  type        = string
  description = "A unique ID for this dataset, without the project name."
}

variable "create_dataset" {
  type        = bool
  description = "Whether to create the BigQuery dataset. Set to false to only manage syndication access on an existing dataset."
  default     = true
}

variable "location" {
  type        = string
  description = "The geographic location where the dataset should reside."
  default     = "US"
}

variable "friendly_name" {
  type        = string
  description = "A descriptive name for the dataset."
  default     = null
}

variable "description" {
  type        = string
  description = "A user-friendly description of the dataset."
  default     = null
}

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the dataset."
  default     = {}
}

variable "default_table_expiration_ms" {
  type        = number
  description = "The default lifetime of all tables in the dataset, in milliseconds."
  default     = null
}

variable "default_partition_expiration_ms" {
  type        = number
  description = "The default partition expiration for all partitioned tables, in milliseconds."
  default     = null
}

variable "max_time_travel_hours" {
  type        = number
  description = "Defines the time travel window in hours."
  default     = null
}

variable "delete_contents_on_destroy" {
  type        = bool
  description = "If true, delete all tables in the dataset when destroying the resource."
  default     = false
}

variable "access" {
  type = set(object({
    role           = optional(string)
    user_by_email  = optional(string)
    group_by_email = optional(string)
    special_group  = optional(string)
    domain         = optional(string)
    iam_member     = optional(string)
    dataset = optional(object({
      dataset = object({
        project_id = string
        dataset_id = string
      })
      target_types = list(string)
    }))
    view = optional(object({
      project_id = string
      dataset_id = string
      table_id   = string
    }))
  }))
  description = "Application-specific access blocks for this dataset. projectOwners OWNER access is included by default unless disable_project_owners_access is set."
  default     = []
}

variable "disable_project_owners_access" {
  type        = bool
  description = "Disable the implied projectOwners OWNER access on this dataset. This should almost never be set."
  default     = false
}

variable "realm" {
  type        = string
  description = "Source infrastructure realm."

  validation {
    condition     = contains(["prod", "nonprod"], var.realm)
    error_message = "Realm must be 'prod' or 'nonprod'."
  }
}

variable "target_realm" {
  type        = string
  description = "Target realm for syndication. Defaults to realm. Set override, e.g. nonprod source syndicating to prod targets."
  default     = null

  validation {
    condition     = var.target_realm == null || contains(["prod", "nonprod"], var.target_realm)
    error_message = "Target realm must be 'prod' or 'nonprod'."
  }
}

# FIXME once https://mozilla-hub.atlassian.net/browse/SVCSE-4252 is complete
# full bqetl metadata should be available to IaC and should be preferred to
# explicitly specifying the data-platform side dataset
variable "syndicated_dataset_id" {
  type        = string
  description = "Name of the dataset in target projects. Defaults to dataset_id. If name ends in '_syndicate', only data-shared is targeted (no mozdata)."
  default     = null
}

variable "syndication_workgroup_ids" {
  type        = list(string)
  description = "Workgroup identifiers for service accounts that perform syndication."
  # https://mozilla-hub.atlassian.net/browse/SVCSE-3005 - migrating from
  # Jenkins to Airflow for syndication. Once complete, update this default.
  default = ["workgroup:dataplatform/jenkins"]
}
