resource "hcloud_load_balancer" "load_balancer" {
  depends_on = [
    hcloud_server.grafana,
    hcloud_server.nat_gateway
  ]

  for_each = toset([for key, lb in local.all_load_balancers : key])

  name               = local.all_load_balancers[each.key]["subdomain"]
  network_zone       = var.stack.zone
  load_balancer_type = local.all_load_balancers[each.key]["type"]
}

resource "hcloud_load_balancer_network" "load_balancer" {
  for_each = toset([for key, lb in local.all_load_balancers : key])

  load_balancer_id = hcloud_load_balancer.load_balancer[each.key].id
  subnet_id        = hcloud_network_subnet.subnet.id
}

resource "hcloud_managed_certificate" "certificate" {
  for_each = toset([for key, lb in local.all_load_balancers : key])

  name         = "${var.stack.domain}-${local.all_load_balancers[each.key]["subdomain"]}-lb"
  domain_names = ["${local.all_load_balancers[each.key]["subdomain"]}.${var.stack.domain}"]
}

resource "hcloud_load_balancer_service" "service" {
  for_each = toset([for key, lb in local.all_load_balancers : key])

  load_balancer_id = hcloud_load_balancer.load_balancer[each.key].id
  protocol         = "https"
  listen_port      = 443
  destination_port = local.all_load_balancers[each.key]["target_port"]
  http {
    sticky_sessions = true
    redirect_http   = true
    certificates    = [
      hcloud_managed_certificate.certificate[each.key].id
    ]
  }
}

resource "hetznerdns_record" "record" {
  for_each = toset([for key, lb in local.all_load_balancers : key])

  zone_id = data.hetznerdns_zone.dns_zone.id
  name = local.all_load_balancers[each.key]["subdomain"]
  value = hcloud_load_balancer.load_balancer[each.key].ipv4
  type = "A"
  ttl= 60
}

resource "hcloud_load_balancer_target" "target" {
  for_each = toset([for key, lb in local.all_load_balancers : key])

  depends_on = [
    hcloud_load_balancer_network.load_balancer,
    hcloud_load_balancer_service.service
  ]

  type             = "label_selector"
  load_balancer_id = hcloud_load_balancer.load_balancer[each.key].id
  label_selector   = "subdomain=${local.all_load_balancers[each.key]["subdomain"]}"
  use_private_ip   = true
}
