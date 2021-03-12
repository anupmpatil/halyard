# Requesting DNS records for SPLAT onboarding

This directory contains Terraform configuration for requesting DNS records for project service.
DNS records must be requested for every region that service is deployed to.

Note that this process is needed because DNS records cannot be currently requested through Shepherd.
Once Shepherd allows DNS record creation, this process should be handled in Shepherd configs.

## Prerequisites
0. Install latest Terraform version (v0.12 and above)

1. Ensure that you have a BOAT account for the realm that you are requesting.

You can follow this [guide](https://confluence.oci.oraclecorp.com/display/DNS/SSID%3A+Adding+API+Keys+to+Your+BOAT+User)
to set up your BOAT account.

2. Setup environment variables for Terraform to use your BOAT user credentials and access the region

Create a file named `terraform.tfvars` in this directory with the following content. Make sure values are in double-quotes.
```
# BOAT credentials for your realm
boat_user_ocid="<BOAT user ocid>"
boat_tenancy_ocid="<BOAT tenancy ocid>"
boat_fingerprint="<BOAT user fingerprint>"
boat_private_key_path="<path to your private key for this BOAT user>"

# Region, realm, and environment settings for your DNS records
region="<region, e.g. "us-ashburn-1">"
realm="<realm, e.g. "oc1">"
environment="<environment, e.g. "prod", "beta", or "preprod">"
```

3. Initialize Terraform in this directory
```shell
terraform init
```

## Requesting DNS records
0. Confirm again that your `region`, `realm`, and `environment` values in `terraform.tfvars` file are correct 

1. Remove any Terraform state file that may exist locally.
```shell
rm terraform.tfstate
```

2. Check whether your region already has an associated DNS record

Run the following command to get current records for the region
```shell
terraform apply -target=data.oci_dns_rrset.current_state -auto-approve
```

You will see output like the following. Note how the `items` are empty. This means that no records
currently exist for this domain.
```
  "prod.control.plane.api.project-service.us-ashburn-1.oci.oracleiaas.com_A" = {
    "compartment_id" = tostring(null)
    "domain" = "prod.control.plane.api.clouddeploy.us-ashburn-1.oci.oracleiaas.com"
    "id" = "DnsRrsetDataSource-321659983"
    "items" = tolist([])
    "rtype" = "A"
    "scope" = tostring(null)
    "view_id" = tostring(null)
    "zone_name_or_id" = "us-ashburn-1.oci.oracleiaas.com"
    "zone_version" = tostring(null)
  }
  "prod.management.plane.api.project-service.us-ashburn-1.oci.oracleiaas.com_A" = {
    "compartment_id" = tostring(null)
    "domain" = "prod.management.plane.api.clouddeploy.us-ashburn-1.oci.oracleiaas.com"
    "id" = "DnsRrsetDataSource-674974716"
    "items" = tolist([])
    "rtype" = "A"
    "scope" = tostring(null)
    "view_id" = tostring(null)
    "zone_name_or_id" = "us-ashburn-1.oci.oracleiaas.com"
    "zone_version" = tostring(null)
  }
}
```

3. Run a plan and verify that the records to be created are correct.

Run the following command to get the Terraform plan for the record to create
```shell
terraform plan -target=oci_dns_rrset.deploy_service_dns_rrset
```

For the example plan below, note that:
- `domain` has the expected environment (`prod`), region (`us-ashburn-1`), and domain (`oci.oracleiaas.com`) for the realm
- `rdata` has the expected public IP address for control plane load balancer in this region
- `zone_name_or_id` has the expected zone for this region `us-ashburn-1.oci.oracleiaas.com`

Values for `zone_name_or_id`, `domain` and `rdata` will differ for different environments and regions
```
### Example plan for prod environment in realm OC1 and region us-ashburn-1
  # oci_dns_rrset.deploy_service_dns_rrset["prod.control.plane.api.clouddeploy.us-ashburn-1.oci.oracleiaas.com_A"] will be created
  + resource "oci_dns_rrset" "deploy_service_dns_rrset" {
      + compartment_id  = (known after apply)
      + domain          = "prod.control.plane.api.clouddeploy.us-ashburn-1.oci.oracleiaas.com"
      + id              = (known after apply)
      + rtype           = "A"
      + zone_name_or_id = "us-ashburn-1.oci.oracleiaas.com"

      + items {
          + domain        = "prod.control.plane.api.clouddeploy.us-ashburn-1.oci.oracleiaas.com"
          + is_protected  = (known after apply)
          + rdata         = "147.154.4.216"
          + record_hash   = (known after apply)
          + rrset_version = (known after apply)
          + rtype         = "A"
          + ttl           = 900
        }
    }

  # oci_dns_rrset.deploy_service_dns_rrset["prod.management.plane.api.clouddeploy.us-ashburn-1.oci.oracleiaas.com_A"] will be created
  + resource "oci_dns_rrset" "deploy_service_dns_rrset" {
      + compartment_id  = (known after apply)
      + domain          = "prod.management.plane.api.clouddeploy.us-ashburn-1.oci.oracleiaas.com"
      + id              = (known after apply)
      + rtype           = "A"
      + zone_name_or_id = "us-ashburn-1.oci.oracleiaas.com"

      + items {
          + domain        = "prod.management.plane.api.clouddeploy.us-ashburn-1.oci.oracleiaas.com"
          + is_protected  = (known after apply)
          + rdata         = "147.154.8.89"
          + record_hash   = (known after apply)
          + rrset_version = (known after apply)
          + rtype         = "A"
          + ttl           = 900
        }
    }
```

4. Create the requested DNS records 

Run following command to create the records
```shell
terraform apply -target=oci_dns_rrset.deploy_service_dns_rrset
# Type 'yes' when prompted to approve the DNS record.
```

5. Check that the DNS record was created as expected

Run the following command and confirm that the `items` are no longer empty and contain the expected DNS records.
```shell
terraform apply -target=data.oci_dns_rrset.current_state -auto-approve
```

6. To request records for another region, realm, or environment; go back to step 0. 


## Validate the DNS record
```shell
# The IP address returned by this command should match the public IP address of the control plane 
# load balancer in the region (i.e. the rdata value that was requested)
dig +short <DNS domain that was requested in previous step>
```