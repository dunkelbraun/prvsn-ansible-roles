resource "hcloud_server" "grafana" {
  name        = local.grafana_server_name
  server_type = var.grafana_server_type
  image       = data.hcloud_image.grafana_server_snapshot.id
  ssh_keys    = [ var.ssh_key_id ]

  datacenter = random_shuffle.datacenter.result[0]

  keep_disk   = true

  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }

  network {
    network_id = hcloud_network.network.id
    ip         = local.grafana_private_ip
  }

  labels = merge(local.default_labels, {
    "role" = "grafana",
    "gateway" = hcloud_network_route.nat_gateway_route.gateway,
    "network" = hcloud_network.network.name
  })

  user_data = templatefile("${path.module}/templates/grafana_cloud_init.tftpl", {
    network_gateway = hcloud_network_subnet.subnet.gateway
  })
}
