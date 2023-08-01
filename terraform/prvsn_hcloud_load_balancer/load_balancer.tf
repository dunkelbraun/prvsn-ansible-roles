resource "hcloud_load_balancer" "load_balancer" {
  name               = local.load_balancer_name
  network_zone       = var.network_zone
  load_balancer_type = local.load_balancer_type
}

resource "hcloud_load_balancer_network" "load_balancer" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  subnet_id        = var.subnet_id
}

resource "hcloud_load_balancer_target" "target" {
  count            = length(var.target_server_ids)
  type             = "server"
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  server_id        = var.target_server_ids[count.index]
  use_private_ip   = true
}

resource "hcloud_load_balancer_service" "service" {
  load_balancer_id = hcloud_load_balancer.load_balancer.id
  protocol         = "https"
  listen_port      = 443
  destination_port = var.destination_port
  http {
    sticky_sessions = true
    redirect_http   = true
    certificates    = [
      hcloud_managed_certificate.certificate.id
    ]
  }
}

resource "hcloud_managed_certificate" "certificate" {
  name         = "${var.domain}-${var.subdomain}-lb"
  domain_names = ["${var.subdomain}.${var.domain}"]
}

resource "hetznerdns_record" "record" {
    zone_id = data.hetznerdns_zone.dns_zone.id
    name = var.subdomain
    value = hcloud_load_balancer.load_balancer.ipv4
    type = "A"
    ttl= 60
}
