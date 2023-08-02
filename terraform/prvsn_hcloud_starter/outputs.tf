output "network" {
  description = "Network Details"
  value = {
    id = hcloud_network.network.id,
    name = hcloud_network.network.name,
    ip_range = hcloud_network.network.ip_range,
    delete_protection = hcloud_network.network.delete_protection,
    expose_routes_to_vswitch = hcloud_network.network.expose_routes_to_vswitch,
    labels = hcloud_network.network.labels
    subnet = {
      id = hcloud_network_subnet.subnet.id,
      ip_range = hcloud_network_subnet.subnet.ip_range,
      network_zone = hcloud_network_subnet.subnet.network_zone,
      gateway = hcloud_network_subnet.subnet.gateway
    }
  }
}

output "nat_gateway" {
  description = "NAT Gateway server (hcloud_server attributes)"
  value = hcloud_server.nat_gateway
}

output "grafana_server" {
  description = "Grafana server (hcloud_server attributes)"
  value = hcloud_server.grafana
}

output "ssh_traffic_firewall" {
  description = "SSH traffic firewall (hcloud_firewall attributes)"
  value = hcloud_firewall.ssh_traffic
}
