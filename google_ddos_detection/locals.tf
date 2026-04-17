locals {
  name_prefix = "${var.application}-${var.environment}"
  bq_dataset  = "${var.application}_${var.realm}_${var.environment}_fastly_cdn_logs"
  bq_table    = "fastly"
  job_name    = "${local.name_prefix}-ddos-detection"
  sa_run_name = substr("${local.name_prefix}-ddos-run", 0, 28)
  sa_sch_name = substr("${local.name_prefix}-ddos-sch", 0, 28)
}
