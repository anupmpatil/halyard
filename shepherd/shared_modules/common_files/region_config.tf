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
      "regions"      = ["us-ashburn-1", "eu-frankfurt-1", "eu-amsterdam-1", "ap-tokyo-1"]
      "home_region"  = "us-ashburn-1"
      "auto_approve" = false
      "predecessors" = ["preprod"]
    }
    "oc1-groupB" = {
      "production"   = true
      "realm"        = "oc1"
      "regions"      = ["us-phoenix-1", "uk-london-1", "ap-seoul-1", "ap-sydney-1", "ca-montreal-1"]
      "home_region"  = "us-ashburn-1"
      "auto_approve" = false
      "predecessors" = ["oc1-groupA"]
    }
    "oc1-groupC" = {
      "production"   = true
      "realm"        = "oc1"
      "regions"      = ["us-sanjose-1", "me-dubai-1", "uk-cardiff-1", "eu-zurich-1", "sa-saopaulo-1", "ap-hyderabad-1"]
      "home_region"  = "us-ashburn-1"
      "auto_approve" = false
      "predecessors" = ["oc1-groupB"]
    }
    "oc1-groupD" = {
      "production"   = true
      "realm"        = "oc1"
      "regions"      = ["ap-melbourne-1", "ap-osaka-1", "me-jeddah-1", "sa-santiago-1", "ca-toronto-1", "ap-mumbai-1", "ap-chuncheon-1"]
      "home_region"  = "us-ashburn-1"
      "auto_approve" = false
      "predecessors" = ["oc1-groupC"]
    }
  }
}

output "release_phase_config" {
  value = local.release_phase_config
}
