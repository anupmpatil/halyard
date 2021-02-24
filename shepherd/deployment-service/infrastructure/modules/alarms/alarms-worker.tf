##############################
### Deployment Resource ######
##############################

resource "telemetry_alarm" "DeploymentService_Worker_AvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-AvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "ServiceHostReporter.heartbeat[1m].grouping().absent()"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of ServiceHostReporter.heartbeat is ABSENT null (5 times over 300s)

DeploymentService-Worker Heartbeat

ServiceHostReporter.heartbeat description: DeploymentService-Worker Heartbeat
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

resource "telemetry_alarm" "DeploymentService_Worker_Chainsaw2AvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-Chainsaw2AvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "chainsaw2.standard.application_log.monitoring[1m].grouping().absent()"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of chainsaw2.standard.application_log.monitoring is ABSENT null (5 times over 300s)

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

resource "telemetry_alarm" "DeploymentService_Worker_CreateDeploymentWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-CreateDeploymentWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "createDeployment.1.0.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of createDeployment.1.0.PROVISION.Fault is GT 0.001 (5 times over 300s)

Create Deployment Workflow Fault Rate

createDeployment.1.0.PROVISION.Fault description: Create Deployment Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_CreateDeploymentWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-CreateDeploymentWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "createDeployment.1.0.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of createDeployment.1.0.PROVISION.Time is GT 1000 (5 times over 300s)

CreateDeployment Workflow Latency

createDeployment.1.0.PROVISION.Time description: CreateDeployment Workflow Latency
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

resource "telemetry_alarm" "DeploymentService_Worker_DeleteDeploymentWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-DeleteDeploymentWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "deleteDeployment.2.3.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of deleteDeployment.2.3.PROVISION.Fault is GT 0.001 (5 times over 300s)

Delete Deployment Workflow Fault Rate

deleteDeployment.2.3.PROVISION.Fault description: Delete Deployment Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_DeleteDeploymentWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-DeleteDeploymentWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "deleteDeployment.2.3.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of deleteDeployment.2.3.PROVISION.Time is GT 1000 (5 times over 300s)

DeleteDeployment Workflow Latency

deleteDeployment.2.3.PROVISION.Time description: DeleteDeployment Workflow Latency
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

resource "telemetry_alarm" "DeploymentService_Worker_UpdateDeploymentWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-UpdateDeploymentWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "updateDeployment.1.0.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of updateDeployment.1.0.PROVISION.Fault is GT 0.001 (5 times over 300s)

Update Deployment Workflow Fault Rate

updateDeployment.1.0.PROVISION.Fault description: Update Deployment Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_UpdateDeploymentWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-UpdateDeploymentWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "updateDeployment.1.0.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of updateDeployment.1.0.PROVISION.Time is GT 1000 (5 times over 300s)

UpdateDeployment Workflow Latency

updateDeployment.1.0.PROVISION.Time description: UpdateDeployment Workflow Latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
}

resource "telemetry_alarm" "DeploymentService_Worker_WF_HeapUsageAfterGCAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-WF-HeapUsageAfterGCAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "G1GC.Heap.After[1m].grouping().mean() > 921.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of G1GC.Heap.After is GT 921 (5 times over 300s)

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

resource "telemetry_alarm" "DeploymentService_Worker_WF_JettyThreadPoolUtilizationAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-WF-JettyThreadPoolUtilizationAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "service.org.eclipse.jetty.util.thread.QueuedThreadPool.dw.utilization-max[1m].grouping().mean() > 0.9"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of service.org.eclipse.jetty.util.thread.QueuedThreadPool.dw.utilization-max is GT 0.9 (5 times over 300s)

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

resource "telemetry_alarm" "DeploymentService_Worker_WorkflowMessageQueuePollFaultRateAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-WorkflowMessageQueuePollFaultRateAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "ReadWorkflowRequestQueue.Fault[1m].grouping().mean() > 0.01"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of ReadWorkflowRequestQueue.Fault is GT 0.01 (5 times over 300s)

