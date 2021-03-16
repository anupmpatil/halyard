locals {
  force_redeploy   = true
  deployment_flags = local.force_redeploy ? [] : ["SKIP_UP_TO_DATE_NODES"]
}

resource "odo_deployment" "api_deployment_0" {
  ad         = var.availability_domains[0]
  alias      = var.odo_api_application[var.availability_domains[0]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions[var.api_artifact_name].uri
    build_tag = var.artifact_versions[var.api_artifact_name].version
    type      = var.artifact_versions[var.api_artifact_name].type
  }
  deploy_on_every_release = true
  flags                   = local.deployment_flags
  depends_on              = []
}

resource "odo_deployment" "api_deployment_1" {
  count = length(var.availability_domains) > 1 ? 1 : 0

  ad         = var.availability_domains[1]
  alias      = var.odo_api_application[var.availability_domains[1]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions[var.api_artifact_name].uri
    build_tag = var.artifact_versions[var.api_artifact_name].version
    type      = var.artifact_versions[var.api_artifact_name].type
  }
  deploy_on_every_release = true
  flags                   = local.deployment_flags
  depends_on              = [odo_deployment.api_deployment_0]
}

resource "odo_deployment" "api_deployment_2" {
  count = length(var.availability_domains) > 2 ? 1 : 0

  ad         = var.availability_domains[2]
  alias      = var.odo_api_application[var.availability_domains[2]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions[var.api_artifact_name].uri
    build_tag = var.artifact_versions[var.api_artifact_name].version
    type      = var.artifact_versions[var.api_artifact_name].type
  }
  deploy_on_every_release = true
  flags                   = local.deployment_flags
  depends_on              = [odo_deployment.api_deployment_1]
}

/*
  Deploy Worker changes after API, 1 AD at a time assuming there would be 3 ADs.
*/
resource "odo_deployment" "worker_deployment_0" {
  ad         = var.availability_domains[0]
  alias      = var.odo_worker_application[var.availability_domains[0]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions[var.worker_artifact_name].uri
    build_tag = var.artifact_versions[var.worker_artifact_name].version
    type      = var.artifact_versions[var.worker_artifact_name].type
  }
  deploy_on_every_release = true
  flags                   = local.deployment_flags
  depends_on              = []
}

resource "odo_deployment" "worker_deployment_1" {
  count = length(var.availability_domains) > 1 ? 1 : 0

  ad         = var.availability_domains[1]
  alias      = var.odo_worker_application[var.availability_domains[1]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions[var.worker_artifact_name].uri
    build_tag = var.artifact_versions[var.worker_artifact_name].version
    type      = var.artifact_versions[var.worker_artifact_name].type
  }
  deploy_on_every_release = true
  flags                   = local.deployment_flags
  depends_on              = [odo_deployment.worker_deployment_0]
}

resource "odo_deployment" "worker_deployment_2" {
  count = length(var.availability_domains) > 2 ? 1 : 0

  ad         = var.availability_domains[2]
  alias      = var.odo_worker_application[var.availability_domains[2]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions[var.worker_artifact_name].uri
    build_tag = var.artifact_versions[var.worker_artifact_name].version
    type      = var.artifact_versions[var.worker_artifact_name].type
  }
  deploy_on_every_release = true
  flags                   = local.deployment_flags
  depends_on              = [odo_deployment.worker_deployment_1]
}

resource "exec_execution" "integ_test_dlc_deploy_service" {
  count                   = var.artifact_versions["deployment-service-integration-test"].version == "skip" ? 0 : 1
  ad                      = var.availability_domains[0]
  compartment_id          = var.integration_test_compartment_id
  max_run_time_ms         = 1800000
  max_attempts            = 1
  max_postprocess_time_ms = 300000
  max_preprocess_time_ms  = 300000

  depends_on = [odo_deployment.worker_deployment_2]

  execution_details {
    pwd = "/"
    # Exec service tests to see whether exec service is up!
    cmd = ["/etc/run.sh"]

    container {
      docker {
        uri = var.artifact_versions["deployment-service-integration-test"].uri
      }
    }

    environment = {
      "TEST_CLASS"              = "PostDeploymentTestSuite"
      "MAX_TEST_THREADS"        = 3
      "EXECUTION_TARGET_CONFIG" = "${var.execution_target}-${var.environment}"
      "IS_RUNNING_ON_EXEC"      = true
    }
    pool = "kubernetes-pool-overlay"
  }

  outputs_to_download {
    filename_in_exec = "user.log"
    local_filename   = "outputs/user.log"
  }

  timeouts {
    create = "1h"
  }
}