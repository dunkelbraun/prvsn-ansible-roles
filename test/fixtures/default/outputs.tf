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

output "private_network_server_ip" {
  value = module.private_network_server.private_network_server.ip
}

output "grafana_url" {
  value = module.grafana_load_balancer.load_balancer_url
}
