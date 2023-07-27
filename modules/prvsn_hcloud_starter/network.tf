resource "hcloud_network" "network" {
  name                     = var.name
  ip_range                 = var.network_cidr
  delete_protection        = false
  expose_routes_to_vswitch = false
  labels                   = local.default_labels
}

resource "hcloud_network_subnet" "subnet" {
  network_id   = hcloud_network.network.id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = local.subnet_ip_range
  vswitch_id   = null
}
