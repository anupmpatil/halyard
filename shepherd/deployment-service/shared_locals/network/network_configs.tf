locals {
  oci_host_classes_prod_map = {
    dep-service-cp-api    = "DEPLOYMENT-SERVICE-CP-API"
    dep-service-mgt-api   = "DEPLOYMENT-SERVICE-MGT-API"
    dep-service-cp-worker = "DEPLOYMENT-SERVICE-CP-WORKER"
    dep-service-dp-worker = "DEPLOYMENT-SERVICE-DP-WORKER"
    dep-service-bastion   = "deployment-service-bastions"
  }

  oci_host_classes_dev_map = {
    dep-service-cp-api    = "DEPLOYMENT-SERVICE-CP-API-DEV"
    dep-service-mgt-api   = "DEPLOYMENT-SERVICE-MGT-API-DEV"
    dep-service-cp-worker = "DEPLOYMENT-SERVICE-CP-WRKR-DEV"
    dep-service-dp-worker = "DEPLOYMENT-SERVICE-DP-WRKR-DEV"
    dep-service-bastion   = "deployment-service-bastions-dev"
  }

  ob3_jump_vcn_cidrs_map = {
    beta_phx       = "172.16.105.224/29"
    beta_iad       = "192.168.176.248/29"
    preprod_iad    = "172.16.224.144/29"
    oc1-groupA_iad = "192.168.125.232/29"
    oc1-groupB_phx = "172.16.119.104/29"
    oc1-groupB_lhr = "192.168.46.192/29"
    oc1-groupA_fra = "192.168.127.176/29"
    oc1-groupB_icn = "192.168.87.120/29"
    oc1-groupA_ams = "192.168.246.80/29"
    oc1-groupA_nrt = "172.16.147.184/29"
  }

  ob3_bastion_cidrs_map = {
    beta_phx       = "192.168.1.128/26"
    beta_iad       = "172.16.4.128/26"
    preprod_iad    = "192.168.4.192/26"
    oc1-groupA_iad = "172.16.104.64/26"
    oc1-groupB_phx = "192.168.101.192/26"
    oc1-groupB_lhr = "172.16.103.192/26"
    oc1-groupA_fra = "172.16.102.0/26"
    oc1-groupB_icn = "172.16.111.192/26"
    oc1-groupA_ams = "172.16.118.128/26"
    oc1-groupA_nrt = "192.168.10.0/26"
  }

  ob3_bastion_lpg_requestor_tenancy_ocid_map = {
    region1 = "ocid1.tenancy.region1..aaaaaaaafgdhlkfcrmg25ipww7u4jyi5sxbh7qqnmmx7w2n7oeiikmqtfsya"
    oc1     = "ocid1.tenancy.oc1..aaaaaaaa53y25ignaxvfgpj47yjj44wl75vce2dxhgwjq3tg6ncj7ojv2qoa"
    oc2     = "ocid1.tenancy.oc2..aaaaaaaa4iv3rpf2wni3cmdlpgb4mm7e4mh2vgwlhpirapgv3vwuaps6wxea"
    oc3     = "ocid1.tenancy.oc3..aaaaaaaalbmf7qkokzepha675bi5xpev27oll3b56ysoajahext7ea6pikaq"
    oc4     = "ocid1.tenancy.oc4..aaaaaaaacvqrdaphh6obnfjoucfucshuulj2lovwclbhrzlkndijic7kmx2q"
    oc5     = "ocid1.tenancy.oc5..aaaaaaaalonef6cc7m35j4wine7wtaqdvihbw5tnns3zuliggupd3v2qklhq"
    oc6     = "ocid1.tenancy.oc6..aaaaaaaalonef6cc7m35j4wine7wtaqdvihbw5tnns3zuliggupd3v2qklhq"
    oc7     = "ocid1.tenancy.oc7..aaaaaaaalonef6cc7m35j4wine7wtaqdvihbw5tnns3zuliggupd3v2qklhq"
  }

  ob3_bastion_lpg_requestor_group_ocid_map = {
    region1 = "ocid1.group.region1..aaaaaaaauiuchlbypmokdky5sweex5ybtxwx4j3std7uvyghuutfax3ynpyq"
    oc1     = "ocid1.group.oc1..aaaaaaaafmh6xfprwmfpffk3a4y4bhi5hyp42ugqrgxffcc6ae5tyiajvkaa"
    oc2     = "ocid1.group.oc2..aaaaaaaaj734z2qcu3b7ix2wsoqcdrkkzv4b6bowewssfgsftmf323ukbb5q"
    oc3     = "ocid1.group.oc3..aaaaaaaaz7f7rgzsfpn2f6v7nlm7cnvnjqdrji3dlbexothhlop76i2obp3q"
    oc4     = "ocid1.group.oc4..aaaaaaaapmyfby6o5oagssryr4sf5jx74rkv5ozssh3wlgh66k37i3abz54q"
    oc5     = "ocid1.group.oc5..aaaaaaaafuevsxshssqc3chqieabngvxgnvle65hsjz4mh47dto5ijfklfga"
    oc6     = "ocid1.group.oc6..aaaaaaaafuevsxshssqc3chqieabngvxgnvle65hsjz4mh47dto5ijfklfga"
    oc7     = "ocid1.group.oc7..aaaaaaaafuevsxshssqc3chqieabngvxgnvle65hsjz4mh47dto5ijfklfga"
  }
}

output "ob3_jump_vcn_cidr" {
  value = local.ob3_jump_vcn_cidrs_map["${var.environment}_${var.region_short}"]
}

output "ob3_bastion_cidr" {
  value = local.ob3_bastion_cidrs_map["${var.environment}_${var.region_short}"]
}

output "bastion_lpg_requestor_group_ocid" {
  value = local.ob3_bastion_lpg_requestor_group_ocid_map["${var.realm}"]
}

output "bastion_lpg_requestor_tenancy_ocid" {
  value = local.ob3_bastion_lpg_requestor_tenancy_ocid_map["${var.realm}"]
}

output "oci_host_classes_prod_map" {
  value = local.oci_host_classes_prod_map
}

output "oci_host_classes_dev_map" {
  value = local.oci_host_classes_dev_map
}
