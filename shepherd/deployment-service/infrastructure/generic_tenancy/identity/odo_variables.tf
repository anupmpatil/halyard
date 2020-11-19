// ODO's tenancy OCIDs
variable "odo_tenancy_map" {
  type = map(string)

  default = {
    r1  = "ocid1.tenancy.oc1..aaaaaaaa2kbf34iuw2dbx2dogoafnskkbbfij4pf2afwyzmirctbv6iuebwq"
    oc1 = "ocid1.tenancy.oc1..aaaaaaaapifaj5xamg7tfirnnejmetzqofid55joum3v5q727in5j65kw7la"
    oc2 = "ocid1.tenancy.oc2..aaaaaaaa64oufexwvy3t2rructsn7wl3qnifdwmxv6bpvwxx6dlt2zhsstpq"
    oc3 = "ocid1.tenancy.oc3..aaaaaaaavchug7b2m5c32u3r6af52qra7a7t236sx7zie2vy5rh4k4oyczrq"
    oc4 = "ocid1.tenancy.oc4..aaaaaaaafssq27glvdeim7zn4tmb42un5o4ihpekttryv4bjrkkry4ecibha"
    oc5 = "ocid1.tenancy.oc5..aaaaaaaajodke3xensecdwzqgxs3uw2f3yonbyrvrbiuaxhyctqdlp27agwq"
    oc6 = "ocid1.tenancy.oc6..aaaaaaaajodke3xensecdwzqgxs3uw2f3yonbyrvrbiuaxhyctqdlp27agwq"
    oc7 = "ocid1.tenancy.oc7..aaaaaaaajodke3xensecdwzqgxs3uw2f3yonbyrvrbiuaxhyctqdlp27agwq"
    oc8 = "ocid1.tenancy.oc8..aaaaaaaajodke3xensecdwzqgxs3uw2f3yonbyrvrbiuaxhyctqdlp27agwq"
  }
}

output "odo_tenancy_ocid" {
  value = var.odo_tenancy_map[var.realm]
}