### New NAT Policy ###
resource "fmc_ftd_nat_policies" "dmz_nat" {
    name = "CPOC DMZ NAT Policy"
    description = "CPOC DMZ NAT Policy built by Terraform"
}

data "fmc_network_objects" "n_100_64_0_0_16" {
    name = "N-100.64.0.0-16"
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
        id = data.fmc_network_objects.n_100_64_0_0_16.id
        type = data.fmc_network_objects.n_100_64_0_0_16.type
    }
    translated_network_is_destination_interface = true
    translate_dns = false
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
