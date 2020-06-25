# This configuration is realm-wide, and only needs to be included in 1 AD per realm

resource "certificate" tls_server_cert_deployment_service_control_plane_api {
  compartment_id = var.control_plane_compartment_id
  name = "deployment_service_control_plane_api_tls_server_cert"
  description =  "deployment_service_control_plane_api tls server certificate"
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
    common_name = "beta.control.plane.api.clouddeploy.$LONGREGIONNAME.oci.$TOPLEVELDOMAIN"
  }
}

resource "certificate" tls_server_cert_deployment_service_management_plane_api {
  compartment_id = var.management_plane_compartment_id
  name = "deployment_service_management_plane_api_tls_server_cert"
  description =  "deployment_service_management_plane_api tls server certificate"
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

  x509_properties {
    common_name = "beta.management.plane.api.clouddeploy.$LONGREGIONNAME.oci.$TOPLEVELDOMAIN"
  }
}

####### Certificate Bindings #######

resource "certificate_secret_service_binding_resource" server_cert_lb_binding_control_plane_api {
  certificate_ocid = certificate.tls_server_cert_deployment_service_control_plane_api.id
  secret_definition_ocid = var.tls_certificate_control_plane_api.id
  secret_service_compartment_id = var.control_plane_compartment_id
  availability_domain = "ad1"
}

resource "certificate_secret_service_binding_resource" server_cert_lb_binding_management_plane_api {
  certificate_ocid = certificate.tls_server_cert_deployment_service_management_plane_api.id
  secret_definition_ocid = var.tls_certificate_management_plane_api.id
  secret_service_compartment_id = var.management_plane_compartment_id
  availability_domain = "ad1"
}