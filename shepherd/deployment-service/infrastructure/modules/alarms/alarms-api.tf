##############################
### Deployment Resource ######
##############################

resource "telemetry_alarm" "DeploymentService_Api_AvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-AvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ServiceHostReporter.heartbeat[1m].grouping().absent()"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of ServiceHostReporter.heartbeat is ABSENT null (5 times over 300s)

DeploymentService-Api Heartbeat

ServiceHostReporter.heartbeat description: DeploymentService-Api Heartbeat
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_Chainsaw2AvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-Chainsaw2AvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "chainsaw2.standard.application_log.monitoring[1m].grouping().absent()"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of chainsaw2.standard.application_log.monitoring is ABSENT null (5 times over 300s)

Heartbeat for a log-group (format: chainsaw2.[logType].[logGroup].monitoring)

chainsaw2.standard.application_log.monitoring description: Heartbeat for a log-group (format: chainsaw2.[logType].[logGroup].monitoring)
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
}

resource "telemetry_alarm" "DeploymentService_Api_HeapUsageAfterGCAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-HeapUsageAfterGCAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "G1GC.Heap.After[1m].grouping().mean() > 921.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of G1GC.Heap.After is GT 921 (5 times over 300s)

Heap Memory Usage After a GC

G1GC.Heap.After description: Heap Memory Usage After a GC
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
}

resource "telemetry_alarm" "DeploymentService_Api_JettyThreadPoolUtilizationAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-JettyThreadPoolUtilizationAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "service.org.eclipse.jetty.util.thread.QueuedThreadPool.dw.utilization-max[1m].grouping().mean() > 0.9"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of service.org.eclipse.jetty.util.thread.QueuedThreadPool.dw.utilization-max is GT 0.9 (5 times over 300s)

Jetty Threadpool Utilization

service.org.eclipse.jetty.util.thread.QueuedThreadPool.dw.utilization-max description: Jetty Threadpool Utilization
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
}

resource "telemetry_alarm" "DeploymentService_Api_CreateDeploymentAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreateDeploymentAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.createDeployment.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of DeploymentResource.createDeployment.SuccessRate is LT 0.999 (5 times over 300s)

Create Deployment Success Rate

DeploymentResource.createDeployment.SuccessRate description: Create Deployment Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_CreateDeploymentLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreateDeploymentLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.createDeployment.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of DeploymentResource.createDeployment.Time is GT 10000 (5 times over 300s)

Deployment creation latency

DeploymentResource.createDeployment.Time description: Deployment creation latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeleteDeploymentAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeleteDeploymentAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.deleteDeployment.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of DeploymentResource.deleteDeployment.SuccessRate is LT 0.999 (5 times over 300s)

Delete Deployment Success Rate

DeploymentResource.deleteDeployment.SuccessRate description: Delete Deployment Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeleteDeploymentLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeleteDeploymentLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.deleteDeployment.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of DeploymentResource.deleteDeployment.Time is GT 10000 (5 times over 300s)

Deployment delate latency

DeploymentResource.deleteDeployment.Time description: Deployment delete latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetDeploymentAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetDeploymentAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.getDeployment.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of DeploymentResource.getDeployment.SuccessRate is LT 0.999 (5 times over 300s)

Get Deployment Success Rate

DeploymentResource.getDeployment.SuccessRate description: Get Deployment Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetDeploymentLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetDeploymentLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.getDeployment.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of DeploymentResource.getDeployment.Time is GT 10000 (5 times over 300s)

Deployment get latency

DeploymentResource.getDeployment.Time description: Deployment get latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListDeploymentAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListDeploymentAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.listDeployment.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of DeploymentResource.listDeployment.SuccessRate is LT 0.999 (5 times over 300s)

List Deployment Success Rate

DeploymentResource.listDeployment.SuccessRate description: List Deployment Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListDeploymentLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListDeploymentLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.listDeployment.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of DeploymentResource.listDeployment.Time is GT 10000 (5 times over 300s)

Deployment list latency

DeploymentResource.listDeployment.Time description: Deployment list latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdateDeploymentAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdateDeploymentAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.updateDeployment.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of DeploymentResource.updateDeployment.SuccessRate is LT 0.999 (5 times over 300s)

Update Deployment Success Rate

DeploymentResource.updateDeployment.SuccessRate description: Update Deployment Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdateDeploymentLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdateDeploymentLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.updateDeployment.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of DeploymentResource.updateDeployment.Time is GT 10000 (5 times over 300s)

