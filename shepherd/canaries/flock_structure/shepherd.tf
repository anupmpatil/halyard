/**
 * Top-level shepherd configuration which describes execution phases and targets.
 * Shepherd flock references: https://confluence.oci.oraclecorp.com/pages/viewpage.action?spaceKey=SHEP&title=Shepherd+Flock+and+Provider+Reference
 */

// Source of artifacts that would be deployed to each target.
resource "shepherd_artifacts" "artifacts" {
  artifact {
    name        = "deployment-service-integration-test"
    type        = "docker"
    location    = "deployment-service-integration-test"
    description = "The docker image for deploy-service canaries"
  }
}

module "region_config" {
  source = "./shared_modules/common_files"
}

locals {
  tenancy_ocid_map     = module.region_config.canary_tenancy_ocid_map
  bellwether_region    = "us-ashburn-1"
  release_phase_config = module.region_config.release_phase_config
}

// Create high-level shepherd release phases.
resource "shepherd_release_phase" "release_phases" {
  for_each = local.release_phase_config

  name         = each.key
  realm        = each.value["realm"]
  production   = each.value["production"]
  auto_approve = each.value["auto_approve"]

  predecessors = each.value["predecessors"]
}

// Release targets for each release phase.
###########
# Execution targets for BETA
###########

# Execution targets for BETA(Tenancy)
resource "shepherd_execution_target" "beta" {

  name                      = "beta-us-phoenix-1"
  tenancy_ocid              = local.tenancy_ocid_map["beta"]
  region                    = "us-phoenix-1"
  phase                     = shepherd_release_phase.release_phases["beta"].name
  is_home_region_target     = true
  snowflake_config_location = "generic_tenancy"

  predecessors = []
}

# Execution targets for BETA(Regional)
resource "shepherd_execution_target" "beta-region" {
  for_each = toset(local.release_phase_config["beta"]["regions"])

  name         = "beta-${each.key}-region"
  tenancy_ocid = local.tenancy_ocid_map["beta"]
  region       = each.key
  phase        = shepherd_release_phase.release_phases["beta"].name

  predecessors = []
}

###########
# Execution targets for PREPROD
###########

# Execution targets for PREPROD(Tenancy)
resource "shepherd_execution_target" "preprod" {
  name                      = "preprod-us-ashburn-1"
  tenancy_ocid              = local.tenancy_ocid_map["preprod"]
  region                    = "us-ashburn-1"
  phase                     = shepherd_release_phase.release_phases["preprod"].name
  is_home_region_target     = true
  snowflake_config_location = "generic_tenancy"
  predecessors              = []
}

# Execution targets for PREPROD(Regional)
resource "shepherd_execution_target" "preprod-region" {
  for_each = toset(local.release_phase_config["preprod"]["regions"])

  name         = "preprod-${each.key}-region"
  tenancy_ocid = local.tenancy_ocid_map["preprod"]
  region       = each.key
  phase        = shepherd_release_phase.release_phases["preprod"].name

  predecessors = []
}

###########
# Execution targets for PROD
###########

# Execution targets for PROD(Tenancy)
resource "shepherd_execution_target" "prod-oc1-groupA" {
  name                      = "oc1-groupA-us-ashburn-1"
  tenancy_ocid              = local.tenancy_ocid_map["oc1"]
  region                    = "us-ashburn-1"
  phase                     = shepherd_release_phase.release_phases["oc1-groupA"].name
  is_home_region_target     = true
  snowflake_config_location = "generic_tenancy"
  predecessors              = []
}

# Execution targets for PROD(Regional)
resource "shepherd_execution_target" "prod-oc1-groupA-region" {
  for_each = toset(local.release_phase_config["oc1-groupA"]["regions"])

  name         = "oc1-groupA-${each.key}-region"
  tenancy_ocid = local.tenancy_ocid_map["oc1"]
  region       = each.key
  phase        = shepherd_release_phase.release_phases["oc1-groupA"].name
  # After the bellwether succeeds, everything happens in parallel
  predecessors = each.key == local.bellwether_region ? [] : ["oc1-groupA-${local.bellwether_region}-region"]
}

resource "shepherd_execution_target" "prod-oc1-groupB-region" {
  for_each = toset(local.release_phase_config["oc1-groupB"]["regions"])

  name         = "oc1-groupB-${each.key}-region"
  tenancy_ocid = local.tenancy_ocid_map["oc1"]
  region       = each.key
  phase        = shepherd_release_phase.release_phases["oc1-groupB"].name

  predecessors = []
}
