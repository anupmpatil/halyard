module "region_config" {
  source = "./shared_modules/common_files"
}

locals {
  tenancy_ocid_map     = module.region_config.tenancy_ocid_map
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

resource "shepherd_execution_target" "prod-oc1-groupC-region" {
  for_each = toset(local.release_phase_config["oc1-groupC"]["regions"])

  name         = "oc1-groupC-${each.key}-region"
  tenancy_ocid = local.tenancy_ocid_map["oc1"]
  region       = each.key
  phase        = shepherd_release_phase.release_phases["oc1-groupC"].name

  predecessors = []
}

resource "shepherd_execution_target" "prod-oc1-groupD-region" {
  for_each = toset(local.release_phase_config["oc1-groupD"]["regions"])

  name         = "oc1-groupD-${each.key}-region"
  tenancy_ocid = local.tenancy_ocid_map["oc1"]
  region       = each.key
  phase        = shepherd_release_phase.release_phases["oc1-groupD"].name

  predecessors = []
}
