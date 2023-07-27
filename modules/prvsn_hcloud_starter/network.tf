resource "hcloud_network" "network" {
  name                     = var.name
  ip_range                 = var.network_cidr
  delete_protection        = false
  expose_routes_to_vswitch = false
  labels                   = {
    "created-by" = "prvsn-hcloud-starter"
  }
}

resource "hcloud_network_subnet" "subnet" {
  network_id   = hcloud_network.network.id
  type         = "cloud"
  network_zone = var.network_zone
  ip_range     = replace(var.network_cidr, ".0.0/16", ".1.0/24")
  vswitch_id   = null
}
