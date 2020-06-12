# This configuration is realm-wide, and only needs to be included in 1 AD per realm

resource "certificate" tls_server_cert_deployment_service_api {
  compartment_id = var.compartment_id
  name = "deployment_service_api-tls-server-cert"
  description =  "deployment_service_api tls server certificate"
  phonebook_name =  var.phonebook_name

  # One of "TLS_SERVER", "TLS_CLIENT", "SERVICE_PRINCIPAL"
  type = "TLS_SERVER"

  # One of "REGIONAL", "CROSS_REGIONAL"
  authority = "CROSS_REGIONAL"

  certificate_lifetime = "180d"

  delivery {
    # One of "HOSTCLASS", "MANUAL", "LOAD_BALANCER", "SECRET_SERVICE"
    delivery_mechanism = "SECRET_SERVICE"
  }

  # x509 properties which are strings may have symbolic values specified in them which will automatically be substituted:
  #   REALM (region1, oc1, oc2 ...)
  #   REGION (r1, r2, us-ashburn-1, etc)
  #   LONGREGIONNAME (r1, us-phoenix-1, us-ashburn-1, etc)
  #   AD (ad1, ad2, ad3, pop1, pop2)
  #   TOPLEVELDOMAIN (oracleiaas.com, oraclegoviaas.com)

  x509_properties {
    common_name = "beta.api.service.clouddeploy.$LONGREGIONNAME.oci.$TOPLEVELDOMAIN"
  }

}

####### Certificate Bindings #######

resource "certificate_secret_service_binding_resource" server_cert_lb_binding {
  certificate_ocid = certificate.tls_server_cert_deployment_service_api.id
  secret_definition_ocid = var.tls_certificate.id
  secret_service_compartment_id = var.compartment_id
  availability_domain = "ad1"
}