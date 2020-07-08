## **Overview**

* Shepherd is used to deploy both Infrastructure resources and application services.
* It is a replacement to both Tanden pipelines and ODO pipelines.

## **Structure**

Currently we have a flock called "deployment-service" which contains configs for control-plane-api, control-plane-worker, data-plane-worker, 
management-plane-api and odo-system-updater.

Flock is structured as a composition of three folders: "application", "flock_structure" and "infrastructure" as shown below:

    Flock
        - application
            - beta
            - {realm}-prod
            - modules
                - odo-deployment-3ad
        - flock_structure
            - shepherd.tf
        - infrastructure
            - beta
            - {realm}-prod
            - modules
                - alarms
                - certificate
                - dns
                - identity
                - image
                - instances
                - kiev
                - limits
                - load-balancer
                - lumberjack
                - odo-app-pool
                - ob3-jump
                - secret-service
                - service-network

* shepherd.tf file under flock_structure is the main entry point to the shepherd flock config. It contains declaration of various phases and execution targets.
* beta, {realm}-prod folders under application and infrastructure contains code specific to the respective phases.
* modules is the folder where the actual generified resource declaration is kept for modularization.

## **Creating Release**

* A release through shepherd is created through DevOps portal
    https://devops.oci.oraclecorp.com/shepherd/projects/deployment-service
* Shepherd flocks detect change as we merge code to master branch of this repository. Once we have merged commit to master branch, we can create either infrastructure or application release through the UI provided by DevOps Portal.
* While creating a release, we can select a phase or an execution target of our choice which we want the resources or the service to be deployed to.

## **Build Service**

* Build service for this project repo found at:
    https://devops.oci.oraclecorp.com/build/teams/Developer%20Lifecycle%20-%20Cloud%20Deployment
    
## **Terraform fmt**
* terraform fmt command is used to rewrite Terraform files to a canonical format and style. 
  This command applies a subset of the Terraform language style conventions, along with other minor adjustments for readability.
  If files are not formatted then build service will fail with error "Terraform files are not appropriately formatted. Please run terraform fmt -recursive to format them."
  To automate formatting files with every git commit - use pre-commit webhook.
  https://confluence.oci.oraclecorp.com/display/DLC/Terraform+fmt+on+git+commit 