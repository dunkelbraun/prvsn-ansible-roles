resource "hcloud_server" "server" {
  name        = var.name
  server_type = local.hetzner_server_types[var.server_type]
  image       = "ubuntu-22.04"
  ssh_keys    = [ var.ssh_key_id ]

  location = local.location
  keep_disk   = true

  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }

  network {
    network_id = local.network_id
  }

  labels = {
    "created-by" = "prvsn-hcloud-starter"
    "role" = "server",
  }

  user_data = templatefile("${path.module}/templates/cloud_init.tftpl", {
    network_gateway = var.network_gateway,
    volume_linux_device = hcloud_volume.data.linux_device
    loki_ip = replace(var.network_gateway, ".0.1", ".1.2")
  })

  lifecycle {
    ignore_changes = [
      # Ignore changes to network.
      # We let an IP address to be assigned automatically. Terraform will assume the server needs to be recreated
      # on update, since the IP address was not specified in the network block.
      network
    ]
  }
}
