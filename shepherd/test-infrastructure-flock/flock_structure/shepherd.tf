locals {
  tenancy_ocid_map = {
    "dlctest" = "ocid1.tenancy.oc1..aaaaaaaavhpcp5czywf2djkxv3mcswbdobuvpwk24mbcll72tkuskw7qhw5q"
  }
  // Helper local configs to define release phases.
  release_phase_config = {
    "dlctest" = {
      "production"   = false
      "realm"        = "oc1"
      "regions"      = ["us-phoenix-1"]
      "home_region"  = "us-phoenix-1"
      "predecessors" = []
    }
  }
}

// Create high-level shepherd release phases.
resource "shepherd_release_phase" "release_phases" {
  for_each = local.release_phase_config

  name         = each.key
  realm        = each.value["realm"]
  production   = each.value["production"]
  auto_approve = true

  predecessors = each.value["predecessors"]
}

# Execution targets for BETA(Regional)
resource "shepherd_execution_target" "dlctest-region" {
  for_each = toset(local.release_phase_config["dlctest"]["regions"])

  name                      = "dlctest-${each.key}-region"
  tenancy_ocid              = local.tenancy_ocid_map["dlctest"]
  region                    = each.key
  phase                     = shepherd_release_phase.release_phases["dlctest"].name
  snowflake_config_location = "dlctest"

  predecessors = []
}
