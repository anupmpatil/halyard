# For authoring RQS schema and details about fields please refer -
# https://confluence.oci.oraclecorp.com/display/QP/Author+RQS+schema#AuthorRQSschema-PublishRQSschema

resource "rqs_resource_schema" "clouddeploy_application_schema" {
  count                                 = var.environment == "prod" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "CloudDeployApplication"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["CLOUD_DEPLOY_APPLICATION_INSPECT"]
  additional_fields_default_permissions = ["CLOUD_DEPLOY_APPLICATION_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
}

resource "rqs_resource_schema" "clouddeploy_pipeline_schema" {
  count                                 = var.environment == "prod" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "CloudDeployPipeline"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["CLOUD_DEPLOY_PIPELINE_INSPECT"]
  additional_fields_default_permissions = ["CLOUD_DEPLOY_PIPELINE_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/pipeline_additional_fields.json")
}

resource "rqs_resource_schema" "clouddeploy_stage_schema" {
  count                                 = var.environment == "prod" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "CloudDeployStage"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["CLOUD_DEPLOY_STAGE_INSPECT"]
  additional_fields_default_permissions = ["CLOUD_DEPLOY_STAGE_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/stage_additional_fields.json")
}

resource "rqs_resource_schema" "clouddeploy_artifact_schema" {
  count                                 = var.environment == "prod" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "CloudDeployArtifact"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["CLOUD_DEPLOY_ARTIFACT_INSPECT"]
  additional_fields_default_permissions = ["CLOUD_DEPLOY_ARTIFACT_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/artifact_additional_fields.json")
}

resource "rqs_resource_schema" "clouddeploy_environment_schema" {
  count                                 = var.environment == "prod" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "CloudDeployEnvironment"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["CLOUD_DEPLOY_ENVIRONMENT_INSPECT"]
  additional_fields_default_permissions = ["CLOUD_DEPLOY_ENVIRONMENT_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/environment_additional_fields.json")
}

resource "rqs_resource_schema" "clouddeploy_deployment_schema" {
  count                                 = var.environment == "prod" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "CloudDeployDeployment"
  compartment_id                        = var.management_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["CLOUD_DEPLOY_DEPLOYMENT_INSPECT"]
  additional_fields_default_permissions = ["CLOUD_DEPLOY_DEPLOYMENT_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/deployment_additional_fields.json")
}