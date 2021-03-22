locals {
  numeric_limits_overrides_for_realm = lookup(local.all_numeric_limits_overrides, local.execution_target.region.realm, [])
  numeric_limits_overrides           = { for o in local.numeric_limits_overrides_for_realm : "${o.limit_name}:${o.region}" => o }
}

locals {
  all_numeric_limits_overrides = {
    /*
    # Specify any customer-tenancy specific overrides here
    "oc1" = [
      {
        limit_name: deployment-limit
        tenancy_ocid = "..."
        description = "Insert description for override"
        min = 0
        max = 150
      },
    ]
    */
  }
}
