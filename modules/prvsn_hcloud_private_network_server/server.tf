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
    network_id = var.network_id
  }

  labels = {
    "created-by" = "prvsn-hcloud-starter"
    "role" = "server",
  }

  user_data = templatefile("${path.module}/templates/cloud_init.tftpl", {
    roles = {
      "1": [ "prvsn_internal_network_firewall", {} ],
      "2": [ "prvsn_docker", {} ],
      "3": [ "prvsn_promtail", { "prvsn_promtail_loki_server" = var.grafana_private_ip } ],
      "4": [ "prvsn_node_exporter", {} ]
    },
    network_gateway = var.network_gateway,
    volume_linux_device: hcloud_volume.data.linux_device
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

resource "null_resource" "wait_for_cloud_init_done" {
  provisioner "local-exec" {
    command = "sleep 300"
  }

  provisioner "local-exec" {
    command = templatefile("${path.module}/templates/wait_cloud_init_done.tftpl", {
      server_ip = tolist(hcloud_server.server.network)[0].ip
      nat_gateway_ip = var.nat_gateway_ipv4_address
    })
  }
}
