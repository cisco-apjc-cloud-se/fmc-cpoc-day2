terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "mel-ciscolabs-com"
    workspaces {
      name = "fmc-cpoc-day2"
    }
  }
  required_providers {
    fmc = {
      source = "CiscoDevNet/fmc"
      # version = "0.1.1"
    }
  }
}

### FMC Provider ###
provider "fmc" {
  # Configuration options
  fmc_username              = var.fmc_user      # Passed from Workspace Variable
  fmc_password              = var.fmc_password  # Passed from Workspace Variable
  fmc_host                  = var.fmc_server    # Passed from Workspace Variable
  fmc_insecure_skip_verify  = true
}

### Firewall Data Source ###
data "fmc_devices" "cpoc-ftdv-1" {
    name = "CPOC-FTDv-1"
}

data "fmc_security_zones" "inside" {
    name = "INSIDE"
}

data "fmc_security_zones" "internet" {
    name = "INTERNET"
}
