locals {
  project_name         = "${var.project_name}-${var.realm}"
  display_name         = coalesce(var.display_name, local.project_name)
  project_generated_id = "${format("%.25s", "moz-fx-${local.project_name}")}-${random_id.project.hex}"
  project_id           = coalesce(var.project_id, local.project_generated_id)

  app_code       = coalesce(var.app_code, var.project_name)
  component_code = coalesce(var.component_code, "${local.app_code}-uncat")

  # Helper locals for truncation of risk profile lists to 63 characters
  regulatory_standards_joined = join(",", var.risk_profile.regulatory_standards)
  sensitive_data_types_joined = join(",", var.risk_profile.sensitive_data_types)

  normalized_risk_profile = {
    has_authentication    = upper(var.risk_profile.has_authentication)
    has_exposed_api       = upper(var.risk_profile.has_exposed_api)
    is_actively_developed = upper(var.risk_profile.is_actively_developed)
    is_customer_facing    = upper(var.risk_profile.is_customer_facing)
    is_internet_facing    = upper(var.risk_profile.is_internet_facing)
    is_regulated          = upper(var.risk_profile.is_regulated)
    stores_data           = upper(var.risk_profile.stores_data)
    regulatory_standards  = length(local.regulatory_standards_joined) > 63 ? substr(local.regulatory_standards_joined, 0, 63) : local.regulatory_standards_joined
    sensitive_data_types  = length(local.sensitive_data_types_joined) > 63 ? substr(local.sensitive_data_types_joined, 0, 63) : local.sensitive_data_types_joined
  }

  default_project_labels = {
    app            = var.project_name
    app_code       = local.app_code
    component_code = local.component_code
    cost_center    = var.cost_center
    program_code   = var.program_code
    program_name   = var.program_name
    realm          = var.realm
    risk_level     = var.risk_level
  }
  all_project_labels = merge(local.default_project_labels, var.extra_project_labels, local.normalized_risk_profile)

  default_project_services = [
    "cloudasset.googleapis.com",
    "cloudbilling.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "dns.googleapis.com",
    "iamcredentials.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "servicehealth.googleapis.com",
    "servicenetworking.googleapis.com",
    "stackdriver.googleapis.com",
    "privilegedaccessmanager.googleapis.com"
  ]
  all_project_services = setunion(local.default_project_services, var.project_services)

  default_data_access_logs = ["iam.googleapis.com", "secretmanager.googleapis.com", "sts.googleapis.com", "privilegedaccessmanager.googleapis.com"]
  data_access_logs_filter  = join("\n", toset([for v in concat(local.default_data_access_logs, var.additional_data_access_logs) : "AND NOT protoPayload.serviceName=\"${v}\""]))
}

# we want to emit a warning when we truncate the lists in the risk profile
check "risk_profile_truncation" {
  assert {
    condition = length(local.regulatory_standards_joined) <= 63
    error_message = "Warning: regulatory_standards list '${local.regulatory_standards_joined}' exceeds 63 characters and will be truncated to '${substr(local.regulatory_standards_joined, 0, 63)}'"
  }
}

check "sensitive_data_truncation" {
  assert {
    condition = length(local.sensitive_data_types_joined) <= 63
    error_message = "Warning: sensitive_data_types list '${local.sensitive_data_types_joined}' exceeds 63 characters and will be truncated to '${substr(local.sensitive_data_types_joined, 0, 63)}'"
  }
}