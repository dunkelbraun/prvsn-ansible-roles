locals {
  default_labels = {
    "created-by" = "prvsn-hcloud-starter"
  }
  subnet_ip_range = replace(var.network_cidr, ".0.0/16", ".1.0/24")

  server_image = "ubuntu-22.04"

  nat_gateway_server_name = "nat-${replace(lower(var.name), " ", "-")}"
  nat_gateway_private_ip = replace(var.network_cidr, ".0.0/16", ".1.1")

  grafana_private_ip = replace(var.network_cidr, ".0.0/16", ".1.2")
  grafana_server_name = "grafana-${replace(lower(var.name), " ", "-")}"
}
