resource "odo_deployment" "os-updater-management-plane" {
  for_each   = toset(var.availability_domains)
  ad         = each.value
  alias      = var.odo_app_alias_mp
  is_overlay = true
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  artifact {
    url       = var.artifact_versions[var.artifact_name].uri
    build_tag = var.artifact_versions[var.artifact_name].version
    type      = var.artifact_versions[var.artifact_name].type
  }
  depends_on = []
}

resource "odo_deployment" "os-updater-control-plane" {
  for_each   = toset(var.availability_domains)
  ad         = each.value
  alias      = var.odo_app_alias_cp
  is_overlay = true
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  artifact {
    url       = var.artifact_versions[var.artifact_name].uri
    build_tag = var.artifact_versions[var.artifact_name].version
    type      = var.artifact_versions[var.artifact_name].type
  }
  depends_on = []
}

resource "odo_deployment" "os-updater-bastion" {
  ad         = var.availability_domains[0]
  alias      = var.odo_app_alias_bastion
  is_overlay = true
  flags      = ["SKIP_UP_TO_DATE_NODES"]
  artifact {
    url       = var.artifact_versions[var.artifact_name].uri
    build_tag = var.artifact_versions[var.artifact_name].version
    type      = var.artifact_versions[var.artifact_name].type
  }
  depends_on = []
}