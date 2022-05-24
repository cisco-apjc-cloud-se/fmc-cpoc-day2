### Common Objects ###
data "fmc_network_objects" "any_ipv4" {
  name = "any-ipv4"
}

### Host Objects ###
resource "fmc_host_objects" "iks1_ingress_int" {
    name        = "iks1_ingress_int"
    value       = "100.64.64.26"
    description = "IKS Cluster 1 - K8S Ingress Loadbalancer Inside IP"
}

resource "fmc_host_objects" "iks1_ingress_pub" {
    name        = "iks1_ingress_pub"
    value       = "64.104.255.140"
    description = "IKS Cluster 1 - K8S Ingress Loadbalancer Public IP"
}
