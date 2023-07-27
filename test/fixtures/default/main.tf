module "default" {
  source                   = "../../../modules/prvsn_hcloud_starter"
  name                     = var.name
  network_zone             = var.network_zone
  network_cidr             = var.network_cidr
}
