# For authoring RQS schema and details about fields please refer -
# https://confluence.oci.oraclecorp.com/display/QP/Author+RQS+schema#AuthorRQSschema-PublishRQSschema

resource "rqs_resource_schema" "application_schema" {
  count                                 = var.environment == "beta" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "Application"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["CLOUD_DEPLOY_APPLICATION_INSPECT"]
  additional_fields_default_permissions = ["CLOUD_DEPLOY_APPLICATION_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
}

resource "rqs_resource_schema" "pipeline_schema" {
  count                                 = var.environment == "beta" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "Pipeline"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["CLOUD_DEPLOY_PIPELINE_INSPECT"]
  additional_fields_default_permissions = ["CLOUD_DEPLOY_PIPELINE_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/pipeline_additional_fields.json")
}

resource "rqs_resource_schema" "stage_schema" {
  count                                 = var.environment == "beta" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "Stage"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["CLOUD_DEPLOY_STAGE_INSPECT"]
  additional_fields_default_permissions = ["CLOUD_DEPLOY_STAGE_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/stage_additional_fields.json")
}

resource "rqs_resource_schema" "artifact_schema" {
  count                                 = var.environment == "beta" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "Artifact"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["CLOUD_DEPLOY_ARTIFACT_INSPECT"]
  additional_fields_default_permissions = ["CLOUD_DEPLOY_ARTIFACT_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/artifact_additional_fields.json")
}

resource "rqs_resource_schema" "environment_schema" {
  count                                 = var.environment == "beta" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "Environment"
  compartment_id                        = var.control_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["CLOUD_DEPLOY_ENVIRONMENT_INSPECT"]
  additional_fields_default_permissions = ["CLOUD_DEPLOY_ENVIRONMENT_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/environment_additional_fields.json")
}

resource "rqs_resource_schema" "deployment_schema" {
  count                                 = var.environment == "beta" ? 1 : 0
  scope                                 = var.scope
  resource_type                         = "Deployment"
  compartment_id                        = var.management_plane_compartment_id
  phone_book_id                         = var.phone_book_id
  common_fields_default_permissions     = ["CLOUD_DEPLOY_DEPLOYMENT_INSPECT"]
  additional_fields_default_permissions = ["CLOUD_DEPLOY_DEPLOYMENT_INSPECT"]
  target_lifecycle_state                = "INDEXABLE"
  additional_fields_json                = file("${path.module}/deployment_additional_fields.json")
}