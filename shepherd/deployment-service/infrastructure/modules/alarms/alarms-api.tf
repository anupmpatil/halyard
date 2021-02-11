resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_AvailabilityAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_Chainsaw2AvailabilityAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_HeapUsageAfterGCAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_JettyThreadPoolUtilizationAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_DeploymentCreateAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeploymentCreateAvailabilityAlarm"
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

resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_DeploymentCreateLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeploymentCreateLatencyAlarm"
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

resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_DeploymentDeleteAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeploymentDeleteAvailabilityAlarm"
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

resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_DeploymentDeleteLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeploymentDeleteLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_api
  query            = "DeploymentResource.deleteDeployment.Time[1m].grouping().percentile(0.99) > 10000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-api: >=1 host(s): P99 of DeploymentResource.deleteDeployment.Time is GT 10000 (5 times over 300s)

Deployment delate latency

DeploymentResource.deleteDeployment.Time description: Deployment delate latency
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

resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_DeploymentGetAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeploymentGetAvailabilityAlarm"
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

resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_DeploymentGetLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeploymentGetLatencyAlarm"
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

resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_DeploymentListAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeploymentListAvailabilityAlarm"
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

resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_DeploymentListLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeploymentListLatencyAlarm"
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

resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_DeploymentUpdateAvailabilityAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeploymentUpdateAvailabilityAlarm"
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

resource "telemetry_alarm" "DeploymentService_reference_app_api_DeploymentService_Api_DeploymentUpdateLatencyAlarm" {
  compartment_id   = var.deployment_api_compartment_id
  display_name     = "DeploymentService-Api-DeploymentUpdateLatencyAlarm"
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
