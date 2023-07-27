output "network" {
  description = "Network (hcloud_network attributes)"
  value = hcloud_network.network
}

output "subnet" {
  description = "Subnet (hcloud_network_subnet attributes)"
  value = hcloud_network_subnet.subnet
}

output "nat_gateway" {
  description = "NAT Gateway server (hcloud_server attributes)"
  value = hcloud_server.nat_gateway
}

output "grafana_server" {
  description = "Grafana server (hcloud_server attributes)"
  value = hcloud_server.grafana
}

output "load_balancer" {
  description = "Load Balancer (hcloud_load_balancer attributes)"
  value = hcloud_load_balancer.load_balancer
}
output "load_balancer_network" {
  description = "Load Balancer Network (hcloud_load_balancer_network attributes)"
  value = hcloud_load_balancer_network.load_balancer
}

output "load_balancer_target" {
  description = "Load Balancer Target (hcloud_load_balancer_target attributes)"
  value = hcloud_load_balancer_target.load_balancer_target
}

output "managed_cerfificate_domain_names" {
  description = "Managed Certificate Domain Names"
  value = hcloud_managed_certificate.environment_domain.domain_names
}

output "managed_cerfificate_name" {
  description = "Managed Certificate Name"
  value = hcloud_managed_certificate.environment_domain.name
}

output "managed_cerfificate_id" {
  description = "Managed Certificate ID"
  value = hcloud_managed_certificate.environment_domain.id
}

output "grafana_load_balancer_service" {
  description = "Grafana Load Balancer Service (hcloud_load_balancer_service attributes)"
  value = hcloud_load_balancer_service.load_balancer_service
}

output "grafana_load_balancer_record" {
  description = "Grafana Load Balancer Record (hetznerdns_record attributes)"
  value = hetznerdns_record.grafana_load_balancer_record
}
