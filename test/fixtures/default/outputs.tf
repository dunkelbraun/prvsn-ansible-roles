output "network" {
  description = "Network"
  value = module.default.network
}

output "subnet" {
  description = "Network"
  value = module.default.subnet
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
  value = tolist(module.default.grafana_server.network)[0].ip
}
