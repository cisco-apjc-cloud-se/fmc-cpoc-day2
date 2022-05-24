### New NAT Policy ###
resource "fmc_ftd_nat_policies" "dmz_nat" {
  name = "CPOC DMZ NAT Policy"
  description = "CPOC DMZ NAT Policy built by Terraform"
}

data "fmc_network_objects" "any_ipv4" {
  name = "any-ipv4"
}

resource "fmc_ftd_manualnat_rules" "internet_snat" {
  nat_policy = fmc_ftd_nat_policies.dmz_nat.id
  description = "Internet Egress Source NAT to Interface"
  nat_type = "dynamic"
  section = "after_auto"
  # target_index = 1
  source_interface {
    id = data.fmc_security_zones.inside.id
    type = data.fmc_security_zones.inside.type
  }
  destination_interface {
    id = data.fmc_security_zones.internet.id
    type = data.fmc_security_zones.internet.type
  }
  original_source {
    id = data.fmc_network_objects.any_ipv4.id
    type = data.fmc_network_objects.any_ipv4.type
  }
  # translated_source {
  #   id = data.fmc_security_zones.internet.id
  #   type = data.fmc_security_zones.internet.type
  # }
  interface_in_translated_source = true
  translate_dns = false
  unidirectional = true ### Required for SNAT only
}

resource "fmc_ftd_manualnat_rules" "iks1_ingress" {
  nat_policy = fmc_ftd_nat_policies.dmz_nat.id
  description = "1:1 NAT for IKS K8S Ingress Loadbalancer"
  nat_type = "dynamic"
  section = "after_auto"
  # target_index = 1
  source_interface {
    id = data.fmc_security_zones.inside.id
    type = data.fmc_security_zones.inside.type
  }
  destination_interface {
    id = data.fmc_security_zones.internet.id
    type = data.fmc_security_zones.internet.type
  }
  original_source {
    id = fmc_host_objects.iks1_ingress_int.id
    type = fmc_host_objects.iks1_ingress_int.type
  }
  translated_source {
    id = fmc_host_objects.iks1_ingress_pub.id
    type = fmc_host_objects.iks1_ingress_pub.type
  }
  interface_in_translated_source = false
  translate_dns = false
  unidirectional = false ### 1:1 NAT
}

# resource "fmc_ftd_autonat_rules" "new_rule_3" {
#     nat_policy = fmc_ftd_nat_policies.nat_policy.id
#     description = "Testing Auto NAT pub-priv without PAT pool"
#     nat_type = "dynamic"
#     source_interface {
#         id = data.fmc_security_zones.outside.id
#         # type = data.fmc_security_zones.outside.type
#     }
#     destination_interface {
#         id = data.fmc_security_zones.outside.id
#         # type = data.fmc_security_zones.outside.type
#     }
#     original_network {
#         id = data.fmc_host_objects.CUCMPubDR.id
#         # type = data.fmc_host_objects.CUCMPubDR.type
#     }
#     pat_options {
#         interface_pat = true
#         round_robin = true
#     }
#     ipv6 = true
# }
