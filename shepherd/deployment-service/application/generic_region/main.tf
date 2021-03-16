data "terraform_remote_state" "infra" {
  backend = "local"
  config = {
    path = "shepherd_remote_state/infrastructure.tfstate"
  }
}

module "region_config" {
  source = "./shared_modules/common_files"
}

module "tenancies" {
  source = "./shared_modules/common_files"
}

module "identity" {
  source                        = "./shared_modules/identity"
  canary_tenancy_ocid           = lookup(module.tenancies.canary_test_tenancy_ocid_map, local.execution_target.phase_name, "not_defined")
  tenancy_ocid                  = local.execution_target.tenancy_ocid
  integration_test_tenancy_ocid = lookup(module.tenancies.integ_test_tenancy_ocid_map, local.execution_target.phase_name, "not_defined")
}

locals {
  control_plane_api_application    = data.terraform_remote_state.infra.outputs.control_plane_api_application
  control_plane_worker_application = data.terraform_remote_state.infra.outputs.control_plane_worker_application
  management_plane_api_application = data.terraform_remote_state.infra.outputs.management_plane_api_application
  data_plane_worker_application    = data.terraform_remote_state.infra.outputs.data_plane_worker_application
  app_availability_domains         = data.terraform_remote_state.infra.outputs.availability_domains

  environment                     = lookup(module.region_config.environment_name_map, local.execution_target.phase_name, "beta")
  integration_test_compartment_id = module.identity.integration_test_compartment.id
}

module "odo_deployment_control_plane" {
  source                          = "./modules/odo-deployment-3ad"
  availability_domains            = local.app_availability_domains
  artifact_versions               = local.artifact_versions
  api_artifact_name               = "deployment-service-control-plane-api"
  worker_artifact_name            = "deployment-service-control-plane-worker"
  odo_api_application             = local.control_plane_api_application
  odo_worker_application          = local.control_plane_worker_application
  integration_test_compartment_id = local.integration_test_compartment_id
  execution_target                = local.execution_target.region.public_name
  environment                     = local.environment
}

module "odo_deployment_management_plane" {
  source                          = "./modules/odo-deployment-3ad"
  availability_domains            = local.app_availability_domains
  artifact_versions               = local.artifact_versions
  api_artifact_name               = "deployment-service-management-plane-api"
  worker_artifact_name            = "deployment-service-data-plane-worker"
  odo_api_application             = local.management_plane_api_application
  odo_worker_application          = local.data_plane_worker_application
  integration_test_compartment_id = local.integration_test_compartment_id
  execution_target                = local.execution_target.region.public_name
  environment                     = local.environment
}
