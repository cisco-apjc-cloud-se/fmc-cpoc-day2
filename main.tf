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

### New Access Policy ###
resource "fmc_access_policies" "dmz-acp" {
  name = "CPOC DMZ Access Policy built by Terraform"
  default_action = "block" # permit
  # default_action_base_intrusion_policy_id = data.fmc_ips_policies.ips_policy.id
  default_action_send_events_to_fmc = "true"
  default_action_log_begin          = "true"
  default_action_log_end            = "true"
  # default_action_syslog_config_id  = data.fmc_syslog_alerts.syslog_alert.id
}

resource "fmc_access_rules" "inside-internet" {
  acp                 = fmc_access_policies.dmz-acp.id
  section             = "mandatory"
  name                = "Inside-Internet"
  action              = "allow"
  enabled             = true
  # enable_syslog = true
  # syslog_severity = "alert"
  send_events_to_fmc  = true
  log_files           = false
  log_end             = true
  # ips_policy = data.fmc_ips_policies.ips_policy.id
  # syslog_config = data.fmc_syslog_alerts.syslog_alert.id
  # new_comments = [ "New", "comment" ]

  source_zones {
    source_zone {
      id    = data.fmc_security_zones.inside.id
      type  = data.fmc_security_zones.inside.type
    }
  }
  destination_zones {
    destination_zone {
      id    = data.fmc_security_zones.internet.id
      type  = data.fmc_security_zones.internet.type
    }
  }
}

resource "fmc_access_rules" "inside-inside" {
  acp                 = fmc_access_policies.dmz-acp.id
  section             = "mandatory"
  name                = "Inside-Inside"
  action              = "allow"
  enabled             = true
  # enable_syslog = true
  # syslog_severity = "alert"
  send_events_to_fmc  = true
  log_files           = false
  log_end             = true
  # ips_policy = data.fmc_ips_policies.ips_policy.id
  # syslog_config = data.fmc_syslog_alerts.syslog_alert.id
  # new_comments = [ "New", "comment" ]

  source_zones {
    source_zone {
      id    = data.fmc_security_zones.inside.id
      type  = data.fmc_security_zones.inside.type
    }
  }
  destination_zones {
    destination_zone {
      id    = data.fmc_security_zones.inside.id
      type  = data.fmc_security_zones.inside.type
    }
  }
}
