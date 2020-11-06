/**
 * Top-level shepherd configuration which describes execution phases and targets.
 * Shepherd flock references: https://confluence.oci.oraclecorp.com/pages/viewpage.action?spaceKey=SHEP&title=Shepherd+Flock+and+Provider+Reference
 */

// Source of artifacts that would be deployed to each target.
resource "shepherd_artifacts" "artifacts" {
  artifact {
    name        = "deployment-service-management-plane-api"
    type        = "docker"
    location    = "deployment-service-management-plane-api"
    description = "The docker container for deployment-service's management plane api server."
  }
  artifact {
    name        = "deployment-service-data-plane-worker"
    type        = "docker"
    location    = "deployment-service-data-plane-worker"
    description = "The docker container for deployment-service's data plane worker."
  }
  artifact {
    name        = "deployment-service-control-plane-api"
    type        = "docker"
    location    = "deployment-service-control-plane-api"
    description = "The docker container for deployment-service's control plane api server."
  }
  artifact {
    name        = "deployment-service-control-plane-worker"
    type        = "docker"
    location    = "deployment-service-control-plane-worker"
    description = "The docker container for deployment-service's control plane worker."
  }
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

    // todo: env variable
    // env - beta, prod
    //    "oc1-groupA" = {
    //      "production" = true
    //      "realm" = "oc1"
    //      "regions" = ["us-ashburn-1", "ap-seoul-1", "ap-hyderabad-1", "ap-melbourne-1", "eu-zurich-1", "sa-saopaulo-1"]
    //      "home_region" = ""
    //      "predecessors" = ["beta"]
    //    }
    //    "oc1-groupB" = {
    //      "production" = true
    //      "realm" = "oc1"
    //      "regions" = ["uk-london-1", "ap-osaka-1", "ap-mumbai-1", "eu-amsterdam-1", "us-phoenix-1"]
    //      "home_region" = ""
    //      "predecessors" = ["oc1-groupA"]
    //    }
    //    "oc1-groupC" = {
    //      "production" = true
    //      "realm" = "oc1"
    //      "regions" = ["ca-toronto-1", "ap-tokyo-1", "ap-sydney-1", "eu-frankfurt-1", "me-jeddah-1", "ca-montreal-1", "ap-chuncheon-1"]
    //      "home_region" = ""
    //      "predecessors" = ["oc1-groupB"]
    //    }
    //    "oc2-prod" = {
    //      "production" = true
    //      "realm" = "oc2"
    //      "regions" = ["us-langley-1", "us-luke-1"]
    //      "home_region" = ""
    //      "predecessors" = ["oc1-groupC"]
    //    }
    //    "oc3-prod" = {
    //      "production" = true
    //      "realm" = "oc3"
    //      "regions" = ["us-gov-ashburn-1", "us-gov-chicago-1", "us-gov-phoenix-1"]
    //      "home_region" = ""
    //      "predecessors" = ["oc2-prod"]
    //    }
    //    "oc4-prod" = {
    //      "production" = true
    //      "realm" = "oc4"
    //      "regions" = ["uk-gov-london-1"]
    //      "home_region" = ""
    //      "predecessors" = ["oc3-prod"]
    //    }
    //    "oc5-prod" = {
    //      "production" = true
    //      "realm" = "oc5"
    //      "regions" = ["us-tacoma-1"]
    //      "home_region" = ""
    //      "predecessors" = ["oc4-prod"]
    //    }
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

// Release targets for each release phase.
###########
# Execution targets for BETA
###########

# Execution targets for BETA(Tenancy)
resource "shepherd_execution_target" "beta" {
  //for_each = toset(local.release_phase_config["beta"]["regions"])

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

// resource "shepherd_execution_target" "oc1-groupA" {
//   for_each = toset(local.release_phase_config["oc1-groupA"]["regions"])

//   name = "oc1-groupA-${each.key}"
//   tenancy_ocid = local.tenancy_ocid_map["oc1"]
//   region = each.key
//   phase = shepherd_release_phase.release_phases["oc1-groupA"].name
//   is_home_region_target = (each.key == local.release_phase_config["oc1-groupA"]["home_region"])
//   snowflake_config_location = "oc1-prod"

//   predecessors = []
// }

// resource "shepherd_execution_target" "oc1-groupB" {
//   for_each = toset(local.release_phase_config["oc1-groupB"]["regions"])
//
//   name = "oc1-groupB-${each.key}"
//   tenancy_ocid = local.tenancy_ocid_map["oc1"]
//   region = each.key
//   phase = shepherd_release_phase.release_phases["oc1-groupB"].name
//   is_home_region_target = (each.key == local.release_phase_config["oc1-groupB"]["home_region"])
//   snowflake_config_location = "oc1-prod"

//   predecessors = []
// }

// resource "shepherd_execution_target" "oc1-groupC" {
//   for_each = toset(local.release_phase_config["oc1-groupC"]["regions"])
//
//   name = "oc1-groupC-${each.key}"
//   tenancy_ocid = local.tenancy_ocid_map["oc1"]
//   region = each.key
//   phase = shepherd_release_phase.release_phases["oc1-groupC"].name
//   is_home_region_target = (each.key == local.release_phase_config["oc1-groupC"]["home_region"])
//   snowflake_config_location = "oc1-prod"

//   predecessors = []
// }

// resource "shepherd_execution_target" "oc2-prod" {
//   for_each = toset(local.release_phase_config["oc2-prod"]["regions"])
//
//   name = "oc2-prod-${each.key}"
//   tenancy_ocid = local.tenancy_ocid_map["oc2"]
//   region = each.key
//   phase = shepherd_release_phase.release_phases["oc2-prod"].name
//   is_home_region_target = (each.key == local.release_phase_config["oc2-prod"]["home_region"])
//   snowflake_config_location = "oc2-prod"

//   predecessors = []
// }

// resource "shepherd_execution_target" "oc3-prod" {
//   for_each = toset(local.release_phase_config["oc3-prod"]["regions"])
//
//   name = "oc3-prod-${each.key}"
//   tenancy_ocid = local.tenancy_ocid_map["oc3"]
//   region = each.key
//   phase = shepherd_release_phase.release_phases["oc3-prod"].name
//   is_home_region_target = (each.key == local.release_phase_config["oc3-prod"]["home_region"])
//   snowflake_config_location = "oc3-prod"
//
//   predecessors = []
// }

// resource "shepherd_execution_target" "oc4-prod" {
//   for_each = toset(local.release_phase_config["oc4-prod"]["regions"])
//
//   name = "oc4-prod-${each.key}"
//   tenancy_ocid = local.tenancy_ocid_map["oc4"]
//   region = each.key
//   phase = shepherd_release_phase.release_phases["oc4-prod"].name
//   is_home_region_target = (each.key == local.release_phase_config["oc4-prod"]["home_region"])
//   snowflake_config_location = "oc4-prod"
//
//   predecessors = []
// }

// resource "shepherd_execution_target" "oc5-prod" {
//   for_each = toset(local.release_phase_config["oc5-prod"]["regions"])
//
//   name = "oc5-prod-${each.key}"
//   tenancy_ocid = local.tenancy_ocid_map["oc5"]
//   region = each.key
//   phase = shepherd_release_phase.release_phases["oc5-prod"].name
//   is_home_region_target = (each.key == local.release_phase_config["oc5-prod"]["home_region"])
//   snowflake_config_location = "oc5-prod"
//
//   predecessors = []
// }

