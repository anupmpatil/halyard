locals {
  environment_name_map = {
    beta       = "beta"
    preprod    = "preprod"
    oc1-groupA = "prod"
    oc1-groupB = "prod"
  }
  region_short_name_map = {
    phx            = "phx"
    iad            = "iad"
    uk-london-1    = "lhr"
    eu-frankfurt-1 = "fra"
  }
}

output "environment_name_map" {
  value = local.environment_name_map
}

output "region_short_name_map" {
  value = local.region_short_name_map
}
