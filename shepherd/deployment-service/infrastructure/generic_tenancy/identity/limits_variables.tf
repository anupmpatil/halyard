// BOAT tenancy id by Realm
variable "boat_tenancy_map" {
  type = map(string)

  default = {
    r1  = "ocid1.tenancy.region1..aaaaaaaa6gqokctiy6pncv6jooomauqibkkhduaohvikdrwi6ze2n5o5v3kq"
    oc1 = "ocid1.tenancy.oc1..aaaaaaaagkbzgg6lpzrf47xzy4rjoxg4de6ncfiq2rncmjiujvy2hjgxvziq"
    oc2 = "ocid1.tenancy.oc2..aaaaaaaagwtifvnhpr2zoymzwmqk364ycc5fspwx2zzc577cxmmnimazi6nq"
    oc3 = "ocid1.tenancy.oc3..aaaaaaaatg7khloug5adtynfkhhhr6ysky5fxb57ghqp3ddpqwqvcavznnnq"
    oc4 = "ocid1.tenancy.oc4..aaaaaaaak37nmbaszvdjdrmkvcvlypax53ila3yajff5tgdffk5njsm2czsa"
    oc5 = "ocid1.tenancy.oc5..aaaaaaaalfjjthxqwuoxh6ps4aqx62zc46w3aj5n425y3dpvqlqwkant5gda"
    oc6 = "ocid1.tenancy.oc6..aaaaaaaalfjjthxqwuoxh6ps4aqx62zc46w3aj5n425y3dpvqlqwkant5gda"
    oc7 = "ocid1.tenancy.oc7..aaaaaaaalfjjthxqwuoxh6ps4aqx62zc46w3aj5n425y3dpvqlqwkant5gda"
  }
}

output "boat_tenancy_ocid" {
  value = var.boat_tenancy_map[var.realm]
}

// limits group ocid by Realm
variable "limits_group_map" {
  type = map(string)

  default = {
    r1  = "ocid1.group.region1..aaaaaaaavgiwcktnoy2jhuiw4ln6bx53qbz24gswipueonlprlapra4kq2la"
    oc1 = "ocid1.group.oc1..aaaaaaaaazkshgwm2rfhtjtrbd2ncac6pa5b5yztdb5kbrgyvbswyj4ptoua"
    oc2 = "ocid1.group.oc2..aaaaaaaaldeh7h6pyem7hh72vdqwoy5xlm753lpj22qkbrzpj2fskxk5p4nq"
    oc3 = "ocid1.group.oc3..aaaaaaaahqonnjthrzbheu7a3d5eirwchzisxa2k7xjze7es2iep54msmn6a"
    oc4 = "ocid1.group.oc4..aaaaaaaatnm7ukyf73kof4n4pq6miho4dfkj45tderlejfnxevbupiys4t3a"
    oc5 = "ocid1.group.oc5..aaaaaaaabyh45fz42u34jpbspfllndmf7xyzx5urpyrja7qnkg3a35nd3ega"
    oc6 = "ocid1.group.oc6..aaaaaaaaimv3odqlup5knhvgpk6gacbg4mjpvkqnhffieeecyr2r6yveww4a"
    oc7 = "ocid1.group.oc7..aaaaaaaakx55qlsq37z4apcqkm4yjcpg4ez6h4oajff7qogsnzgdjwwn24ra"
  }
}


output "limits_group_ocid" {
  value = var.limits_group_map[var.realm]
}