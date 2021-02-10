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
    "beta"    = "ocid1.tenancy.oc1..aaaaaaaazcj7jjwnom4hyjvzdxdsyomxbeaao3v7keizrtllhc5g2r35hyca"
    "preprod" = "ocid1.tenancy.oc1..aaaaaaaakiqb4agx7mu4hqu7rtitlmirgsv3z3nth4qasokxnzvqbp2dgoza"
    "oc1"     = "ocid1.tenancy.oc1..aaaaaaaatvulfxx72mqjtzkj75wtgvcvqac6lo7lwll2yvl7rjqwnvicbs7q"
  }
  bellwether_region = "us-ashburn-1"
  // Helper local configs to define release phases.
  release_phase_config = {
    "beta" = {
      "production"   = false
      "realm"        = "oc1"
      "regions"      = ["us-phoenix-1", "us-ashburn-1"]
      "home_region"  = "us-phoenix-1"
      "auto_approve" = true
      "predecessors" = []
    }
    "preprod" = {
      "production"   = false
      "realm"        = "oc1"
      "regions"      = ["us-ashburn-1"]
      "home_region"  = "us-ashburn-1"
      "auto_approve" = false
      "predecessors" = ["beta"]
    }
    "oc1-groupA" = {
      "production"   = true
      "realm"        = "oc1"
      "regions"      = ["us-ashburn-1", "eu-frankfurt-1"]
      "home_region"  = "us-ashburn-1"
      "auto_approve" = false
      "predecessors" = ["preprod"]
    }
    "oc1-groupB" = {
      "production"   = true
      "realm"        = "oc1"
      "regions"      = ["us-phoenix-1", "uk-london-1"]
      "home_region"  = "us-ashburn-1"
      "auto_approve" = false
      "predecessors" = ["oc1-groupA"]
    }
  }
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

  predecessors = []
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

# Execution targets for PROD(Regional)
resource "shepherd_execution_target" "oc1-groupA-region" {
  for_each = toset(local.release_phase_config["oc1-groupA"]["regions"])

  name         = "oc1-groupA-${each.key}-region"
  tenancy_ocid = local.tenancy_ocid_map["oc1"]
  region       = each.key
  phase        = shepherd_release_phase.release_phases["oc1-groupA"].name
  # After the bellwether succeeds, everything happens in parallel
  predecessors = each.key == local.bellwether_region ? [] : ["oc1-groupA-${local.bellwether_region}-region"]
}

resource "shepherd_execution_target" "oc1-groupB-region" {
  for_each = toset(local.release_phase_config["oc1-groupB"]["regions"])

  name         = "oc1-groupB-${each.key}-region"
  tenancy_ocid = local.tenancy_ocid_map["oc1"]
  region       = each.key
  phase        = shepherd_release_phase.release_phases["oc1-groupB"].name

  predecessors = []
}
