// https://confluence.oci.oraclecorp.com/x/swjxAQ
// aka https://confluence.oci.oraclecorp.com/display/SecDev/Onboarding+with+Host+Updater+-+for+Customers
// - see "Writing Policy in your tenancy" section
variable "secinf_tenancy_map" {
  type = map(string)

  default = {
    r1  = "ocid1.tenancy.oc1..aaaaaaaaotavxiclog2rinevwxn2mx7ov6xsaipgyw3v3kzp3nvsd2ranzta"
    oc1 = "ocid1.tenancy.oc1..aaaaaaaanj5voqovlktwp3kkwx2yqb64mwe44cjjyewz4jhp4mwjahtl3ypa"
    oc2 = "ocid1.tenancy.oc2..aaaaaaaahjq5ftdivt4uvgcr6dn7pxdv57fof7enefptwnroy2fsbkzwp54a"
    oc3 = "ocid1.tenancy.oc3..aaaaaaaa2p5zwkcdq5a5tpcnbgdfqqif3djxn3iwp7rxxdwnzw3qn2fixh4q"
    oc4 = "ocid1.tenancy.oc4..aaaaaaaacwco4ikxphof7qy6qgarxd56gxtzgfgegdt5uiowccwk4s6267fa"
    oc5 = "ocid1.tenancy.oc5..aaaaaaaacnia2snq7afat75dkfngqfn3gorcspk7jyphvunlhb24rpnwmpfa"
    oc6 = "ocid1.tenancy.oc6..aaaaaaaacnia2snq7afat75dkfngqfn3gorcspk7jyphvunlhb24rpnwmpfa"
    oc7 = "ocid1.tenancy.oc7..aaaaaaaacnia2snq7afat75dkfngqfn3gorcspk7jyphvunlhb24rpnwmpfa"
  }
}

output "secinf_tenancy_ocid" {
  value = var.secinf_tenancy_map[var.realm]
}