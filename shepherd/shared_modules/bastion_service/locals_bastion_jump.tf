locals {
  /*
   * Please set Bastion Service's bastion VCN,
   * from the output of ob3-service-onboarding,
   * to the attribute "vcn" which will be needed
   * when filing the SECEDGE peering ticket
   *
   * Please add Bastion Service's bastion host name,
   * from the output of ob3-service-onboarding,
   * to the attribute "bastion" which will be needed
   * for ssh config
   */

  ob3_data_map = {
    beta_phx : {
      "jump_vcn_cidr" : "172.16.105.224/29"
      "vcn" : ""
      "bastion_cidr" : "192.168.1.128/26"
      "bastion" : "vcn16.ob.us-phoenix-1.oci.oraclecloud.com"
    }
    beta_iad : {
      "jump_vcn_cidr" : "192.168.176.248/29"
      "vcn" : ""
      "bastion_cidr" : "172.16.4.128/26"
      "bastion" : "vcn17.ob.us-ashburn-1.oci.oraclecloud.com"
    }
    preprod_iad : {
      "jump_vcn_cidr" : "172.16.224.144/29"
      "vcn" : ""
      "bastion_cidr" : "192.168.4.192/26"
      "bastion" : "vcn18.ob.us-ashburn-1.oci.oraclecloud.com"
    }
    oc1-groupA_iad : {
      "jump_vcn_cidr" : "192.168.125.232/29"
      "vcn" : ""
      "bastion_cidr" : "172.16.104.64/26"
      "bastion" : "vcn4.ob.us-ashburn-1.oci.oraclecloud.com"
    }
    oc1-groupB_phx : {
      "jump_vcn_cidr" : "172.16.119.104/29"
      "vcn" : ""
      "bastion_cidr" : "192.168.101.192/26"
      "bastion" : "vcn10.ob.us-phoenix-1.oci.oraclecloud.com"
    }
    oc1-groupB_lhr : {
      "jump_vcn_cidr" : "192.168.46.192/29"
      "vcn" : ""
      "bastion_cidr" : "172.16.103.192/26"
      "bastion" : "vcn11.ob.uk-london-1.oci.oraclecloud.co"
    }
    oc1-groupA_fra : {
      "jump_vcn_cidr" : "192.168.127.176/29"
      "vcn" : "VCN-FRA-Bastion-AD1-02"
      "bastion_cidr" : "172.16.102.0/26"
      "bastion" : "vcn2.ob.eu-frankfurt-1.oci.oraclecloud.com"
    }
    oc1-groupB_icn : {
      "jump_vcn_cidr" : "192.168.87.120/29"
      "vcn" : "VCN-ICN-Bastion-AD1-11"
      "bastion_cidr" : "172.16.111.192/26"
      "bastion" : "vcn11.ob.ap-seoul-1.oci.oraclecloud.com"
    }
    oc1-groupA_ams : {
      "jump_vcn_cidr" : "192.168.246.80/29"
      "vcn" : "VCN-AMS-Bastion-AD1-06"
      "bastion_cidr" : "172.16.118.128/26"
      "bastion" : "vcn6.ob.eu-amsterdam-1.oci.oraclecloud.com"
    }
    oc1-groupA_nrt : {
      "jump_vcn_cidr" : "172.16.147.184/29"
      "vcn" : "VCN-NRT-Bastion-AD1-12"
      "bastion_cidr" : "192.168.10.0/26"
      "bastion" : "vcn12.ob.ap-tokyo-1.oci.oraclecloud.com"
    }
    oc1-groupC_zrh : {
      "jump_vcn_cidr" : "192.168.134.96/29"
      "vcn" : "VCN-ZRH-Bastion-AD1-06"
      "bastion_cidr" : "172.16.114.128/26"
      "bastion" : "vcn6.ob.eu-zurich-1.oci.oraclecloud.com"
    }

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
  value = local.ob3_data_map["${var.environment}_${var.region_short}"]["jump_vcn_cidr"]
}

output "ob3_bastion_cidr" {
  value = local.ob3_data_map["${var.environment}_${var.region_short}"]["bastion_cidr"]
}

output "ob3_jump_vcn" {
  value = local.ob3_data_map["${var.environment}_${var.region_short}"]["vcn"]
}

output "ob3_bastion" {
  value = local.ob3_data_map["${var.environment}_${var.region_short}"]["bastion"]
}

output "bastion_lpg_requestor_group_ocid" {
  value = local.ob3_bastion_lpg_requestor_group_ocid_map["${var.realm}"]
}

output "bastion_lpg_requestor_tenancy_ocid" {
  value = local.ob3_bastion_lpg_requestor_tenancy_ocid_map["${var.realm}"]
}
