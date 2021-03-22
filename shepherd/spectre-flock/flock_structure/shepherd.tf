module "common" {
  source = "./shared_modules/common_files"
}

locals {
  tenancy_ocid_map = module.common.tenancy_ocid_map
}

resource "shepherd_release_phase" "oc1" {
  name         = "oc1"
  realm        = "oc1"
  production   = true
  auto_approve = false

  predecessors = []
}

/*****************
 * EXECUTION TARGETS
 **********************************/

/********
 * OC1
 **************/
resource "shepherd_execution_target" "oc1" {
  name         = "oc1"
  tenancy_ocid = module.common.tenancy_ocid_map["oc1"]
  region       = "us-phoenix-1"
  phase        = shepherd_release_phase.oc1.name

  uniquifier                = "setup"
  snowflake_config_location = "generic_realm"

  predecessors = []
}