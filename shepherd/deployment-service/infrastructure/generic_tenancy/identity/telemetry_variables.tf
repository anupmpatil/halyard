// T2 tenancy id by Realm
variable "telemetry_tenancy_map" {
  type = map(string)

  default = {
    r1  = "ocid1.tenancy.oc1..aaaaaaaahxmrfifxtvc66mdmwrd6loob6u5ud5vc7ct2q4si2j3iqbzbgglq"
    oc1 = "ocid1.tenancy.oc1..aaaaaaaarezxy4xq7jaujylzy7ron3biubdnlvagxeoz6kx7gykcr4brbypq"
    oc2 = "ocid1.tenancy.oc2..aaaaaaaabpvme7qlr76hgs5k7xulyltg3xuoqwzmuyfakacmi62ap3ffdjia"
    oc3 = "ocid1.tenancy.oc3..aaaaaaaac4ovtiub7ujsvnlacbgyvbmg5tihlsp7ogywifd5gykl3lwlxwoa"
    oc4 = "ocid1.tenancy.oc4..aaaaaaaaiqvz4ix4ag2dmn3qnv6zrvegukzc3fjnemdxbtd7u2cgwq6fvnha"
    oc5 = "ocid1.tenancy.oc5..aaaaaaaadh3vlrr3er4hbx4sli6cz47ikv2itsge77ggyyxknbaqclv6nvlq"
    oc6 = "ocid1.tenancy.oc6..aaaaaaaadh3vlrr3er4hbx4sli6cz47ikv2itsge77ggyyxknbaqclv6nvlq"
    oc7 = "ocid1.tenancy.oc7..aaaaaaaadh3vlrr3er4hbx4sli6cz47ikv2itsge77ggyyxknbaqclv6nvlq"
  }
}

output "telemetry_tenancy_ocid" {
  value = var.telemetry_tenancy_map[var.realm]
}