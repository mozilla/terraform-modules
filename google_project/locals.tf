locals {
  project_name         = var.project_name
  display_name         = coalesce(var.display_name, local.project_name)
  project_generated_id = "${format("%.25s", "moz-fx-${local.project_name}")}-${random_id.project.hex}"
  project_id           = coalesce(var.project_id, local.project_generated_id)

  app_code       = coalesce(var.app_code, var.project_name)
  component_code = coalesce(var.component_code, "${local.app_code}-uncat")

  default_project_labels = {
    app            = var.project_name
    app_code       = local.app_code
    component_code = local.component_code
    cost_center    = var.cost_center
    program_code   = var.program_code
    program_name   = var.program_name
  }
  all_project_labels = merge(local.default_project_labels, var.extra_project_labels)
}
