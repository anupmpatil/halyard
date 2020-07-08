/*
  Deploy os_updater changes, 1 AD at a time assuming there would be 3 ADs.
*/
resource "odo_deployment" "os_updater_deployment_0" {
  ad         = var.availability_domains[0]
  alias      = var.odo_os_updater_application[var.availability_domains[0]].alias
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
  alias      = var.odo_os_updater_application[var.availability_domains[1]].alias
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
  alias      = var.odo_os_updater_application[var.availability_domains[2]].alias
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
  alias      = var.odo_api_application[var.availability_domains[0]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions[var.api_artifact_name].uri
    build_tag = var.artifact_versions[var.api_artifact_name].version
    type      = var.artifact_versions[var.api_artifact_name].type
  }
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.os_updater_deployment_2]
}

resource "odo_deployment" "api_deployment_1" {
  ad         = var.availability_domains[1]
  alias      = var.odo_api_application[var.availability_domains[1]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions[var.api_artifact_name].uri
    build_tag = var.artifact_versions[var.api_artifact_name].version
    type      = var.artifact_versions[var.api_artifact_name].type
  }
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.api_deployment_0]
}

resource "odo_deployment" "api_deployment_2" {
  ad         = var.availability_domains[2]
  alias      = var.odo_api_application[var.availability_domains[2]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions[var.api_artifact_name].uri
    build_tag = var.artifact_versions[var.api_artifact_name].version
    type      = var.artifact_versions[var.api_artifact_name].type
  }
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.api_deployment_1]
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
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.api_deployment_2]
}

resource "odo_deployment" "worker_deployment_1" {
  ad         = var.availability_domains[1]
  alias      = var.odo_worker_application[var.availability_domains[1]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions[var.worker_artifact_name].uri
    build_tag = var.artifact_versions[var.worker_artifact_name].version
    type      = var.artifact_versions[var.worker_artifact_name].type
  }
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.worker_deployment_0]
}

resource "odo_deployment" "worker_deployment_2" {
  ad         = var.availability_domains[2]
  alias      = var.odo_worker_application[var.availability_domains[2]].alias
  is_overlay = true
  artifact {
    url       = var.artifact_versions[var.worker_artifact_name].uri
    build_tag = var.artifact_versions[var.worker_artifact_name].version
    type      = var.artifact_versions[var.worker_artifact_name].type
  }
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  depends_on = [odo_deployment.worker_deployment_1]
}
