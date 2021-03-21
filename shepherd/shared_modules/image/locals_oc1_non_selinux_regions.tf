# https://confluence.oci.oraclecorp.com/display/ICM/Chef+management+of+SELinux
# https://bitbucket.oci.oraclecorp.com/projects/IOGIT/repos/chef-repo/browse/roles/region_ap-chuncheon-1.json
# !! PLEASE DO NOT EDIT THIS LIST

locals {
  oc1_non_selinux_regions = [
    "us-ashburn-1",
    "eu-frankfurt-1",
    "us-phoenix-1",
    "ca-toronto-1",
    "ap-tokyo-1",
    "ap-sydney-1",
    "sa-saopaulo-1",
    "ap-mumbai-1",
    "eu-zurich-1",
    "uk-london-1",
    "ap-seoul-1",
    "eu-amsterdam-1",
    "me-jeddah-1",
    "ap-osaka-1",
    "ap-melbourne-1",
    "ca-montreal-1",
    "ap-hyderabad-1",
    "ap-chuncheon-1"
  ]
}
