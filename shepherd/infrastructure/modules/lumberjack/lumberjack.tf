resource "lumberjack" "lumberjack_api" {
  for_each = toset(var.availability_domains)

  ad          = each.key
  compartment = var.api_compartment_id
  namespace   = "${var.log_namespace_api}-api-${var.environment}"
  log_type    = "standard"
  config {
    log_group_configs {
      log_group = "application_log"
      enabled   = true
      agent {
        enabled = true
        single_log_rotation_schema {
          directory                = "/logs/${var.log_namespace_api}-api"
          current_log_filename     = "application.log"
          rotated_filename_pattern = "application.*log.gz"
        }
      }
    }
    log_group_configs {
      log_group = "requests_log"
      enabled   = true
      agent {
        enabled = true
        single_log_rotation_schema {
          directory                = "/logs/${var.log_namespace_api}-api"
          current_log_filename     = "requests.log"
          rotated_filename_pattern = "requests.*log.gz"
        }
      }
    }
  }
}

resource "lumberjack" "lumberjack_worker" {
  for_each = toset(var.availability_domains)

  ad          = each.key
  compartment = var.worker_compartment_id
  namespace   = "${var.log_namespace_worker}-worker-${var.environment}"
  log_type    = "standard"
  config {
    log_group_configs {
      log_group = "application_log"
      enabled   = true
      agent {
        enabled = true
        single_log_rotation_schema {
          directory                = "/logs/${var.log_namespace_worker}-worker"
          current_log_filename     = "application.log"
          rotated_filename_pattern = "application.*log.gz"
        }
      }
    }
    log_group_configs {
      log_group = "requests_log"
      enabled   = true
      agent {
        enabled = true
        single_log_rotation_schema {
          directory                = "/logs/${var.log_namespace_worker}-worker"
          current_log_filename     = "requests.log"
          rotated_filename_pattern = "requests.*log.gz"
        }
      }
    }
  }
}
