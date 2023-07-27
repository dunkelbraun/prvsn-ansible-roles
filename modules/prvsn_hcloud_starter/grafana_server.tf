resource "hcloud_server" "grafana" {
  name        = local.grafana_server_name
  server_type = var.grafana_server_type
  image       = "ubuntu-22.04"
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
    roles = {
      "1": [ "prvsn_internal_network_firewall", {} ],
      "2": [ "prvsn_docker", {} ],
      "3": [ "prvsn_promtail", { "prvsn_promtail_loki_server" = local.grafana_private_ip } ],
      "4": [ "prvsn_node_exporter", {} ],
      "5": [ "prvsn_loki", {} ],
      "6": [ "prvsn_prometheus", {
        "prvsn_prometheus_network_name" = replace(hcloud_network.network.name, "-", "_"),
        "prvsn_prometheus_hcloud_read_token" = var.hcloud_read_token
      } ],
      "7": [ "prvsn_grafana_oss", {} ]
    },
    network_gateway = hcloud_network_subnet.subnet.gateway
  })

  provisioner "local-exec" {
    command = templatefile("${path.module}/templates/server_wait_jump_host.tftpl", {
      server_ip = tolist(self.network)[0].ip
      nat_gateway_ip = hcloud_server.nat_gateway.ipv4_address
    })
  }
}
