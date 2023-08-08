output "nat_gateway_ip_address" {
  value = module.default.nat_gateway.ipv4_address
}

output "grafana_private_ip_address" {
  value = module.default.grafana_server.private_ip
}

output "grafana_url" {
  value = module.default.grafana_url
}

output "private_network_server_ip" {
  value = module.default.server_ips["web-1"]
}

output "private_network_server_witohut_volume_ip" {
  value = module.default.server_ips["web-2"]
}
