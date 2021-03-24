resource "shepherd_artifacts" "artifacts" {
  artifact {
    name        = "odo-system-updater"
    type        = "pop"
    location    = "odo-system-updater"
    description = "ODO's security updater binaries."
  }
  artifact {
    name        = "deployment-service-integration-test"
    type        = "docker"
    location    = "deployment-service-integration-test"
    description = "The docker container for deployment-service's integration tests."
  }
}

module "region_config" {
  source = "./shared_modules/common_files"
}

locals {
  tenancy_ocid_map  = module.region_config.tenancy_ocid_map
  bellwether_region = "us-ashburn-1"
  // Helper local configs to define release phases.
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

# Execution targets for BETA(Regional)
resource "shepherd_execution_target" "beta-region" {
  for_each = toset(local.release_phase_config["beta"]["regions"])

  name         = "beta-${each.key}-region"
  tenancy_ocid = local.tenancy_ocid_map["beta"]
  region       = each.key
  phase        = shepherd_release_phase.release_phases["beta"].name
  additional_locals = {
    environment = "beta"
  }


  predecessors = []
}

# Execution targets for PREPROD(Regional)
resource "shepherd_execution_target" "preprod-region" {
  for_each = toset(local.release_phase_config["preprod"]["regions"])

  name         = "preprod-${each.key}-region"
  tenancy_ocid = local.tenancy_ocid_map["preprod"]
  region       = each.key
  phase        = shepherd_release_phase.release_phases["preprod"].name
  additional_locals = {
    environment = "preprod"
  }

  predecessors = []
}

# Execution targets for PROD(Regional)
resource "shepherd_execution_target" "oc1-groupA-region" {
  for_each = toset(local.release_phase_config["oc1-groupA"]["regions"])

  name         = "oc1-groupA-${each.key}-region"
  tenancy_ocid = local.tenancy_ocid_map["oc1"]
  region       = each.key
  phase        = shepherd_release_phase.release_phases["oc1-groupA"].name
  additional_locals = {
    environment = "prod"
  }
  # After the bellwether succeeds, everything happens in parallel
  predecessors = each.key == local.bellwether_region ? [] : ["oc1-groupA-${local.bellwether_region}-region"]
}

resource "shepherd_execution_target" "oc1-groupB-region" {
  for_each = toset(local.release_phase_config["oc1-groupB"]["regions"])

  name         = "oc1-groupB-${each.key}-region"
  tenancy_ocid = local.tenancy_ocid_map["oc1"]
  region       = each.key
  phase        = shepherd_release_phase.release_phases["oc1-groupB"].name
  additional_locals = {
    environment = "prod"
  }

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