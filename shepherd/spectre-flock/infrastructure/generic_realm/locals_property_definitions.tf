locals {
  all_numeric_properties = [
    /*
    // There are no properties yet. Add them as necessary
    {
      name: "deployment-limit"
      description: "Insert Description Here"
      type: "NUMERIC"
      default_min: 0
      default_max: 24
    },
    */
  ]

  all_string_properties = [
    {
      name : "devops_deploy_service_ga"
      description : "Property for whitelisting GA features"
      type : "ENUM"
      options : ["true", "false"]
      default_value : "false"
    }
  ]
}
