resource "lumberjack" "customer_log" {
  for_each = toset(var.availability_domains)

  ad          = each.key
  compartment = var.worker_compartment_id
  namespace   = "${var.log_namespace_worker}-worker-${var.environment}"
  log_type    = "service_log"
  config {
    log_group_configs {
      log_group = "customer_log"
      enabled   = true
      agent {
        enabled = true
        single_log_rotation_schema {
          directory                = "/logs/${var.log_namespace_worker}-worker"
          current_log_filename     = "customer.log"
          rotated_filename_pattern = "customer.*log.gz"
        }
      }
    }
  }
}