Deployment update latency

DeploymentResource.updateDeployment.Time description: Deployment update latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

##############################
### Application Resource #####
##############################

resource "telemetry_alarm" "DeploymentService_Api_CreateApplicationAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreateApplicationAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ApplicationResource.createApplication.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of ApplicationResource.createApplication.SuccessRate is LT 0.999 (5 times over 300s)

Create Application Success Rate

ApplicationResource.createApplication.SuccessRate description: Create Application Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_CreateApplicationLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreateApplicationLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ApplicationResource.createApplication.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of ApplicationResource.createApplication.Time is GT 10000 (5 times over 300s)

Application creation latency

ApplicationResource.createApplication.Time description: Application creation latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeleteApplicationAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeleteApplicationAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ApplicationResource.deleteApplication.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of ApplicationResource.deleteApplication.SuccessRate is LT 0.999 (5 times over 300s)

Delete Application Success Rate

ApplicationResource.deleteApplication.SuccessRate description: Delete Application Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeleteApplicationLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeleteApplicationLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.deleteApplication.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of ApplicationResource.deleteApplication.Time is GT 10000 (5 times over 300s)

Application delete latency

ApplicationResource.deleteApplication.Time description: Application delete latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetApplicationAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetApplicationAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ApplicationResource.getApplication.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:ApplicationService:deployment-service-api: >=1 host(s): MEAN of ApplicationResource.getApplication.SuccessRate is LT 0.999 (5 times over 300s)

Get Application Success Rate

ApplicationResource.getApplication.SuccessRate description: Get Application Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetApplicationLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetApplicationLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ApplicationResource.getApplication.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of ApplicationResource.getApplication.Time is GT 10000 (5 times over 300s)

Application get latency

ApplicationResource.getApplication.Time description: Application get latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListApplicationAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListApplicationAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ApplicationResource.listApplication.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of ApplicationResource.listApplication.SuccessRate is LT 0.999 (5 times over 300s)

List Application Success Rate

ApplicationResource.listApplication.SuccessRate description: List Application Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListApplicationLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListApplicationLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ApplicationResource.listApplication.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of ApplicationResource.listApplication.Time is GT 10000 (5 times over 300s)

Application list latency

ApplicationResource.listApplication.Time description: Application list latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdateApplicationAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdateApplicationAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ApplicationResource.updateApplication.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of ApplicationResource.updateApplication.SuccessRate is LT 0.999 (5 times over 300s)

Update Application Success Rate

ApplicationResource.updateApplication.SuccessRate description: Update Application Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdateApplicationLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdateApplicationLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ApplicationResource.updateApplication.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of ApplicationResource.updateApplication.Time is GT 10000 (5 times over 300s)

Application update latency

ApplicationResource.updateApplication.Time description: Application update latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

##############################
### Stage Resource ###########
##############################

resource "telemetry_alarm" "DeploymentService_Api_CreateStageAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreateStageAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "StageResource.createStage.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of StageResource.createStage.SuccessRate is LT 0.999 (5 times over 300s)

Create Stage Success Rate

StageResource.createStage.SuccessRate description: Create Stage Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_CreateStageLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreateStageLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "StageResource.createStage.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of StageResource.createStage.Time is GT 10000 (5 times over 300s)

Stage creation latency

StageResource.createStage.Time description: Stage creation latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeleteStageAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeleteStageAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "StageResource.deleteStage.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of StageResource.deleteStage.SuccessRate is LT 0.999 (5 times over 300s)

Delete Stage Success Rate

StageResource.deleteStage.SuccessRate description: Delete Stage Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeleteStageLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeleteStageLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.deleteStage.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of StageResource.deleteStage.Time is GT 10000 (5 times over 300s)

Stage delete latency

StageResource.deleteStage.Time description: Stage delete latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetStageAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetStageAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "StageResource.getStage.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:StageService:deployment-service-api: >=1 host(s): MEAN of StageResource.getStage.SuccessRate is LT 0.999 (5 times over 300s)

Get Stage Success Rate

StageResource.getStage.SuccessRate description: Get Stage Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetStageLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetStageLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "StageResource.getStage.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of StageResource.getStage.Time is GT 10000 (5 times over 300s)

Stage get latency