Workflow message queue poll fault rate

ReadWorkflowRequestQueue.Fault description: Workflow message queue poll fault rate
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
}

resource "telemetry_alarm" "DeploymentService_Worker_WorkflowMessageQueuePollLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-WorkflowMessageQueuePollLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "ReadWorkflowRequestQueue.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of ReadWorkflowRequestQueue.Time is GT 1000 (5 times over 300s)

Workflow message queue polling latency

ReadWorkflowRequestQueue.Time description: Workflow message queue polling latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
}

##############################
### Application Resource #####
##############################

resource "telemetry_alarm" "DeploymentService_Worker_CreateApplicationWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-CreateApplicationWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "createDeployment.1.0.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of createApplication.1.0.PROVISION.Fault is GT 0.001 (5 times over 300s)

Create Application Workflow Fault Rate

createApplication.1.0.PROVISION.Fault description: Create Application Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_CreateApplicationWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-CreateApplicationWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "createApplication.1.0.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of createApplication.1.0.PROVISION.Time is GT 1000 (5 times over 300s)

CreateApplication Workflow Latency

createApplication.1.0.PROVISION.Time description: CreateApplication Workflow Latency
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

resource "telemetry_alarm" "DeploymentService_Worker_DeleteApplicationWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-DeleteApplicationWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "deleteApplication.2.3.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of deleteApplication.2.3.PROVISION.Fault is GT 0.001 (5 times over 300s)

Delete Application Workflow Fault Rate

deleteApplication.2.3.PROVISION.Fault description: Delete Application Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_DeleteApplicationWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-DeleteApplicationWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "deleteApplication.2.3.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of deleteApplication.2.3.PROVISION.Time is GT 1000 (5 times over 300s)

DeleteApplication Workflow Latency

deleteApplication.2.3.PROVISION.Time description: DeleteApplication Workflow Latency
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

resource "telemetry_alarm" "DeploymentService_Worker_UpdateApplicationWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-UpdateApplicationWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "updateApplication.1.0.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of updateApplication.1.0.PROVISION.Fault is GT 0.001 (5 times over 300s)

Update Application Workflow Fault Rate

updateApplication.1.0.PROVISION.Fault description: Update Application Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_UpdateApplicationWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-UpdateApplicationWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "updateApplication.1.0.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of updateApplication.1.0.PROVISION.Time is GT 1000 (5 times over 300s)

UpdateApplication Workflow Latency

updateApplication.1.0.PROVISION.Time description: UpdateApplication Workflow Latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
}

##############################
### Stage Resource ###########
##############################

resource "telemetry_alarm" "DeploymentService_Worker_CreateStageWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-CreateStageWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "createDeployment.1.0.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of createStage.1.0.PROVISION.Fault is GT 0.001 (5 times over 300s)

Create Stage Workflow Fault Rate

createStage.1.0.PROVISION.Fault description: Create Stage Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_CreateStageWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-CreateStageWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "createStage.1.0.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of createStage.1.0.PROVISION.Time is GT 1000 (5 times over 300s)

CreateStage Workflow Latency

createStage.1.0.PROVISION.Time description: CreateStage Workflow Latency
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

resource "telemetry_alarm" "DeploymentService_Worker_DeleteStageWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-DeleteStageWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "deleteStage.2.3.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of deleteStage.2.3.PROVISION.Fault is GT 0.001 (5 times over 300s)

Delete Stage Workflow Fault Rate

deleteStage.2.3.PROVISION.Fault description: Delete Stage Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_DeleteStageWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-DeleteStageWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "deleteStage.2.3.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of deleteStage.2.3.PROVISION.Time is GT 1000 (5 times over 300s)

DeleteStage Workflow Latency

deleteStage.2.3.PROVISION.Time description: DeleteStage Workflow Latency
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

resource "telemetry_alarm" "DeploymentService_Worker_UpdateStageWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-UpdateStageWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "updateStage.1.0.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of updateStage.1.0.PROVISION.Fault is GT 0.001 (5 times over 300s)

