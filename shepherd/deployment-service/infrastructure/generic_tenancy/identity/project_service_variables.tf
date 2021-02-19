variable "project_service_tenancy_map" {
  type = map(string)

  default = {
    beta    = "ocid1.tenancy.oc1..aaaaaaaahsav5slbvffyyakyjy7ei3g75wlyg65zbahrmn2hrkrc6rrhqqxa"
    preprod = "ocid1.tenancy.oc1..aaaaaaaaxk63qg5pdoarb5ujeciq2rqjun6n23tszzwofrqaq7thiaoz7eja"
    oc1     = "ocid1.tenancy.oc1..aaaaaaaaiw6ql6qiyfaed2ug3escrjar5azwwkf73efwmwpr4jryirourifq"
  }
}

output "project_service_tenancy_ocid" {
  value = var.project_service_tenancy_map[var.environment == "prod" ? var.realm : var.environment]
}
