output "network" {
  description = "Network Details"
  value = {
    id = hcloud_network.network.id,
    name = hcloud_network.network.name,
    ip_range = hcloud_network.network.ip_range,
    labels = hcloud_network.network.labels,
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
    private_ip = tolist(hcloud_server.grafana.network)[0].ip,
    labels = hcloud_server.grafana.labels,
  }
}

output "server_ips" {
  description = "Server IPs"
  value = {for key, server in hcloud_server.server: key => tolist(server.network)[0].ip }
}

output "grafana_url" {
  description = "Grafana URL"
  value = "https://${local.grafana_load_balancer["grafana"].subdomain}.${var.stack.domain}"
}
