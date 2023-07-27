output "network" {
  description = "Network (hcloud_network attributes)"
  value = hcloud_network.network
}

output "subnet" {
  description = "Subnet (hcloud_network_subnet attributes)"
  value = hcloud_network_subnet.subnet
}
