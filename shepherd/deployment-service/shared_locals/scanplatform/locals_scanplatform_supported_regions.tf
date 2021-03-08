locals {
  /*
   * This map is temporary until Scan Platform shepherd provider GA.
   * Before buildout to a new region, if the region is not listed in
   * this map, please check the following page for latest status
   * and update this map accordingly
   * https://confluence.oci.oraclecorp.com/pages/viewpage.action?spaceKey=VS&title=Regional+Transition+Status
   * On Scan Platform shepherd provider GA, that is, when it supports
   * for all regions of all realms, this module must be removed and
   * resource splatform_onboarding in service-network and ob3-jump
   * modules must be updated accordingly at the same time.
   */
  scanplatform_supported_regions_map = {
    "oc1" = [
      "ca-toronto-1",
      "ap-tokyo-1",
      "ap-seoul-1",
      "ap-mumbai-1",
      "eu-zurich-1",
      "ap-sydney-1",
      "sa-saopaulo-1",
      "eu-amsterdam-1",
      "me-jeddah-1",
      "ap-osaka-1",
      "ap-melbourne-1",
      "ca-montreal-1",
      "ap-hyderabad-1",
      "ap-chuncheon-1",
      "us-sanjose-1",
      "me-dubai-1",
      "uk-cardiff-1",
      "sa-santiago-1",
      "eu-frankfurt-1",
      "uk-london-1"
    ]

    "oc2" = []
    "oc3" = []
    "oc4" = []

    "oc5" = [
      "us-tacoma-1"
    ]

    "oc6" = []
    "oc7" = []
    "oc8" = []
  }
}

output "scanplatform_supported_regions" {
  value = lookup(local.scanplatform_supported_regions_map, var.realm, [])
}
