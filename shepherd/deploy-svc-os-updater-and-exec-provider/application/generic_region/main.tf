# Os-updater deployments
# We can deploy to these using their aliases, which are defined in the main flock.

data "oci_identity_availability_domains" "service_ads" {
  compartment_id = local.execution_target.tenancy_ocid
}

locals {
  environment_name_map = {
    beta       = "beta"
    preprod    = "preprod"
    oc1-groupA = "prod"
    oc1-groupB = "prod"
  }
  et          = local.execution_target
  ad          = [for ad in local.availability_domains : ad.name]
  environment = lookup(local.environment_name_map, local.execution_target.phase_name, "beta")

  # Combined map:
  aliases = {
    management_plane = "deployment-service-management-plane-os-updater-${local.environment}"
    control_plane    = "deployment-service-control-plane-os-updater-${local.environment}"
    bastion          = "deployment-service-bastion-os-updater-${local.environment}"
  }
}

module "deployment_service_integration_tests" {
  source               = "./modules/exec-provider-integration-tests"
  availability_domains = local.ad
  artifact_versions    = local.artifact_versions
  compartment_id       = local.execution_target.tenancy_ocid
  artifact_name        = "deployment-service-integration-test"
}

module "deployment_service_os_updater" {
  source                = "./modules/os-updater"
  availability_domains  = local.ad
  artifact_versions     = local.artifact_versions
  artifact_name         = "odo-system-updater"
  odo_app_alias_mp      = local.aliases.management_plane
  odo_app_alias_cp      = local.aliases.control_plane
  odo_app_alias_bastion = local.aliases.bastion
}