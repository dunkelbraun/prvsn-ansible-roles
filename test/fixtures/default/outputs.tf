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

output "load_balancer" {
  value = module.default.load_balancer
}

output "load_balancer_network" {
  value = module.default.load_balancer_network
}

output "load_balancer_target" {
  value = module.default.load_balancer_target
}

output "managed_cerfificate_domain_names" {
  value = module.default.managed_cerfificate_domain_names
}

output "managed_cerfificate_name" {
  value = module.default.managed_cerfificate_name
}

output "managed_cerfificate_id" {
  value = module.default.managed_cerfificate_id
}

output "grafana_load_balancer_service" {
  value = module.default.grafana_load_balancer_service
}

output "grafana_load_balancer_record" {
  value = module.default.grafana_load_balancer_record
}
