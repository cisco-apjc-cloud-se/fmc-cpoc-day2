### Target Device ###
data "fmc_devices" "dmz" {
    name = "CPOC-FTDv-1" # Group?
}

### Assign ACL Policy to Device ###
resource "fmc_policy_devices_assignments" "dmz_acp" {
    policy {
        id = fmc_access_policies.dmz_acp.id
        type = fmc_access_policies.dmz_acp.type
    }
    target_devices {
        id = data.fmc_devices.dmz.id
        type = data.fmc_devices.dmz.type
    }
}

### Assign NAT Policy to Device ###
resource "fmc_policy_devices_assignments" "dmz_nat" {
    policy {
        id = fmc_ftd_nat_policies.dmz_nat.id
        type = fmc_ftd_nat_policies.dmz_nat.type
    }
    target_devices {
        id = data.fmc_devices.dmz.id
        type = data.fmc_devices.dmz.type
    }
}

### Trigger Deploy ###
resource "fmc_ftd_deploy" "deploy" {
    device = data.fmc_devices.dmz.id
    ignore_warning = true
    force_deploy = true

    depends_on = [
        fmc_access_policies.dmz_acp,
        fmc_ftd_nat_policies.dmz_nat,
        fmc_ftd_manualnat_rules.internet_snat,
        fmc_ftd_manualnat_rules.iks1_ingress,
        fmc_access_rules.internet_ingress,
    ]
}
