locals {
  regional_overrides_for_realm = local.all_regional_limit_overrides[local.execution_target.region.realm]

  # Gets a flattened list of all regional limit overrides for the current realm
  regional_override_values = flatten([
    for r, v in local.regional_overrides_for_realm : [
      for limit in v : [
        for t in limit.regional_defaults : {
          region : r,
          limit_name : limit.name,
          template : t
        }
      ]
    ]
  ])

  # Make the overrides into a map to avoid unintended duplicates
  regional_override_keys = { for o in local.regional_override_values : "${o.region}:${o.limit_name}:${o.template.template}" => o }

  all_regional_limit_overrides = {
    "oc1" = {
      /*
      # This is an example of how to override limits for a region
      "ap-tokyo-1" = [
        # For example, this setting overrides deployment-limit in ap-tokyo-1
        {
          name : deployment-limit
          regional_defaults : [
            # The following limit is the default limit for all account types in this region, unless otherwise overridden
            {
              template : "default"
              min : 0
              max : 1000
            },
            # The following limits are specific to certain account types in this region
            {
              template : "enterprise"
              min : 0
              max : 1000
            },
            {
              template : "free_tier"
              min : 0
              max : 1000
            },
            {
              template : "government"
              min : 0
              max : 1000
            },
            {
              template : "internal"
              min : 0
              max : 1000
            },
            {
              template : "no_ucm"
              min : 0
              max : 1000
            },
            {
              template : "suspended"
              min : 0
              max : 0
            },
            {
              template : "trial"
              min : 0
              max : 1000
            }
          ]
        }
      ]
      */
    }
  }
}
