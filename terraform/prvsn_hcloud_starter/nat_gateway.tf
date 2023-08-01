resource "hcloud_server" "nat_gateway" {
  depends_on = [ hcloud_network_subnet.subnet ]

  name        = local.nat_gateway_server_name
  server_type = var.nat_gateway_server_type
  image       = data.hcloud_image.base_server_snapshot.id
  ssh_keys    = [ var.ssh_key_id ]

  datacenter = random_shuffle.datacenter.result[0]

  keep_disk   = false

  network {
    network_id = hcloud_network.network.id
    ip         = local.nat_gateway_private_ip
  }

  labels = merge(local.default_labels, {
    "role" = "nat"
    "network" = hcloud_network.network.name
  })

  user_data = templatefile("${path.module}/templates/nat_gateway_cloud_init.tftpl", {
    ip_range = hcloud_network_subnet.subnet.ip_range
  })
}

resource "hcloud_network_route" "nat_gateway_route" {
  network_id  = hcloud_network.network.id
  destination = "0.0.0.0/0"
  gateway     = tolist(hcloud_server.nat_gateway.network)[0].ip
}
