# Server

resource "hcloud_server" "grafana" {
  name        = local.grafana_server_name
  server_type = "cpx21"
  image       = "ubuntu-22.04"
  ssh_keys    = [ data.hcloud_ssh_key.ssh_key.id ]

  datacenter = random_shuffle.datacenter.result[0]

  keep_disk   = true

  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }

  network {
    network_id = hcloud_network.network.id
    ip         = local.loki_ip
  }

  labels = merge(local.default_labels, {
    "created-by" = "prvsn"
    "role" = "grafana",
    "gateway" = hcloud_network_route.nat_gateway_route.gateway,
    "network" = hcloud_network.network.name,
    "subdomain" = local.grafana_load_balancer["grafana"].subdomain,
  })

  user_data = templatefile("${path.module}/cloud_init_grafana.tftpl", {
    network_gateway = hcloud_network_subnet.subnet.gateway
    hcloud_read_token = var.hcloud_read_token
    hcloud_network_name = lower(hcloud_network.network.name)
  })
}
