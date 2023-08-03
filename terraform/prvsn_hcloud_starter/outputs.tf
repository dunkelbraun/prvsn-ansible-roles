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
    ipv4_address = hcloud_server.nat_gateway.ipv4_address,
    private_ip = tolist(hcloud_server.nat_gateway.network)[0].ip
  }
}

output "grafana_server" {
  description = "Grafana server details"
  value = {
    id = hcloud_server.grafana.id,
    name = hcloud_server.grafana.name,
    network_id = tolist(hcloud_server.grafana.network)[0].network_id,
    private_ip = tolist(hcloud_server.grafana.network)[0].ip,
    ipv4_address = tolist(hcloud_server.grafana.public_net)[0].ipv4,
    ipv6_address = tolist(hcloud_server.grafana.public_net)[0].ipv6,
    backups = hcloud_server.grafana.backups,
    delete_protection = hcloud_server.grafana.delete_protection,
    keep_disk = hcloud_server.grafana.keep_disk,
    server_type = hcloud_server.grafana.server_type,
    location = hcloud_server.grafana.location,
    ssh_keys = hcloud_server.grafana.ssh_keys,
    labels = hcloud_server.grafana.labels,
  }
}