Update Stage Workflow Fault Rate

updateStage.1.0.PROVISION.Fault description: Update Stage Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_UpdateStageWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-UpdateStageWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "updateStage.1.0.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of updateStage.1.0.PROVISION.Time is GT 1000 (5 times over 300s)

UpdateStage Workflow Latency

updateStage.1.0.PROVISION.Time description: UpdateStage Workflow Latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
}

##############################
### Artifact Resource ########
##############################

resource "telemetry_alarm" "DeploymentService_Worker_CreateArtifactWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-CreateArtifactWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "createDeployment.1.0.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of createArtifact.1.0.PROVISION.Fault is GT 0.001 (5 times over 300s)

Create Artifact Workflow Fault Rate

createArtifact.1.0.PROVISION.Fault description: Create Artifact Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_CreateArtifactWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-CreateArtifactWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "createArtifact.1.0.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of createArtifact.1.0.PROVISION.Time is GT 1000 (5 times over 300s)

CreateArtifact Workflow Latency

createArtifact.1.0.PROVISION.Time description: CreateArtifact Workflow Latency
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

resource "telemetry_alarm" "DeploymentService_Worker_DeleteArtifactWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-DeleteArtifactWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "deleteArtifact.2.3.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of deleteArtifact.2.3.PROVISION.Fault is GT 0.001 (5 times over 300s)

Delete Artifact Workflow Fault Rate

deleteArtifact.2.3.PROVISION.Fault description: Delete Artifact Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_DeleteArtifactWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-DeleteArtifactWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "deleteArtifact.2.3.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of deleteArtifact.2.3.PROVISION.Time is GT 1000 (5 times over 300s)

DeleteArtifact Workflow Latency

deleteArtifact.2.3.PROVISION.Time description: DeleteArtifact Workflow Latency
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

resource "telemetry_alarm" "DeploymentService_Worker_UpdateArtifactWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-UpdateArtifactWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "updateArtifact.1.0.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of updateArtifact.1.0.PROVISION.Fault is GT 0.001 (5 times over 300s)

Update Artifact Workflow Fault Rate

updateArtifact.1.0.PROVISION.Fault description: Update Artifact Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_UpdateArtifactWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-UpdateArtifactWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "updateArtifact.1.0.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of updateArtifact.1.0.PROVISION.Time is GT 1000 (5 times over 300s)

UpdateArtifact Workflow Latency

updateArtifact.1.0.PROVISION.Time description: UpdateArtifact Workflow Latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
}

##############################
### Environment Resource #####
##############################

resource "telemetry_alarm" "DeploymentService_Worker_CreateEnvironmentWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-CreateEnvironmentWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "createDeployment.1.0.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of createEnvironment.1.0.PROVISION.Fault is GT 0.001 (5 times over 300s)

Create Environment Workflow Fault Rate

createEnvironment.1.0.PROVISION.Fault description: Create Environment Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_CreateEnvironmentWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-CreateEnvironmentWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "createEnvironment.1.0.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of createEnvironment.1.0.PROVISION.Time is GT 1000 (5 times over 300s)

CreateEnvironment Workflow Latency

createEnvironment.1.0.PROVISION.Time description: CreateEnvironment Workflow Latency
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

resource "telemetry_alarm" "DeploymentService_Worker_DeleteEnvironmentWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-DeleteEnvironmentWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "deleteEnvironment.2.3.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of deleteEnvironment.2.3.PROVISION.Fault is GT 0.001 (5 times over 300s)

Delete Environment Workflow Fault Rate

deleteEnvironment.2.3.PROVISION.Fault description: Delete Environment Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_DeleteEnvironmentWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-DeleteEnvironmentWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "deleteEnvironment.2.3.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of deleteEnvironment.2.3.PROVISION.Time is GT 1000 (5 times over 300s)

DeleteEnvironment Workflow Latency

