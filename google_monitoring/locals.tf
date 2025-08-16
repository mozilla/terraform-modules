locals {
  synthetic_monitors = [
    for fn in var.synthetic_monitors : merge(fn, {
      used_runtime_sa_email = (
        contains(keys(fn), "runtime_service_account_email") && fn.runtime_service_account_email != null && fn.runtime_service_account_email != ""
        ? fn.runtime_service_account_email
        : "${fn.name}-runtime-sa@${var.project_id}.iam.gserviceaccount.com"
      ),
      used_build_sa_email = (
        contains(keys(fn), "build_service_account_email") && fn.build_service_account_email != null && fn.build_service_account_email != ""
        ? fn.build_service_account_email
        : "${fn.name}-build-sa@${var.project_id}.iam.gserviceaccount.com"
      )
    })
  ]

  # Runtime SA creation map (only if email not provided)
  runtime_service_accounts = {
    for fn in local.synthetic_monitors :
    fn.name => {
      name    = "${fn.name}-runtime-sa"
      project = var.project_id
    } if !contains(keys(fn), "runtime_service_account_email") || fn.runtime_service_account_email == null || fn.runtime_service_account_email == ""
  }

  # Build SA creation map (only if email not provided)
  build_service_accounts = {
    for fn in local.synthetic_monitors :
    fn.name => {
      name    = "${fn.name}-build-sa"
      project = var.project_id
    } if !contains(keys(fn), "build_service_account_email") || fn.build_service_account_email == null || fn.build_service_account_email == ""
  }

}