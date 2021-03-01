module "static_configs" {
  source = "./modules/static_configs"
}

module "region_config" {
  source = "./shared_modules/common_files"
}

locals {
  environment                  = lookup(module.region_config.environment_name_map, local.execution_target.phase_name, "beta")
  service_availability_domains = [for ad in local.availability_domains : ad.name]
  canaries_list                = module.static_configs.canaries_list
  canary_frequency_map         = module.static_configs.canary_frequency_map
  canary_maxruntime_map        = module.static_configs.canary_maxruntime_map
  canaries_test_method_map     = module.static_configs.canaries_test_method_map
  canaries_compartment_id      = lookup(module.static_configs.canaries_compartment_id_map, local.environment, "")
}

module "canary" {
  source                   = "./modules/canary"
  environment              = local.environment
  t2_project_name          = "DLC-DeploymentService"
  availability_domains     = local.service_availability_domains
  canaries_list            = local.canaries_list
  canary_frequency_map     = local.canary_frequency_map
  canary_maxruntime_map    = local.canary_maxruntime_map
  canaries_test_method_map = local.canaries_test_method_map
  artifact_versions        = local.artifact_versions
  canaries_compartment_id  = local.canaries_compartment_id
}