StageResource.getStage.Time description: Stage get latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListStageAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListStageAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "StageResource.listStage.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of StageResource.listStage.SuccessRate is LT 0.999 (5 times over 300s)

List Stage Success Rate

StageResource.listStage.SuccessRate description: List Stage Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListStageLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListStageLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "StageResource.listStage.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of StageResource.listStage.Time is GT 10000 (5 times over 300s)

Stage list latency

StageResource.listStage.Time description: Stage list latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdateStageAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdateStageAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "StageResource.updateStage.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of StageResource.updateStage.SuccessRate is LT 0.999 (5 times over 300s)

Update Stage Success Rate

StageResource.updateStage.SuccessRate description: Update Stage Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdateStageLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdateStageLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "StageResource.updateStage.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of StageResource.updateStage.Time is GT 10000 (5 times over 300s)

Stage update latency

StageResource.updateStage.Time description: Stage update latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

##############################
### Pipeline Resource ########
##############################

resource "telemetry_alarm" "DeploymentService_Api_CreatePipelineAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreatePipelineAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "PipelineResource.createPipeline.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of PipelineResource.createPipeline.SuccessRate is LT 0.999 (5 times over 300s)

Create Pipeline Success Rate

PipelineResource.createPipeline.SuccessRate description: Create Pipeline Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_CreatePipelineLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreatePipelineLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "PipelineResource.createPipeline.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of PipelineResource.createPipeline.Time is GT 10000 (5 times over 300s)

Pipeline creation latency

PipelineResource.createPipeline.Time description: Pipeline creation latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeletePipelineAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeletePipelineAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "PipelineResource.deletePipeline.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of PipelineResource.deletePipeline.SuccessRate is LT 0.999 (5 times over 300s)

Delete Pipeline Success Rate

PipelineResource.deletePipeline.SuccessRate description: Delete Pipeline Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeletePipelineLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeletePipelineLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.deletePipeline.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of PipelineResource.deletePipeline.Time is GT 10000 (5 times over 300s)

Pipeline delete latency

PipelineResource.deletePipeline.Time description: Pipeline delete latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetPipelineAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetPipelineAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "PipelineResource.getPipeline.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:PipelineService:deployment-service-api: >=1 host(s): MEAN of PipelineResource.getPipeline.SuccessRate is LT 0.999 (5 times over 300s)

Get Pipeline Success Rate

PipelineResource.getPipeline.SuccessRate description: Get Pipeline Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetPipelineLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetPipelineLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "PipelineResource.getPipeline.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of PipelineResource.getPipeline.Time is GT 10000 (5 times over 300s)

Pipeline get latency

PipelineResource.getPipeline.Time description: Pipeline get latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListPipelineAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListPipelineAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "PipelineResource.listPipeline.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of PipelineResource.listPipeline.SuccessRate is LT 0.999 (5 times over 300s)

List Pipeline Success Rate

PipelineResource.listPipeline.SuccessRate description: List Pipeline Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListPipelineLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListPipelineLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "PipelineResource.listPipeline.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of PipelineResource.listPipeline.Time is GT 10000 (5 times over 300s)

Pipeline list latency

PipelineResource.listPipeline.Time description: Pipeline list latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdatePipelineAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdatePipelineAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "PipelineResource.updatePipeline.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of PipelineResource.updatePipeline.SuccessRate is LT 0.999 (5 times over 300s)

Update Pipeline Success Rate

PipelineResource.updatePipeline.SuccessRate description: Update Pipeline Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdatePipelineLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdatePipelineLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "PipelineResource.updatePipeline.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of PipelineResource.updatePipeline.Time is GT 10000 (5 times over 300s)

Pipeline update latency

PipelineResource.updatePipeline.Time description: Pipeline update latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

##############################
### Artifact Resource ########
##############################

resource "telemetry_alarm" "DeploymentService_Api_CreateArtifactAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreateArtifactAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ArtifactResource.createArtifact.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of ArtifactResource.createArtifact.SuccessRate is LT 0.999 (5 times over 300s)

Create Artifact Success Rate

ArtifactResource.createArtifact.SuccessRate description: Create Artifact Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_CreateArtifactLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreateArtifactLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ArtifactResource.createArtifact.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of ArtifactResource.createArtifact.Time is GT 10000 (5 times over 300s)

Artifact creation latency

ArtifactResource.createArtifact.Time description: Artifact creation latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeleteArtifactAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeleteArtifactAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ArtifactResource.deleteArtifact.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of ArtifactResource.deleteArtifact.SuccessRate is LT 0.999 (5 times over 300s)

