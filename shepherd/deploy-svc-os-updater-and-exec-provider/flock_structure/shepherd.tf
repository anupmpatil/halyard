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

locals {
  tenancy_ocid_map = {
    "beta" = "ocid1.tenancy.oc1..aaaaaaaazcj7jjwnom4hyjvzdxdsyomxbeaao3v7keizrtllhc5g2r35hyca"
    //    "oc1" = ""
    //    "oc2" = ""
    //    "oc3" = ""
    //    "oc4" = ""
    //    "oc5" = ""
  }
  // Helper local configs to define release phases.
  release_phase_config = {
    "beta" = {
      "production"   = false
      "realm"        = "oc1"
      "regions"      = ["us-phoenix-1", "us-ashburn-1"]
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
resource "shepherd_execution_target" "beta-region" {
  for_each = toset(local.release_phase_config["beta"]["regions"])

  name         = "beta-${each.key}-region"
  tenancy_ocid = local.tenancy_ocid_map["beta"]
  region       = each.key
  phase        = shepherd_release_phase.release_phases["beta"].name

  predecessors = []
}
