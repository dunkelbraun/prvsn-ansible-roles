output "network" {
  description = "Network (hcloud_network attributes)"
  value = hcloud_network.network
}

output "subnet" {
  description = "Subnet (hcloud_network_subnet attributes)"
  value = hcloud_network_subnet.subnet
}

output "nat_gateway" {
  description = "NAT Gateway server (hcloud_server attributes)"
  value = hcloud_server.nat_gateway
}

output "grafana_server" {
  description = "Grafana server (hcloud_server attributes)"
  value = hcloud_server.grafana
}
