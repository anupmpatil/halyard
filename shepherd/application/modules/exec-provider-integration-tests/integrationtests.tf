resource "exec_execution" "deployment_service_integration_tests" {
  ad             = var.availability_domains[0]
  compartment_id = var.compartment_id

  execution_details {
    pwd = "/etc/runit/artifacts/deployment-service-integration-test"
    cmd = [
      "bash",
      "-c",
    "./run.sh --runjar"]

    container {
      docker {
        uri = var.artifact_versions[var.artifact_name].uri
      }
    }
  }

  outputs_to_download {
    filename_in_exec = "user.log"
    local_filename   = "outputs/user.log"
  }
}