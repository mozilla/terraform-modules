variable "ids" {
  type        = set(string)
  description = "List of workgroup identifiers to look up access for"

  validation {
    condition     = alltrue([for i in var.ids : length(regexall("^workgroup:[a-zA-Z0-9-]+(/[a-zA-Z0-9\\.-]+)?$|^subgroup:[a-zA-Z0-9\\.-]+$", i)) > 0])
    error_message = "Bad workgroup identifier format, must match workgroup:WORKGROUP[/SUBGROUP] or subgroup:SUBGROUP."
  }
}