Delete Artifact Success Rate

ArtifactResource.deleteArtifact.SuccessRate description: Delete Artifact Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeleteArtifactLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeleteArtifactLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.deleteArtifact.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of ArtifactResource.deleteArtifact.Time is GT 10000 (5 times over 300s)

Artifact delete latency

ArtifactResource.deleteArtifact.Time description: Artifact delete latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetArtifactAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetArtifactAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ArtifactResource.getArtifact.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:ArtifactService:deployment-service-api: >=1 host(s): MEAN of ArtifactResource.getArtifact.SuccessRate is LT 0.999 (5 times over 300s)

Get Artifact Success Rate

ArtifactResource.getArtifact.SuccessRate description: Get Artifact Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetArtifactLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetArtifactLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ArtifactResource.getArtifact.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of ArtifactResource.getArtifact.Time is GT 10000 (5 times over 300s)

Artifact get latency

ArtifactResource.getArtifact.Time description: Artifact get latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListArtifactAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListArtifactAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ArtifactResource.listArtifact.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of ArtifactResource.listArtifact.SuccessRate is LT 0.999 (5 times over 300s)

List Artifact Success Rate

ArtifactResource.listArtifact.SuccessRate description: List Artifact Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListArtifactLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListArtifactLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ArtifactResource.listArtifact.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of ArtifactResource.listArtifact.Time is GT 10000 (5 times over 300s)

Artifact list latency

ArtifactResource.listArtifact.Time description: Artifact list latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdateArtifactAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdateArtifactAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ArtifactResource.updateArtifact.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of ArtifactResource.updateArtifact.SuccessRate is LT 0.999 (5 times over 300s)

Update Artifact Success Rate

ArtifactResource.updateArtifact.SuccessRate description: Update Artifact Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdateArtifactLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdateArtifactLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "ArtifactResource.updateArtifact.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of ArtifactResource.updateArtifact.Time is GT 10000 (5 times over 300s)

Artifact update latency

ArtifactResource.updateArtifact.Time description: Artifact update latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

##############################
### Environment Resource #####
##############################

resource "telemetry_alarm" "DeploymentService_Api_CreateEnvironmentAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreateEnvironmentAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "EnvironmentResource.createEnvironment.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of EnvironmentResource.createEnvironment.SuccessRate is LT 0.999 (5 times over 300s)

Create Environment Success Rate

EnvironmentResource.createEnvironment.SuccessRate description: Create Environment Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_CreateEnvironmentLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreateEnvironmentLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "EnvironmentResource.createEnvironment.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of EnvironmentResource.createEnvironment.Time is GT 10000 (5 times over 300s)

Environment creation latency

EnvironmentResource.createEnvironment.Time description: Environment creation latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeleteEnvironmentAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeleteEnvironmentAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "EnvironmentResource.deleteEnvironment.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of EnvironmentResource.deleteEnvironment.SuccessRate is LT 0.999 (5 times over 300s)

Delete Environment Success Rate

EnvironmentResource.deleteEnvironment.SuccessRate description: Delete Environment Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeleteEnvironmentLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeleteEnvironmentLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.deleteEnvironment.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of EnvironmentResource.deleteEnvironment.Time is GT 10000 (5 times over 300s)

Environment delete latency

EnvironmentResource.deleteEnvironment.Time description: Environment delete latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetEnvironmentAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetEnvironmentAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "EnvironmentResource.getEnvironment.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:EnvironmentService:deployment-service-api: >=1 host(s): MEAN of EnvironmentResource.getEnvironment.SuccessRate is LT 0.999 (5 times over 300s)

Get Environment Success Rate

EnvironmentResource.getEnvironment.SuccessRate description: Get Environment Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetEnvironmentLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetEnvironmentLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "EnvironmentResource.getEnvironment.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of EnvironmentResource.getEnvironment.Time is GT 10000 (5 times over 300s)

Environment get latency

EnvironmentResource.getEnvironment.Time description: Environment get latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListEnvironmentAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListEnvironmentAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "EnvironmentResource.listEnvironment.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of EnvironmentResource.listEnvironment.SuccessRate is LT 0.999 (5 times over 300s)

List Environment Success Rate

