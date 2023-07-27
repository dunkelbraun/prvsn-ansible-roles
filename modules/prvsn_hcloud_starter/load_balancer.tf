resource "hcloud_load_balancer" "load_balancer" {
  name               = local.load_balancer_name
  network_zone       = var.network_zone
  load_balancer_type = var.load_balancer_type
}

resource "hcloud_load_balancer_network" "load_balancer" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  subnet_id        = hcloud_network_subnet.subnet.id
}

resource "hcloud_load_balancer_target" "load_balancer_target" {
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  server_id        = hcloud_server.grafana.id
  use_private_ip   = true
}

resource "random_id" "server" {
  byte_length = 8
}

resource "hcloud_managed_certificate" "environment_domain" {
  name         = "${random_id.server.hex}-${var.domain}-cert"
  domain_names = ["${random_id.server.hex}.${var.domain}"]
}

resource "hcloud_load_balancer_service" "load_balancer_service" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  protocol         = "https"
  listen_port      = 443
  destination_port = 3000
  http {
    sticky_sessions = true
    redirect_http   = true
    certificates    = [
      hcloud_managed_certificate.environment_domain.id
    ]
  }
}

data "hetznerdns_zone" "dns_zone" {
    name = var.domain
}

resource "hetznerdns_record" "grafana_load_balancer_record" {
    zone_id = data.hetznerdns_zone.dns_zone.id
    name = "${random_id.server.hex}"
    value = hcloud_load_balancer.load_balancer.ipv4
    type = "A"
    ttl= 60
}
