
module "environment_config" {
  source = "./shared_modules/common_files"
}

module "t2_config" {
  source = "./shared_modules/common_files"
}

module "tenancies" {
  source = "./shared_modules/common_files"
}

locals {
  environment                     = lookup(module.environment_config.environment_name_map, local.execution_target.phase_name, "beta")
  splat_compartment_id            = module.identity.splat_compartment.id
  control_plane_api_fleet_name    = "deployment-service-control-plane-api-${local.environment}"
  management_plane_api_fleet_name = "deployment-service-management-plane-api-${local.environment}"
  phonebook_name                  = "dlcdep"
  jump_page_link                  = "https://confluence.oci.oraclecorp.com/display/DLC/Developer+Lifecycle"
  t2_project_name                 = module.t2_config.t2_project_name
}

module "identity" {
  source           = "./shared_modules/identity"
  execution_target = local.execution_target
}

module "dnsdomain" {
  source      = "./shared_modules/dns_domain"
  environment = local.environment
  realm       = local.execution_target.region.realm
}

locals {
  tenancy_lookup_key = local.environment == "prod" ? local.execution_target.region.realm : local.environment
  tenancy_name       = module.tenancies.tenancy_name_map[local.tenancy_lookup_key]

  splat_fleet = local.environment == "prod" ? "overlay-fleet" : "overlay-dev-fleet"

  //https://confluence.oci.oraclecorp.com/pages/viewpage.action?spaceKey=PLAT&title=2.+Splat+Onboarding
  splat_host_headers = local.environment == "prod" ? (
    ["cloud-deploy.{OCI-PUB-DOMAIN-NAME}"]
    ) : (

    local.environment == "preprod" ? (
      ["cloud-deploy-preprod.{REGION}.${module.dnsdomain.deployment_service_internal_endpoint_domain}"]
      ) : (

      ["cloud-deploy.{REGION}.${module.dnsdomain.deployment_service_internal_endpoint_domain}",
      "deployment.{REGION}.${module.dnsdomain.deployment_service_internal_endpoint_domain}"]
  ))

  splat_service_name_suffix = local.environment == "prod" ? "" : "-${local.environment}"

  spec_release_dir = local.environment == "prod" || local.environment == "preprod" ? "release" : "internal"
  api_yaml         = file(format("%s/%s", path.module, "api-specs/${local.spec_release_dir}/api.yaml"))

}

module "splat_control_plane" {
  source         = "./modules/splat"
  service_name   = "deployment-service-control-plane-api${local.splat_service_name_suffix}"
  realm          = local.execution_target.region.realm
  compartment_id = local.splat_compartment_id
  splat_fleet    = local.splat_fleet

  api_yaml = local.api_yaml

  tenancy_name              = local.tenancy_name
  phone_book_id             = local.phonebook_name
  lumberjack_namespace      = "_${local.control_plane_api_fleet_name}"
  jump_page_link            = local.jump_page_link
  telemetry_project         = local.t2_project_name
  telemetry_fleet           = "deployment-service-control-plane-api"
  telemetry_key_alarm_names = []
  grafana_dashboard_names   = ["deployment-service-host-metrics-${local.environment}"]

  endpoint            = "https://${local.environment}.control.plane.api.clouddeploy.{OCI-IAAS-DOMAIN-NAME}"
  host_headers        = local.splat_host_headers
  read_timeout_millis = 30000

  rollout_duration_in_seconds = 300
}

module "splat_data_plane" {
  source         = "./modules/splat"
  service_name   = "deployment-service-management-plane-api${local.splat_service_name_suffix}"
  realm          = local.execution_target.region.realm
  compartment_id = local.splat_compartment_id
  splat_fleet    = local.splat_fleet

  api_yaml = local.api_yaml

  tenancy_name              = local.tenancy_name
  phone_book_id             = local.phonebook_name
  lumberjack_namespace      = "_${local.management_plane_api_fleet_name}"
  jump_page_link            = local.jump_page_link
  telemetry_project         = local.t2_project_name
  telemetry_fleet           = "deployment-service-management-plane-api"
  telemetry_key_alarm_names = []
  grafana_dashboard_names   = ["deployment-service-host-metrics-${local.environment}"]

  endpoint            = "https://${local.environment}.management.plane.api.clouddeploy.{OCI-IAAS-DOMAIN-NAME}"
  host_headers        = local.splat_host_headers
  read_timeout_millis = 30000

  rollout_duration_in_seconds = 300
}

