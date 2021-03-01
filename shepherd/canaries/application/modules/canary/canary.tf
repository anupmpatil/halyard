resource "testservice_canary" "deploy-service-canaries" {
  count               = length(var.canaries_list)
  compartment_id      = var.canaries_compartment_id
  name                = "${var.canaries_list[count.index]}-${var.environment}"
  project             = var.t2_project_name
  schedule            = var.canary_frequency_map[var.canaries_list[count.index]]
  availability_domain = var.availability_domains[0]
  max_runtime_in_min  = var.canary_maxruntime_map[var.canaries_list[count.index]]
  enabled             = true
  overlap             = false
  pause_by_failure    = false
  environment = {
    "TEST_METHOD"        = var.canaries_test_method_map[var.canaries_list[count.index]]
    "IS_RUNNING_ON_EXEC" = true
  }
  run_in_overlay = true
  container_identity_metadata {
    resource_compartment_ocid = var.canaries_compartment_id
  }
}

resource "testservice_deployment" "deploy" {
  # canary id that was created, please use the following format as this ID is required for deployment
  count               = length(var.canaries_list)
  canary_id           = testservice_canary.deploy-service-canaries[count.index].id
  canary_name         = "${var.canaries_list[count.index]}-${var.environment}"
  availability_domain = var.availability_domains[0]
  container {
    artifact_name = "deployment-service-integration-test"
    tag           = var.artifact_versions["deployment-service-integration-test"].version
  }
}