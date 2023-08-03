output "network" {
  value = module.default.network
}


output "nat_gateway" {
  value = module.default.nat_gateway
}

output "nat_gateway_ip_address" {
  value = module.default.nat_gateway.ipv4_address
}

output "grafana_server" {
  value = module.default.grafana_server
}

output "grafana_private_ip_address" {
  value = module.default.grafana_server.private_ip
}

output "ssh_traffic_firewall" {
  value = module.default.ssh_traffic_firewall
}

output "private_network_server" {
  value = module.private_network_server.private_network_server
}

output "private_network_server_private_ip_address" {
  value = tolist(module.private_network_server.private_network_server.network)[0].ip
}

output "private_network_server_data_volume" {
  value = module.private_network_server.private_network_server_data_volume
}

output "grafana_url" {
  value = module.grafana_load_balancer.load_balancer_url
}
