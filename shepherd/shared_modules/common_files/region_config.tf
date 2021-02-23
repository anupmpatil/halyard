locals {
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
    # We do ashburn first in group a - it's our bellwether
    # After that, it's pairs of nearby(ish) regions, one in a, one in b
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

output "release_phase_config" {
  value = local.release_phase_config
}
