locals {
  cp_wfaas_name_map = {
    "beta"    = "dlcdep-dev-cp"
    "preprod" = "dlcdep-preprod-cp"
    "prod"    = "dlcdep-prod-cp"
  }

  dp_wfaas_name_map = {
    "beta"    = "dlcdep-dev-dp"
    "preprod" = "dlcdep-preprod-dp"
    "prod"    = "dlcdep-prod-dp"
  }
}

output "cp_wfaas_name" {
  value = local.cp_wfaas_name_map[var.environment]
}

output "dp_wfaas_name" {
  value = local.dp_wfaas_name_map[var.environment]
}
