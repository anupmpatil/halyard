resource "splat_service" "splat_service" {
  service_name           = var.service_name
  realm                  = var.realm
  partner_compartment_id = var.compartment_id
  location               = "OVERLAY"
  fleet                  = var.splat_fleet
}

resource "splat_yaml_spec" "api_spec" {
  service_name = var.service_name
  api_yaml     = var.api_yaml

  lifecycle {
    ignore_changes = [description]
  }

  depends_on = [splat_service.splat_service]
}

resource "splat_operational_spec" "operational_spec" {
  service_name         = var.service_name
  tenant_name          = var.tenancy_name
  health_team_id       = "N/A" // OCI health replaced by CASE metrics
  phone_book_team_guid = var.phone_book_id
  lumberjack_namespace = var.lumberjack_namespace
  jump_page_link       = var.jump_page_link
  telemetry {
    project         = var.telemetry_project
    fleet           = var.telemetry_fleet
    key_alarm_names = var.telemetry_key_alarm_names
  }
  grafana_dashboard_names = var.grafana_dashboard_names

  depends_on = [splat_yaml_spec.api_spec]
}

resource "splat_downstream_spec" "downstream_spec" {
  service_name    = var.service_name
  mtls_config_key = "node-certs"
  endpoint        = var.endpoint
  host_headers    = var.host_headers

  //https://confluence.oci.oraclecorp.com/pages/viewpage.action?pageId=228588908
  requires_verifiable_signature = false

  read_timeout_millis = var.read_timeout_millis

  lifecycle {
    ignore_changes = [description]
  }

  depends_on = [splat_operational_spec.operational_spec]
}

resource "splat_deployment" "splat_deployment" {
  service_name                = var.service_name
  target_spec_version         = max(splat_yaml_spec.api_spec.version, splat_downstream_spec.downstream_spec.version)
  rollout_duration_in_seconds = var.rollout_duration_in_seconds

  depends_on = [splat_downstream_spec.downstream_spec, splat_yaml_spec.api_spec]

}

