data "oci_core_instance_pool_instances" "api_instance_pools" {
  for_each = toset(var.availability_domains)

  compartment_id   = var.deployment_api_compartment_id
  instance_pool_id = var.api_instance_pools[each.key].id
}

data "oci_core_instance_pool_instances" "worker_instance_pools" {
  for_each = toset(var.availability_domains)

  compartment_id   = var.deployment_worker_compartment_id
  instance_pool_id = var.worker_instance_pools[each.key].id
}

resource "odo_pool" "api" {
  for_each = toset(var.availability_domains)

  ad                       = each.key
  alias                    = "${var.name_prefix}-api-${var.release_name}"
  compartment_ocid         = var.deployment_api_compartment_id
  managed_by               = "ODO"
  default_node_admin_state = "STANDBY"

  nodes = [for host in data.oci_core_instance_pool_instances.api_instance_pools[each.key].instances : host.id]
}

resource "odo_pool" "worker" {
  for_each = toset(var.availability_domains)

  ad                       = each.key
  alias                    = "${var.name_prefix}-worker-${var.release_name}"
  compartment_ocid         = var.deployment_worker_compartment_id
  managed_by               = "ODO"
  default_node_admin_state = "STANDBY"

  nodes = [for host in data.oci_core_instance_pool_instances.worker_instance_pools[each.key].instances : host.id]
}

resource "odo_application" "odo_application_api" {
  for_each = toset(var.availability_domains)

  ad                      = each.key
  alias                   = "${var.name_prefix}-api-${var.stage}"
  compartment_ocid        = var.deployment_api_compartment_id
  agent                   = "HOSTAGENT_V2"
  default_artifact_source = "OBJECT_STORE"
  type                    = var.odo_application_type
  artifact_set_identifier = "deployment-service-api"

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
    }
  }
}

resource "odo_application" "odo_application_worker" {
  for_each = toset(var.availability_domains)

  ad                      = each.key
  alias                   = "${var.name_prefix}-worker-${var.stage}"
  compartment_ocid        = var.deployment_worker_compartment_id
  agent                   = "HOSTAGENT_V2"
  default_artifact_source = "OBJECT_STORE"
  type                    = var.odo_application_type
  artifact_set_identifier = "deployment-service-worker"

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
    }
  }
}

resource "odo_application" "os_updater" {
  for_each = toset(var.availability_domains)

  ad                      = each.key
  alias                   = "${var.name_prefix}-os-updater-${var.stage}"
  compartment_ocid        = var.deployment_api_compartment_id
  type                    = var.odo_application_type
  artifact_set_identifier = "odo-system-updater"
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

/*
  Deploy os_updater changes, 1 AD at a time assuming there would be 3 ADs.
*/
resource "odo_deployment" "os_updater_deployment_0" {
  ad         = var.availability_domains[0]
  alias      = odo_application.os_updater[var.availability_domains[0]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions["odo-system-updater"].uri
    build_tag = var.artifact_versions["odo-system-updater"].version
    type      = var.artifact_versions["odo-system-updater"].type
  }
  flags = ["SKIP_UP_TO_DATE_NODES"]
}

resource "odo_deployment" "os_updater_deployment_1" {
  ad         = var.availability_domains[1]
  alias      = odo_application.os_updater[var.availability_domains[1]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions["odo-system-updater"].uri
    build_tag = var.artifact_versions["odo-system-updater"].version
    type      = var.artifact_versions["odo-system-updater"].type
  }
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.os_updater_deployment_0]
}
resource "odo_deployment" "os_updater_deployment_2" {
  ad         = var.availability_domains[2]
  alias      = odo_application.os_updater[var.availability_domains[2]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions["odo-system-updater"].uri
    build_tag = var.artifact_versions["odo-system-updater"].version
    type      = var.artifact_versions["odo-system-updater"].type
  }
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.os_updater_deployment_1]
}

/*
  Deploy API changes after os_updater, 1 AD at a time assuming there would be 3 ADs.
*/
resource "odo_deployment" "api_deployment_0" {
  ad         = var.availability_domains[0]
  alias      = odo_application.odo_application_api[var.availability_domains[0]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions["deployment-service-api"].uri
    build_tag = var.artifact_versions["deployment-service-api"].version
    type      = var.artifact_versions["deployment-service-api"].type
  }
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.os_updater_deployment_2]
}

resource "odo_deployment" "api_deployment_1" {
  ad         = var.availability_domains[1]
  alias      = odo_application.odo_application_api[var.availability_domains[1]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions["deployment-service-api"].uri
    build_tag = var.artifact_versions["deployment-service-api"].version
    type      = var.artifact_versions["deployment-service-api"].type
  }
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.api_deployment_0]
}

resource "odo_deployment" "api_deployment_2" {
  ad         = var.availability_domains[2]
  alias      = odo_application.odo_application_api[var.availability_domains[2]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions["deployment-service-api"].uri
    build_tag = var.artifact_versions["deployment-service-api"].version
    type      = var.artifact_versions["deployment-service-api"].type
  }
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.api_deployment_1]
}

/*
  Deploy Worker changes after API, 1 AD at a time assuming there would be 3 ADs.
*/
resource "odo_deployment" "worker_deployment_0" {
  ad         = var.availability_domains[0]
  alias      = odo_application.odo_application_worker[var.availability_domains[0]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions["deployment-service-worker"].uri
    build_tag = var.artifact_versions["deployment-service-worker"].version
    type      = var.artifact_versions["deployment-service-worker"].type
  }
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.api_deployment_2]
}

resource "odo_deployment" "worker_deployment_1" {
  ad         = var.availability_domains[1]
  alias      = odo_application.odo_application_worker[var.availability_domains[1]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions["deployment-service-worker"].uri
    build_tag = var.artifact_versions["deployment-service-worker"].version
    type      = var.artifact_versions["deployment-service-worker"].type
  }
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.worker_deployment_0]
}

resource "odo_deployment" "worker_deployment_2" {
  ad         = var.availability_domains[2]
  alias      = odo_application.odo_application_worker[var.availability_domains[2]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions["deployment-service-worker"].uri
    build_tag = var.artifact_versions["deployment-service-worker"].version
    type      = var.artifact_versions["deployment-service-worker"].type
  }
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.worker_deployment_1]
}
