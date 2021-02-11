resource "telemetry_alarm" "DeploymentService_reference_app_worker_DeploymentService_Worker_AvailabilityAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_worker_DeploymentService_Worker_Chainsaw2AvailabilityAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_worker_DeploymentService_Worker_CreateDeploymentWorkflowAvailabilityAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_worker_DeploymentService_Worker_CreateDeploymentWorkflowLatencyAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_worker_DeploymentService_Worker_DeleteDeploymentWorkflowAvailabilityAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_worker_DeploymentService_Worker_DeleteDeploymentWorkflowLatencyAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_worker_DeploymentService_Worker_UpdateDeploymentWorkflowAvailabilityAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_worker_DeploymentService_Worker_UpdateDeploymentWorkflowLatencyAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_worker_DeploymentService_Worker_WF_HeapUsageAfterGCAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_worker_DeploymentService_Worker_WF_JettyThreadPoolUtilizationAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_worker_DeploymentService_Worker_WorkflowMessageQueuePollFaultRateAlarm" {
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

resource "telemetry_alarm" "DeploymentService_reference_app_worker_DeploymentService_Worker_WorkflowMessageQueuePollLatencyAlarm" {
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
