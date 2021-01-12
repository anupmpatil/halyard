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
}

locals {
  tenancy_ocid_map = {
    "beta"    = "ocid1.tenancy.oc1..aaaaaaaazcj7jjwnom4hyjvzdxdsyomxbeaao3v7keizrtllhc5g2r35hyca"
    "preprod" = "ocid1.tenancy.oc1..aaaaaaaakiqb4agx7mu4hqu7rtitlmirgsv3z3nth4qasokxnzvqbp2dgoza"
    "oc1"     = "ocid1.tenancy.oc1..aaaaaaaatvulfxx72mqjtzkj75wtgvcvqac6lo7lwll2yvl7rjqwnvicbs7q"
  }
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
      "regions"      = ["us-ashburn-1"]
      "home_region"  = "us-ashburn-1"
      "auto_approve" = false
      "predecessors" = ["preprod"]
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