locals {
  availability_domain_names = [for ad in var.availability_domains : ad.name]
  //ad_name_to_number_name_map = { for ad in var.availability_domains : ad.name => ad.ad_number_name }
}

data "oci_core_instance_pool_instances" "api_instance_pools" {
  for_each = toset(local.availability_domain_names)

  compartment_id   = var.deployment_api_compartment_id
  instance_pool_id = var.api_instance_pools[each.key].id
}

data "oci_core_instance_pool_instances" "worker_instance_pools" {
  for_each = toset(local.availability_domain_names)

  compartment_id   = var.deployment_worker_compartment_id
  instance_pool_id = var.worker_instance_pools[each.key].id
}

resource "odo_pool" "api" {
  for_each = toset(local.availability_domain_names)

  ad                       = each.key
  alias                    = "${var.name_prefix}-api-${var.release_name}"
  compartment_ocid         = var.deployment_api_compartment_id
  managed_by               = "ODO"
  default_node_admin_state = "STANDBY"

  nodes = [for host in data.oci_core_instance_pool_instances.api_instance_pools[each.key].instances : host.id]
}

resource "odo_pool" "worker" {
  for_each = toset(local.availability_domain_names)

  ad                       = each.key
  alias                    = "${var.name_prefix}-worker-${var.release_name}"
  compartment_ocid         = var.deployment_worker_compartment_id
  managed_by               = "ODO"
  default_node_admin_state = "STANDBY"

  nodes = [for host in data.oci_core_instance_pool_instances.worker_instance_pools[each.key].instances : host.id]
}

resource "odo_application" "odo_application_api" {
  for_each = toset(local.availability_domain_names)

  ad                      = each.key
  alias                   = "${var.name_prefix}-api-${var.stage}"
  compartment_ocid        = var.deployment_api_compartment_id
  agent                   = "HOSTAGENT_V2"
  default_artifact_source = "OBJECT_STORE"
  type                    = var.odo_application_type
  artifact_set_identifier = var.api_artifact_name

  pools = [odo_pool.api[each.key].resource_id]

  config {
    deployments {
      /*
        Starting with a conservative deployment strategy that would only deploy 1 host at a time.
        Please re-evaluate your deployment strategy based on your service's requirements before going production.
      */
      parallelism                  = 1
      parallelism_type             = "HOSTS"
      min_nodes_in_service_percent = floor(100 * (length(odo_pool.api[each.key].nodes) - 1) / length(odo_pool.api[each.key].nodes))

      # 32 minutes gives 31 min for the prestop drain script to run plus 1 min of wiggle room
      #
      # (Unlike the validation script, which needs to be configured, odo automatically runs all
      # scripts in /run-command/prestop/ when stopping, which is where the drain script lives.)
      ttl_seconds_stop_instance        = 1920
      validation_script                = "/postDeployValidate.sh"
      deploy_sequentially              = false
      fault_domain_deploy_sequentially = false
    }

    volumes {
      mapped_to    = "/data"
      access_level = "READ_WRITE"
    }

    volumes {
      mapped_from  = "/etc/pki"
      mapped_to    = "/etc/pki"
      access_level = "READ_ONLY"
    }

    volumes {
      mapped_to    = "/logs"
      access_level = "READ_WRITE"
    }

    runtime_config {
      root_fs_access_level = "READ_WRITE"
      run_as_user          = "odosvc"
    }

    environment_variables {
      name  = "TENANCY_OCID"
      value = var.tenancy_ocid
    }

    environment_variables {
      name  = "DEPLOY_CP_COMPARTMENT_OCID"
      value = var.control_plane_api_compartment_id
    }

    environment_variables {
      name  = "DEPLOY_MP_COMPARTMENT_OCID"
      value = var.management_plane_api_compartment_id
    }

    environment_variables {
      name  = "DEPLOY_CP_WORKER_COMPARTMENT_OCID"
      value = var.cp_worker_compartment_id
    }

    environment_variables {
      name  = "DEPLOY_DP_WORKER_COMPARTMENT_OCID"
      value = var.dp_worker_compartment_id
    }

    environment_variables {
      name  = "PROJECT_CP_COMPARTMENT_OCID"
      value = var.project_svc_cp_compartment_id
    }

    environment_variables {
      name  = "PROJECT_CP_KIEV_ENDPOINT"
      value = var.control_plane_kiev_endpoint
    }

    environment_variables {
      name  = "DEPLOY_DP_KIEV_ENDPOINT"
      value = var.data_plane_kiev_endpoint
    }

    environment_variables {
      name  = "PROJECT_CP_KIEV_STORE_NAME"
      value = var.control_plane_kiev_store_name
    }

    environment_variables {
      name  = "DEPLOY_DP_KIEV_STORE_NAME"
      value = var.data_plane_kiev_store_name
    }

    environment_variables {
      name = "WFAAS_ENDPOINT"
      //value = "https://wfaas-overlay.${local.ad_name_to_number_name_map[each.key]}.${var.region_internal_name}.${var.oci_service_internal_domain_name}"
      value = "https://wfaas-overlay.ad1.${var.region_internal_name}.${var.oci_service_internal_domain_name}"
    }

    environment_variables {
      name = "CP_WORKFLOW_DOMAIN_ID"
      //value = "${var.cp_wfaas_name}.wfaas-overlay.${local.ad_name_to_number_name_map[each.key]}.${var.region_internal_name}.${var.oci_service_internal_domain_name}"
      value = "${var.cp_wfaas_name}.wfaas-overlay.ad1.${var.region_internal_name}.${var.oci_service_internal_domain_name}"
    }

    environment_variables {
      name = "DP_WORKFLOW_DOMAIN_ID"
      //value = "${var.dp_wfaas_name}.wfaas-overlay.${local.ad_name_to_number_name_map[each.key]}.${var.region_internal_name}.${var.oci_service_internal_domain_name}"
      value = "${var.dp_wfaas_name}.wfaas-overlay.ad1.${var.region_internal_name}.${var.oci_service_internal_domain_name}"
    }

  }
}

