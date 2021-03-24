locals {
  environment_name_map = {
    beta       = "beta"
    preprod    = "preprod"
    oc1-groupA = "prod"
    oc1-groupB = "prod"
    oc1-groupC = "prod"
    oc1-groupD = "prod"
  }
  region_short_name_map = {
    phx            = "phx"
    iad            = "iad"
    uk-london-1    = "lhr"
    eu-frankfurt-1 = "fra"
    ap-seoul-1     = "icn"
    ap-tokyo-1     = "nrt"
    eu-amsterdam-1 = "ams"
    ap-sydney-1    = "syd"
    ca-montreal-1  = "yul"
    us-sanjose-1   = "sjc"
    me-dubai-1     = "dxb"
    uk-cardiff-1   = "cwl"
    eu-zurich-1    = "zrh"
    sa-saopaulo-1  = "gru"
    ap-hyderabad-1 = "hyd"
    ap-melbourne-1 = "mel"
    ap-osaka-1     = "kix"
    me-jeddah-1    = "jed"
    sa-santiago-1  = "scl"
    ca-toronto-1   = "yyz"
    ap-mumbai-1    = "bom"
    ap-chuncheon-1 = "yny"
  }
}

output "environment_name_map" {
  value = local.environment_name_map
}

output "region_short_name_map" {
  value = local.region_short_name_map
}