deleteEnvironment.2.3.PROVISION.Time description: DeleteEnvironment Workflow Latency
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

resource "telemetry_alarm" "DeploymentService_Worker_UpdateEnvironmentWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-UpdateEnvironmentWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "updateEnvironment.1.0.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of updateEnvironment.1.0.PROVISION.Fault is GT 0.001 (5 times over 300s)

Update Environment Workflow Fault Rate

updateEnvironment.1.0.PROVISION.Fault description: Update Environment Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_UpdateEnvironmentWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-UpdateEnvironmentWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "updateEnvironment.1.0.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of updateEnvironment.1.0.PROVISION.Time is GT 1000 (5 times over 300s)

UpdateEnvironment Workflow Latency

updateEnvironment.1.0.PROVISION.Time description: UpdateEnvironment Workflow Latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
}

##############################
### WorkRequest Resource #####
##############################

resource "telemetry_alarm" "DeploymentService_Worker_CreateWorkRequestWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-CreateWorkRequestWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "createDeployment.1.0.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of createWorkRequest.1.0.PROVISION.Fault is GT 0.001 (5 times over 300s)

Create WorkRequest Workflow Fault Rate

createWorkRequest.1.0.PROVISION.Fault description: Create WorkRequest Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_CreateWorkRequestWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-CreateWorkRequestWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "createWorkRequest.1.0.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of createWorkRequest.1.0.PROVISION.Time is GT 1000 (5 times over 300s)

CreateWorkRequest Workflow Latency

createWorkRequest.1.0.PROVISION.Time description: CreateWorkRequest Workflow Latency
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

resource "telemetry_alarm" "DeploymentService_Worker_DeleteWorkRequestWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-DeleteWorkRequestWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "deleteWorkRequest.2.3.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of deleteWorkRequest.2.3.PROVISION.Fault is GT 0.001 (5 times over 300s)

Delete WorkRequest Workflow Fault Rate

deleteWorkRequest.2.3.PROVISION.Fault description: Delete WorkRequest Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_DeleteWorkRequestWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-DeleteWorkRequestWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "deleteWorkRequest.2.3.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of deleteWorkRequest.2.3.PROVISION.Time is GT 1000 (5 times over 300s)

DeleteWorkRequest Workflow Latency

deleteWorkRequest.2.3.PROVISION.Time description: DeleteWorkRequest Workflow Latency
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

resource "telemetry_alarm" "DeploymentService_Worker_UpdateWorkRequestWorkflowAvailabilityAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-UpdateWorkRequestWorkflowAvailabilityAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "updateWorkRequest.1.0.PROVISION.Fault[1m].grouping().mean() > 0.001"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): MEAN of updateWorkRequest.1.0.PROVISION.Fault is GT 0.001 (5 times over 300s)

Update WorkRequest Workflow Fault Rate

updateWorkRequest.1.0.PROVISION.Fault description: Update WorkRequest Workflow Fault Rate
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

resource "telemetry_alarm" "DeploymentService_Worker_UpdateWorkRequestWorkflowLatencyAlarm" {
  compartment_id   = var.deployment_worker_compartment_id
  display_name     = "DeploymentService-Worker-UpdateWorkRequestWorkflowLatencyAlarm"
  project          = var.t2_project_name
  fleet            = var.fleet_name_worker
  query            = "updateWorkRequest.1.0.PROVISION.Time[1m].grouping().percentile(0.99) > 1000.0"
  severity         = 3
  is_enabled       = true
  pending_duration = "PT5M"
  body             = <<EOT
SEV3:DeploymentService:deployment-service-worker: >=1 host(s): P99 of updateWorkRequest.1.0.PROVISION.Time is GT 1000 (5 times over 300s)

UpdateWorkRequest Workflow Latency

updateWorkRequest.1.0.PROVISION.Time description: UpdateWorkRequest Workflow Latency
EOT
  destinations {
    jira {
      project   = var.jira_sd_queue
      component = "None"
      item      = "None"
    }
  }
}