resource "odo_application" "odo_application_worker" {
  for_each = toset(local.availability_domain_names)

  ad                      = each.key
  alias                   = "${var.name_prefix_worker}-worker-${var.stage}"
  compartment_ocid        = var.deployment_worker_compartment_id
  agent                   = "HOSTAGENT_V2"
  default_artifact_source = "OBJECT_STORE"
  type                    = var.odo_application_type
  artifact_set_identifier = var.worker_artifact_name

  pools = [odo_pool.worker[each.key].resource_id]

  config {
    deployments {

      /*
        Starting with a conservative deployment strategy that would only deploy 1 host at a time.
        Please re-evaluate your deployment strategy based on your service's requirements before going production.
      */
      parallelism                  = 1
      parallelism_type             = "HOSTS"
      min_nodes_in_service_percent = floor(100 * (length(odo_pool.worker[each.key].nodes) - 1) / length(odo_pool.worker[each.key].nodes))

      # 32 minutes gives 31 min for the prestop drain script to run plus 1 min of wiggle room
      #
      # (Unlike the validation script, which needs to be configured, odo automatically runs all
      # scripts in /run-command/prestop/ when stopping, which is where the drain script lives.)
      ttl_seconds_stop_instance        = 1920
      validation_script                = "/postDeployValidate.sh"
      deploy_sequentially              = false
      fault_domain_deploy_sequentially = false
    }

    volumes {
      mapped_to    = "/data"
      access_level = "READ_WRITE"
    }

    volumes {
      mapped_from  = "/etc/pki"
      mapped_to    = "/etc/pki"
      access_level = "READ_ONLY"
    }

    volumes {
      mapped_to    = "/logs"
      access_level = "READ_WRITE"
    }

    runtime_config {
      root_fs_access_level = "READ_WRITE"
      run_as_user          = "odosvc"
    }

    environment_variables {
      name  = "TENANCY_OCID"
      value = var.tenancy_ocid
    }

    environment_variables {
      name  = "DEPLOY_CP_COMPARTMENT_OCID"
      value = var.control_plane_api_compartment_id
    }

    environment_variables {
      name  = "DEPLOY_MP_COMPARTMENT_OCID"
      value = var.management_plane_api_compartment_id
    }

    environment_variables {
      name  = "DEPLOY_CP_WORKER_COMPARTMENT_OCID"
      value = var.cp_worker_compartment_id
    }

    environment_variables {
      name  = "DEPLOY_DP_WORKER_COMPARTMENT_OCID"
      value = var.dp_worker_compartment_id
    }

    environment_variables {
      name  = "PROJECT_CP_COMPARTMENT_OCID"
      value = var.project_svc_cp_compartment_id
    }

    environment_variables {
      name  = "PROJECT_CP_KIEV_ENDPOINT"
      value = var.control_plane_kiev_endpoint
    }

    environment_variables {
      name  = "DEPLOY_DP_KIEV_ENDPOINT"
      value = var.data_plane_kiev_endpoint
    }

    environment_variables {
      name  = "PROJECT_CP_KIEV_STORE_NAME"
      value = var.control_plane_kiev_store_name
    }

    environment_variables {
      name  = "DEPLOY_DP_KIEV_STORE_NAME"
      value = var.data_plane_kiev_store_name
    }

    environment_variables {
      name = "WFAAS_ENDPOINT"
      //value = "https://wfaas-overlay.${local.ad_name_to_number_name_map[each.key]}.${var.region_internal_name}.${var.oci_service_internal_domain_name}"
      value = "https://wfaas-overlay.ad1.${var.region_internal_name}.${var.oci_service_internal_domain_name}"
    }

    environment_variables {
      name = "CP_WORKFLOW_DOMAIN_ID"
      //value = "${var.cp_wfaas_name}.wfaas-overlay.${local.ad_name_to_number_name_map[each.key]}.${var.region_internal_name}.${var.oci_service_internal_domain_name}"
      value = "${var.cp_wfaas_name}.wfaas-overlay.ad1.${var.region_internal_name}.${var.oci_service_internal_domain_name}"
    }

    environment_variables {
      name = "DP_WORKFLOW_DOMAIN_ID"
      //value = "${var.dp_wfaas_name}.wfaas-overlay.${local.ad_name_to_number_name_map[each.key]}.${var.region_internal_name}.${var.oci_service_internal_domain_name}"
      value = "${var.dp_wfaas_name}.wfaas-overlay.ad1.${var.region_internal_name}.${var.oci_service_internal_domain_name}"
    }
  }
}

