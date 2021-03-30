/*
 * Limits Onboarding: https://confluence.oci.oraclecorp.com/pages/viewpage.action?spaceKey=PLAT&title=Service+Limits+and+Usage+New+UX+-+Onboarding
 * Limits provider reference: https://confluence.oci.oraclecorp.com/display/SHEP/Limit+Provider
 * Console Features provider reference: https://confluence.oci.oraclecorp.com/display/SHEP/Console+Feature+Provider
 * Properties provider: https://confluence.oci.oraclecorp.com/display/SHEP/Property+Provider
 */

locals {
  deploy_limit_group_name        = "devops-deploy"
  deploy_console_namespace_name  = "console-devops-deploy-whitelist"
  deploy_console_namespace_label = "console-devops-deploy-whitelist"
}

module "compartments" {
  source                        = "./shared_modules/identity"
  canary_tenancy_ocid           = ""
  integration_test_tenancy_ocid = ""
  tenancy_ocid                  = local.execution_target.tenancy_ocid
}

/*
TOP-LEVEL RESOURCES
The following resources are top-level resources for limits and console whitelisting
These must be created before any other resources.
*/

resource "limit_group" "group" {
  compartment_id = module.compartments.limits_compartment.id
  name           = local.deploy_limit_group_name
}

/*
# Placeholder for console feature service. Use this when console-plugin is ready for onboarding.
resource "consolefeature_service" "namespace" {
  managing_compartment_ocid = module.compartments.limits_compartment.id
  name                      = local.deploy_console_namespace_name
  label                     = local.deploy_console_namespace_label
}
*/


/*
 * Properties - requires limit group to be created first
 */
resource "property_definition" "numeric_definitions" {
  for_each = { for prop in local.all_numeric_properties : prop.name => prop }

  depends_on = [limit_group.group]

  group       = limit_group.group.name
  name        = each.key
  description = each.value.description
  type        = "NUMERIC"

  default_min = each.value.default_min
  default_max = each.value.default_max
}

resource "property_value" "numeric_values" {
  for_each = { for prop in local.all_numeric_properties : prop.name => prop }

  depends_on = [property_definition.numeric_definitions]

  group  = limit_group.group.name
  name   = each.key
  region = "all"
  ad     = "all"

  min = each.value.default_min
  max = each.value.default_max
}

resource "property_definition" "string_definitions" {
  for_each = { for prop in local.all_string_properties : prop.name => prop }

  depends_on = [limit_group.group]

  group         = limit_group.group.name
  name          = each.key
  description   = each.value.description
  type          = "ENUM"
  options       = each.value.options
  default_value = each.value.default_value
}

/*
 * Limits - Requires limit group to be created first
 */
resource "limit_definition" "numeric_definitions" {
  for_each = local.numeric_limit_definition_keys

  depends_on = [limit_group.group]

  group       = limit_group.group.name
  name        = each.value.limit.name
  description = each.value.limit.description
  type        = "NUMERIC"

  is_staged   = each.value.limit.is_staged
  service     = each.value.limit.is_staged ? "devops-deploy" : ""
  public_name = each.value.limit.is_staged ? each.value.limit.name : ""

  default_min = each.value.template.min
  default_max = each.value.template.max

  scope = "region"

  lifecycle {
    ignore_changes = [
      bypass_type_enforcement,
      is_released_to_customer,
    ]
  }
}

// Specifies limit values for non-default templates
resource "limit_value" "non_default_templates" {
  for_each = local.numeric_limit_template_keys

  depends_on = [limit_definition.numeric_definitions]

  group = limit_group.group.name
  name  = each.value.limit.name

  ad       = "all"
  region   = "all" // These are applied to all regions by default
  template = each.value.template.template

  min = each.value.template.min
  max = each.value.template.max
}

// Specify region-specific limits
resource "limit_value" "regional_overrides" {
  for_each = local.regional_override_keys

  depends_on = [limit_definition.numeric_definitions]

  group = limit_group.group.name
  name  = each.value.limit_name

  ad       = "all"
  region   = each.value.region
  template = each.value.template.template

  min = each.value.template.min
  max = each.value.template.max
}

/*
 * Limits tenancy overrides - requires that the limit definitions be created first
 */
resource "limit_override" "numeric_limits_overrides" {
  for_each = local.numeric_limits_overrides

  depends_on = [limit_definition.numeric_definitions]

  group = limit_group.group.name
  name  = each.value.limit_name

  tenant_id = each.value.tenancy_ocid
  region    = "all"
  ad        = "all"
  min       = each.value.min
  max       = each.value.max
}

/*
 * Console features - requires console feature service to be created first
 */
/*
resource "consolefeature_value" "features" {
  for_each = local.global_console_feature_map

  depends_on = [consolefeature_service.namespace]

  service = consolefeature_service.namespace.name

  region = "all"
  name   = each.value.name
  value  = each.value.default_value
}
*/
