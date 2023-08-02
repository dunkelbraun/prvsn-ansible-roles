module "default" {
  source                   = "../../../terraform/prvsn_hcloud_starter"
  name                     = var.name
  network_zone             = var.network_zone
  network_cidr             = var.network_cidr
  ssh_key_id               = var.ssh_key_id
  hcloud_read_token        = "abcde"
}

module "grafana_load_balancer" {
  source              = "../../../terraform/prvsn_hcloud_load_balancer"
  load_balancer_type  = "small"
  network_zone        = var.network_zone
  destination_port    = "3000"
  subnet_id           = module.default.network.subnet.id
  domain              = "prvsn.dev"
  subdomain           = "grafana-${var.name}"
  target_server_ids   = [module.default.grafana_server.id]
}

module "private_network_server" {
  depends_on = [module.default]
  source                   = "../../../terraform/prvsn_hcloud_private_network_server"
  name                     = "test-server-${var.network_zone}"
  server_type              = "medium"
  network_zone             = var.network_zone
  network_name             = module.default.network.name
  ssh_key_id               = var.ssh_key_id
  data_volume_size         = 30
  grafana_private_ip       = tolist(module.default.grafana_server.network)[0].ip
  network_gateway          = module.default.network.subnet.gateway
  nat_gateway_ipv4_address =  module.default.nat_gateway.ipv4_address
}