resource "odo_application" "os_updater" {
  for_each = toset(local.availability_domain_names)

  ad                      = each.key
  alias                   = "${var.name_prefix}-os-updater-${var.stage}"
  compartment_ocid        = var.deployment_api_compartment_id
  type                    = var.odo_application_type
  artifact_set_identifier = "odo-system-updater"
  default_artifact_source = "OBJECT_STORE"
  agent                   = "HOSTAGENT_V2"

  pools = [odo_pool.worker[each.key].resource_id, odo_pool.api[each.key].resource_id]

  config {
    deployments {
      /*
        Starting with a conservative deployment strategy that would only deploy 1 host at a time.
        Please re-evaluate your deployment strategy based on your service's requirements before going production.
      */
      deploy_sequentially              = true
      fault_domain_deploy_sequentially = true
      min_nodes_in_service_percent     = floor(100 * (length(odo_pool.api[each.key].nodes) + length(odo_pool.worker[each.key].nodes) - 1) / (length(odo_pool.api[each.key].nodes) + length(odo_pool.worker[each.key].nodes)))
      parallelism                      = 1
      parallelism_type                 = "HOSTS"
      ttl_seconds_pull_image           = 240
      ttl_seconds_start_instance       = 1200
      ttl_seconds_stop_instance        = 300
      ttl_seconds_validation           = 300
      validation_script                = ""
    }

    runtime_config {
      run_as_root_exception_url = "https://jira.oci.oraclecorp.com/browse/SECARCH-2398"
      run_as_user               = "root"
    }
  }
}
