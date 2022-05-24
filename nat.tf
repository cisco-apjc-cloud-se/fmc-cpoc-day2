### New NAT Policy ###
resource "fmc_ftd_nat_policies" "dmz_nat" {
    name = "CPOC DMZ NAT Policy"
    description = "CPOC DMZ NAT Policy built by Terraform"
}

data "fmc_network_objects" "any_ipv4" {
    name = "any-ipv4"
}

resource "fmc_ftd_autonat_rules" "internt_snat" {
    nat_policy = fmc_ftd_nat_policies.dmz_nat.id
    description = "Internet Egress Source NAT to Interface"
    nat_type = "dynamic"
    source_interface {
        id = data.fmc_security_zones.inside.id
        type = data.fmc_security_zones.inside.type
    }
    destination_interface {
        id = data.fmc_security_zones.internet.id
        type = data.fmc_security_zones.internet.type
    }
    original_network {
        id = data.fmc_network_objects.any_ipv4.id
        type = data.fmc_network_objects.any_ipv4.type
    }
    translated_network_is_destination_interface = true
    # pat_options {
    #     pat_pool_address {
    #         id = data.fmc_network_objects.private.id
    #         type = data.fmc_network_objects.private.type
    #     }
    #     extended_pat_table = true
    #     round_robin = true
    # }
    # ipv6 = true
}
