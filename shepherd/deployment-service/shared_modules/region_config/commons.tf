locals {
  environment_name_map = {
    beta       = "beta"
    preprod    = "preprod"
    oc1-groupA = "prod"
  }
}

output "environment_name_map" {
  value = local.environment_name_map
}
