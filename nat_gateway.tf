resource "hcloud_server" "nat_gateway" {
  depends_on = [
    hcloud_network.network,
    hcloud_network_subnet.subnet
  ]

  name        = "nat-${hcloud_network.network.id}"
  server_type = "cx11"
  image       = "ubuntu-22.04"
  ssh_keys    = [ data.hcloud_ssh_key.ssh_key.id ]

  datacenter = random_shuffle.datacenter.result[0]

  keep_disk   = false

  network {
    network_id = hcloud_network.network.id
    ip         = local.nat_gateway_ip
  }

  firewall_ids = [
    hcloud_firewall.ssh_traffic.id
  ]

  labels = {
    "created-by" = "prvsn"
    "role" = "nat"
    "network" = hcloud_network.network.name
  }

  user_data = templatefile("${path.module}/cloud_init_nat_gateway.tftpl", {
    ip_range = local.subnet_ip_range
    loki_ip = local.loki_ip
  })
}

resource "hcloud_network_route" "nat_gateway_route" {
  network_id  = hcloud_network.network.id
  destination = "0.0.0.0/0"
  gateway     = tolist(hcloud_server.nat_gateway.network)[0].ip
}
