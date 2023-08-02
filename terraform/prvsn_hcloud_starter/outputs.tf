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
  description = "NAT Gateway details"
  value = {
    name = hcloud_server.nat_gateway.name,
    keep_disk = hcloud_server.nat_gateway.keep_disk,
    backups = hcloud_server.nat_gateway.backups,
    delete_protection = hcloud_server.nat_gateway.delete_protection,
    datacenter = hcloud_server.nat_gateway.datacenter,
    network_id = tolist(hcloud_server.nat_gateway.network)[0].network_id,
    ipv4_address = hcloud_server.nat_gateway.ipv4_address,
    private_ip = tolist(hcloud_server.nat_gateway.network)[0].ip,
    server_type = hcloud_server.nat_gateway.server_type,
    firewall_ids = hcloud_server.nat_gateway.firewall_ids,
  }
}

output "grafana_server" {
  description = "Grafana server (hcloud_server attributes)"
  value = hcloud_server.grafana
}

output "ssh_traffic_firewall" {
  description = "SSH traffic firewall (hcloud_firewall attributes)"
  value = hcloud_firewall.ssh_traffic
}
