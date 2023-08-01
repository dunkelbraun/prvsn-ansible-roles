output "load_balancer" {
  description = "Load Balancer (hcloud_load_balancer attributes)"
  value = hcloud_load_balancer.load_balancer
}

output "load_balancer_network" {
  description = "Load Balancer Network (hcloud_load_balancer_network attributes)"
  value = hcloud_load_balancer_network.load_balancer
}

output "load_balancer_targets" {
  description = "Load Balancer Target (hcloud_load_balancer_target attributes)"
  value = hcloud_load_balancer_target.target[*]
}

output "load_balancer_service" {
  description = "Load Balancer Service (hcloud_load_balancer_service attributes)"
  value = hcloud_load_balancer_service.service
}

output "load_balancer_record" {
  description = "Load Balancer Record (hetznerdns_record attributes)"
  value = hetznerdns_record.record
}

output "managed_cerfificate" {
  description = "Managed Certificate"
  value = hcloud_managed_certificate.certificate
}
