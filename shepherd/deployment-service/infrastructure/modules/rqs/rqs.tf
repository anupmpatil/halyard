# For authoring RQS schema and details about fields please refer -
# https://confluence.oci.oraclecorp.com/display/QP/Author+RQS+schema#AuthorRQSschema-PublishRQSschema

resource "rqs_resource_schema" "devopsdeploy_pipeline_schema" {
  count                                 = var.environment == "prod" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "DevOpsDeployPipeline"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["DEVOPS_DEPLOY_PIPELINE_INSPECT"]
  additional_fields_default_permissions = ["DEVOPS_DEPLOY_PIPELINE_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/pipeline_additional_fields.json")
}

resource "rqs_resource_schema" "devopsdeploy_stage_schema" {
  count                                 = var.environment == "prod" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "DevOpsDeployStage"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["DEVOPS_DEPLOY_STAGE_INSPECT"]
  additional_fields_default_permissions = ["DEVOPS_DEPLOY_STAGE_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/stage_additional_fields.json")
}

resource "rqs_resource_schema" "devopsdeploy_artifact_schema" {
  count                                 = var.environment == "prod" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "DevOpsDeployArtifact"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["DEVOPS_DEPLOY_ARTIFACT_INSPECT"]
  additional_fields_default_permissions = ["DEVOPS_DEPLOY_ARTIFACT_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/artifact_additional_fields.json")
}

resource "rqs_resource_schema" "devopsdeploy_environment_schema" {
  count                                 = var.environment == "prod" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "DevOpsDeployEnvironment"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["DEVOPS_DEPLOY_ENVIRONMENT_INSPECT"]
  additional_fields_default_permissions = ["DEVOPS_DEPLOY_ENVIRONMENT_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/environment_additional_fields.json")
}

resource "rqs_resource_schema" "devopsdeploy_deployment_schema" {
  count                                 = var.environment == "prod" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "DevOpsDeployment"
  compartment_id                        = var.management_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["DEVOPS_DEPLOY_DEPLOYMENT_INSPECT"]
  additional_fields_default_permissions = ["DEVOPS_DEPLOY_DEPLOYMENT_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/deployment_additional_fields.json")
}