EnvironmentResource.listEnvironment.SuccessRate description: List Environment Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListEnvironmentLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListEnvironmentLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "EnvironmentResource.listEnvironment.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of EnvironmentResource.listEnvironment.Time is GT 10000 (5 times over 300s)

Environment list latency

EnvironmentResource.listEnvironment.Time description: Environment list latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdateEnvironmentAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdateEnvironmentAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "EnvironmentResource.updateEnvironment.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of EnvironmentResource.updateEnvironment.SuccessRate is LT 0.999 (5 times over 300s)

Update Environment Success Rate

EnvironmentResource.updateEnvironment.SuccessRate description: Update Environment Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdateEnvironmentLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdateEnvironmentLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "EnvironmentResource.updateEnvironment.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of EnvironmentResource.updateEnvironment.Time is GT 10000 (5 times over 300s)

Environment update latency

EnvironmentResource.updateEnvironment.Time description: Environment update latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

##############################
### WorkRequest Resource #####
##############################

resource "telemetry_alarm" "DeploymentService_Api_CreateWorkRequestAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreateWorkRequestAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "WorkRequestResource.createWorkRequest.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of WorkRequestResource.createWorkRequest.SuccessRate is LT 0.999 (5 times over 300s)

Create WorkRequest Success Rate

WorkRequestResource.createWorkRequest.SuccessRate description: Create WorkRequest Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_CreateWorkRequestLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-CreateWorkRequestLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "WorkRequestResource.createWorkRequest.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of WorkRequestResource.createWorkRequest.Time is GT 10000 (5 times over 300s)

WorkRequest creation latency

WorkRequestResource.createWorkRequest.Time description: WorkRequest creation latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeleteWorkRequestAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeleteWorkRequestAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "WorkRequestResource.deleteWorkRequest.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of WorkRequestResource.deleteWorkRequest.SuccessRate is LT 0.999 (5 times over 300s)

Delete WorkRequest Success Rate

WorkRequestResource.deleteWorkRequest.SuccessRate description: Delete WorkRequest Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_DeleteWorkRequestLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeleteWorkRequestLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.deleteWorkRequest.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of WorkRequestResource.deleteWorkRequest.Time is GT 10000 (5 times over 300s)

WorkRequest delete latency

WorkRequestResource.deleteWorkRequest.Time description: WorkRequest delete latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetWorkRequestAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetWorkRequestAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "WorkRequestResource.getWorkRequest.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:WorkRequestService:deployment-service-api: >=1 host(s): MEAN of WorkRequestResource.getWorkRequest.SuccessRate is LT 0.999 (5 times over 300s)

Get WorkRequest Success Rate

WorkRequestResource.getWorkRequest.SuccessRate description: Get WorkRequest Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_GetWorkRequestLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-GetWorkRequestLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "WorkRequestResource.getWorkRequest.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of WorkRequestResource.getWorkRequest.Time is GT 10000 (5 times over 300s)

WorkRequest get latency

WorkRequestResource.getWorkRequest.Time description: WorkRequest get latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListWorkRequestAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListWorkRequestAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "WorkRequestResource.listWorkRequest.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of WorkRequestResource.listWorkRequest.SuccessRate is LT 0.999 (5 times over 300s)

List WorkRequest Success Rate

WorkRequestResource.listWorkRequest.SuccessRate description: List WorkRequest Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_ListWorkRequestLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-ListWorkRequestLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "WorkRequestResource.listWorkRequest.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of WorkRequestResource.listWorkRequest.Time is GT 10000 (5 times over 300s)

WorkRequest list latency

WorkRequestResource.listWorkRequest.Time description: WorkRequest list latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdateWorkRequestAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdateWorkRequestAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "WorkRequestResource.updateWorkRequest.SuccessRate[1m].grouping().mean() < 0.999"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): MEAN of WorkRequestResource.updateWorkRequest.SuccessRate is LT 0.999 (5 times over 300s)

Update WorkRequest Success Rate

WorkRequestResource.updateWorkRequest.SuccessRate description: Update WorkRequest Success Rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}

resource "telemetry_alarm" "DeploymentService_Api_UpdateWorkRequestLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-UpdateWorkRequestLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "WorkRequestResource.updateWorkRequest.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of WorkRequestResource.updateWorkRequest.Time is GT 10000 (5 times over 300s)

WorkRequest update latency

WorkRequestResource.updateWorkRequest.Time description: WorkRequest update latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
  labels = ["shepherd-monitor"]
}
