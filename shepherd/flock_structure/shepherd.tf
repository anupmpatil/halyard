/**
 * Top-level shepherd configuration which describes execution phases and targets.
 * Shepherd flock references: https://confluence.oci.oraclecorp.com/pages/viewpage.action?spaceKey=SHEP&title=Shepherd+Flock+and+Provider+Reference
 */

// Source of artifacts that would be deployed to each target.
resource "shepherd_artifacts" "artifacts" {
  artifact {
    name = "deployment-service-api"
    type = "docker"
    location = "deployment-service-api"
    description = "The docker container for deployment-service's api server."
  }
  artifact {
    name = "deployment-service-worker"
    type = "docker"
    location = "deployment-service-worker"
    description = "The docker container for deployment-service's worker."
  }
  artifact {
    name = "odo-system-updater"
    type = "pop"
    location = "odo-system-updater"
    description = "ODO's security updater binaries."
  }
}

locals {
  // Helper local configs to define release phases.
  release_phase_config = {
    "beta" = {
      "production" = false
      "realm" = "oc1"
      "regions" = ["us-phoenix-1"]
      "home_region" = "us-phoenix-1"
      "tenancy_ocid" = "ocid1.tenancy.oc1..aaaaaaaazcj7jjwnom4hyjvzdxdsyomxbeaao3v7keizrtllhc5g2r35hyca"
      "predecessors" = []
    }
    // todo: env variable
    // env - beta, prod,
#    "prod1" = {
#      "production" = true
#      "realm" = "oc1"
#      "regions" = ["uk-london-1"]
#      "home_region" = "us-phoenix-1"
#      "predecessors" = ["beta"]
#    }
#    "prod2" = {
#      "production" = true
#      "realm" = "oc1"
#      "regions" = ["us-ashburn-1"]
#      "home_region" = "us-phoenix-1"
#      "predecessors" = ["prod1"]
#    }
  }
}

// Create high-level shepherd release phases.
resource "shepherd_release_phase" "release_phases" {
  for_each = local.release_phase_config

  name = each.key
  realm = each.value["realm"]
  production = each.value["production"]

  predecessors = each.value["predecessors"]
}

// Release targets for each release phase.
resource "shepherd_execution_target" "beta" {
  for_each = toset(local.release_phase_config["beta"]["regions"])
  name = "beta-${each.key}"
  tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaazcj7jjwnom4hyjvzdxdsyomxbeaao3v7keizrtllhc5g2r35hyca"
  region = each.key
  phase = shepherd_release_phase.release_phases["beta"].name

  is_home_region_target = (each.key == local.release_phase_config["beta"]["home_region"])
  snowflake_config_location = "beta"

  # alarms_to_watch {
  #   compartment_name = "deployment-service"
  #   labels = ["shepherd-monitor"]
  # }

  # Deploy all execution_targets in this release in parallel.
  predecessors = []
}

# resource "shepherd_execution_target" "prod1" {
#   for_each = toset(local.release_phase_config["prod1"]["regions"])

#   name = "prod1-${each.key}"
#   # It's recommended to use a tenancy different from your test environment.
#   tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaa26mceal7cypzsefhbm2l73xtb3yreplacemereplacemereplaceme"
#   region = each.key
#   phase = shepherd_release_phase.release_phases["prod1"].name

#   alarms_to_watch {
#     compartment_name = "deployment-service"
#     labels = ["shepherd-monitor"]
#   }

#   is_home_region_target = (each.key == local.release_phase_config["prod1"]["home_region"])

#   # Deploy all execution_targets in this release in parallel.
#   predecessors = []
# }

# resource "shepherd_execution_target" "prod2" {
#   for_each = toset(local.release_phase_config["prod2"]["regions"])

#   name = "prod2-${each.key}"
#   # It's recommended to use a tenancy different from your test environment.
#   tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaa26mceal7cypzsefhbm2l73xtb3yreplacemereplacemereplaceme"
#   region = each.key
#   phase = shepherd_release_phase.release_phases["prod2"].name

#   alarms_to_watch {
#     compartment_name = "deployment-service"
#     labels = ["shepherd-monitor"]
#   }

#   is_home_region_target = (each.key == local.release_phase_config["prod2"]["home_region"])

#   # Deploy all execution_targets in this release in parallel.
#   predecessors = []
# }
