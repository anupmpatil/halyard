locals {
  numeric_limit_definitions     = values({ for limit in local.all_numeric_limits : limit.name => { for t in limit.global_defaults : limit.name => { limit : limit, template : t } if t.template == "default" } })
  numeric_limit_definition_keys = merge(local.numeric_limit_definitions...)

  numeric_limit_template_values = values({ for limit in local.all_numeric_limits : limit.name => { for t in limit.global_defaults : "${t.template}_${limit.name}" => { limit : limit, template : t } if t.template != "default" } })
  numeric_limit_template_keys   = merge(local.numeric_limit_template_values...)

  all_numeric_limits = [
    # pipeline-count
    {
      name : "pipeline-count"
      description : "Max number of Deploy Pipelines"
      is_staged : false
      # The following describes limits for all regions.
      # To override these limits for a specific region, see `locals_limits_regional_values.tf`
      # To override these limits for a specific customer tenancy, see `locals_limits_tenancy_overrides.tf`
      global_defaults = [
        # The following limit is the default limit for all regions and account types, unless otherwise overridden
        {
          template : "default"
          min : 0
          max : 1000
        },
        # The following limits are specific to certain account types across all regions
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
    },
    # concurrent-deployment-count
    {
      name : "concurrent-deployment-count"
      description : "Concurrent Deployment Count"
      is_staged : false
      # The following describes limits for all regions.
      # To override these limits for a specific region, see `locals_limits_regional_values.tf`
      # To override these limits for a specific customer tenancy, see `locals_limits_tenancy_overrides.tf`
      global_defaults = [
        # The following limit is the default limit for all regions and account types, unless otherwise overridden
        {
          template : "default"
          min : 0
          max : 100
        },
        # The following limits are specific to certain account types across all regions
        {
          template : "enterprise"
          min : 0
          max : 100
        },
        {
          template : "free_tier"
          min : 0
          max : 100
        },
        {
          template : "government"
          min : 0
          max : 100
        },
        {
          template : "internal"
          min : 0
          max : 100
        },
        {
          template : "no_ucm"
          min : 0
          max : 100
        },
        {
          template : "suspended"
          min : 0
          max : 0
        },
        {
          template : "trial"
          min : 0
          max : 100
        }
      ]
    },
    # stages-per-pipeline-count
    {
      name : "stages-per-pipeline-count"
      description : "Max Stages in a Deploy Pipeline"
      is_staged : false
      # The following describes limits for all regions.
      # To override these limits for a specific region, see `locals_limits_regional_values.tf`
      # To override these limits for a specific customer tenancy, see `locals_limits_tenancy_overrides.tf`
      global_defaults = [
        # The following limit is the default limit for all regions and account types, unless otherwise overridden
        {
          template : "default"
          min : 0
          max : 100
        },
        # The following limits are specific to certain account types across all regions
        {
          template : "enterprise"
          min : 0
          max : 100
        },
        {
          template : "free_tier"
          min : 0
          max : 100
        },
        {
          template : "government"
          min : 0
          max : 100
        },
        {
          template : "internal"
          min : 0
          max : 100
        },
        {
          template : "no_ucm"
          min : 0
          max : 100
        },
        {
          template : "suspended"
          min : 0
          max : 0
        },
        {
          template : "trial"
          min : 0
          max : 100
        }
      ]
    },
    # pipeline-build-hours
    {
      name : "pipeline-build-hours"
      description : "Maximum Build Hours used per month."
      is_staged : false
      # The following describes limits for all regions.
      # To override these limits for a specific region, see `locals_limits_regional_values.tf`
      # To override these limits for a specific customer tenancy, see `locals_limits_tenancy_overrides.tf`
      global_defaults = [
        # The following limit is the default limit for all regions and account types, unless otherwise overridden
        {
          template : "default"
          min : 0
          max : 100000
        },
        # The following limits are specific to certain account types across all regions
        {
          template : "enterprise"
          min : 0
          max : 100000
        },
        {
          template : "free_tier"
          min : 0
          max : 100000
        },
        {
          template : "government"
          min : 0
          max : 100000
        },
        {
          template : "internal"
          min : 0
          max : 100000
        },
        {
          template : "no_ucm"
          min : 0
          max : 100000
        },
        {
          template : "suspended"
          min : 0
          max : 0
        },
        {
          template : "trial"
          min : 0
          max : 100000
        }
      ]
    },
    # environment-count
    {
      name : "environment-count"
      description : "Environment Count"
      is_staged : false
      # The following describes limits for all regions.
      # To override these limits for a specific region, see `locals_limits_regional_values.tf`
      # To override these limits for a specific customer tenancy, see `locals_limits_tenancy_overrides.tf`
      global_defaults = [
        # The following limit is the default limit for all regions and account types, unless otherwise overridden
        {
          template : "default"
          min : 0
          max : 1000
        },
        # The following limits are specific to certain account types across all regions
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
    },
    # stage-count
    {
      name : "stage-count"
      description : "Stage Count"
      is_staged : false
      # The following describes limits for all regions.
      # To override these limits for a specific region, see `locals_limits_regional_values.tf`
      # To override these limits for a specific customer tenancy, see `locals_limits_tenancy_overrides.tf`
      global_defaults = [
        # The following limit is the default limit for all regions and account types, unless otherwise overridden
        {
          template : "default"
          min : 0
          max : 1000
        },
        # The following limits are specific to certain account types across all regions
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
    },
    # artifact-count
    {
      name : "artifact-count"
      description : "Artifact Count"
      is_staged : false
      # The following describes limits for all regions.
      # To override these limits for a specific region, see `locals_limits_regional_values.tf`
      # To override these limits for a specific customer tenancy, see `locals_limits_tenancy_overrides.tf`
      global_defaults = [
        # The following limit is the default limit for all regions and account types, unless otherwise overridden
        {
          template : "default"
          min : 0
          max : 1000
        },
        # The following limits are specific to certain account types across all regions
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
    },
  ]
}
