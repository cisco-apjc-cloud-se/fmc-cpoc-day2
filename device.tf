### Target Device ###
data "fmc_devices" "dmz_group" {
    name = "CPOC-FTDv-1" # Group?
}

### Assign ACL Policy to Device ###
resource "fmc_policy_devices_assignments" "dmz_acp" {
    policy {
        id = fmc_access_policies.dmz_acp.id
        type = fmc_access_policies.dmz_acp.type
    }
    target_devices {
        id = data.fmc_devices.dmz_group.id
        type = data.fmc_devices.dmz_group.type
    }
}

### Assign NAT Policy to Device ###
resource "fmc_policy_devices_assignments" "dmz_nat" {
    policy {
        id = fmc_ftd_nat_policies.dmz_nat.id
        type = fmc_ftd_nat_policies.dmz_nat.type
    }
    target_devices {
        id = data.fmc_devices.dmz_group.id
        type = data.fmc_devices.dmz_group.type
    }
}
