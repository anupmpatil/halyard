# Requesting DNS records for SPLAT onboarding

This directory contains Terraform configuration for requesting DNS records for project service.
DNS records must be requested for every region that service is deployed to.

Note that this process is needed because DNS records cannot be currently requested through Shepherd.
Once Shepherd allows DNS record creation, this process should be handled in Shepherd configs.

## Prerequisites
0. Install latest Terraform version (v0.12 and above)

1. Ensure that you have a BOAT account and ~/.oci/config entry for the realm that you are requesting.

You can follow this [guide](https://confluence.oci.oraclecorp.com/display/DNS/SSID%3A+Adding+API+Keys+to+Your+BOAT+User)
to set up your BOAT account profile.

2. Allow Terraform to use your BOAT account profile.

```shell
export TF_VAR_config_file_profile=<name that you gave your profile in step 1>
```

3. Initialize Terraform in this directory
```shell
terraform init
```

## Update the main.tf variables with the environment, realm, and region for which to create DNS records

```
# This should usually bet set to "prod" unless you're requesting records for a non-production environment
variable "environment" {
default = "prod"
description = "Environment to get DNS records for: e.g. prod, beta, preprod"
}

variable "realm" {
default = "oc1"
description = "Realm to get DNS records for: e.g. oc1, oc2, etc..."
}

variable "region" {
default = "us-ashburn-1"
description = "Region to get DNS records for: e.g. us-ashburn-1"
}
```

## Requesting a DNS record
0. Remove any Terraform state file that may exist locally.
```shell
rm terraform.tfstate
```

1. Run `terraform plan` and verify that the expected record values are correct.

For the example plan below, note that:
- `domain` has the expected environment (`prod`), region (`us-ashburn-1`), and domain (`oci.oracleiaas.com`) for the realm
- `rdata` has the expected public IP address for control plane load balancer in this region
- `zone_name_or_id` has the expected zone for this region `us-ashburn-1.oci.oracleiaas.com`

Values for `zone_name_or_id`, `domain` and `rdata` will differ for different environments and regions
```
### Example plan for prod environment in realm OC1 and region us-ashburn-1
  + resource "oci_dns_rrset" "project_service_dns_rrset" {
      + compartment_id  = (known after apply)
      + domain          = "prod.control.plane.api.project-service.us-ashburn-1.oci.oracleiaas.com"
      + id              = (known after apply)
      + rtype           = "A"
      + zone_name_or_id = "us-ashburn-1.oci.oracleiaas.com"

      + items {
          + domain        = "prod.control.plane.api.project-service.us-ashburn-1.oci.oracleiaas.com"
          + is_protected  = (known after apply)
          + rdata         = "147.154.12.7"
          + record_hash   = (known after apply)
          + rrset_version = (known after apply)
          + rtype         = "A"
          + ttl           = 900
        }
    }
```

2. Run `terraform apply` and approve to update the DNS record.

## Validate the DNS record
```shell
# The IP address returned by this command should match the public IP address of the control plane 
# load balancer in the region (i.e. the rdata value that was requested)
dig +short <DNS domain that was requested in previous step>
```