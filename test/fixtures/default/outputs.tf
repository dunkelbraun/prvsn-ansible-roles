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

output "grafana_load_balancer" {
  value = module.grafana_load_balancer.load_balancer
}

output "grafana_load_balancer_network" {
  value = module.grafana_load_balancer.load_balancer_network
}

output "grafana_load_balancer_targets" {
  value = module.grafana_load_balancer.load_balancer_targets
}

output "grafana_load_balancer_service" {
  value = module.grafana_load_balancer.load_balancer_service
}

output "grafana_load_balancer_record" {
  value = module.grafana_load_balancer.load_balancer_record
}

output "grafana_managed_cerfificate_domain_names" {
  value = module.grafana_load_balancer.managed_cerfificate_domain_names
}

output "grafana_managed_cerfificate_id" {
  value = module.grafana_load_balancer.managed_cerfificate_id
}
