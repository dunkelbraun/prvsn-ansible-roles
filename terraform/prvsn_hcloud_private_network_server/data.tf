data "hcloud_network" "network" {
  name = var.network_name
}

data "hcloud_image" "base_server_snapshot" {
  with_selector = "role=base-server,network_name=${local.network_name}"
  most_recent = true
}
