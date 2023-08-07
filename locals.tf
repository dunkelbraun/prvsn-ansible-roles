resource "random_id" "subdomain" {
  count = startswith(terraform.workspace, "kitchen-terraform") ? 1 : 0
  byte_length = 4
}

locals {
  default_labels = {
    "created-by" = "prvsn"
  }
  subnet_ip_range = replace(var.stack.network_cidr, ".0.0/16", ".1.0/24")
  nat_gateway_ip  = replace(var.stack.network_cidr, ".0.0/16", ".1.1")
  loki_ip         = replace(var.stack.network_cidr, ".0.0/16", ".1.2")

  grafana_server_name = "grafana-${replace(var.stack.name, "_", "-")}"

  server_map = { for server in var.stack.servers : server.name => server }

  grafana_load_balancer = {
    grafana = {
      subdomain       = startswith(terraform.workspace, "kitchen-terraform") ? random_id.subdomain[0].hex : "grafana"
      target_port     = 3000
      type            = "lb11"
      target_servers  = tolist([
        local.grafana_server_name,
      ])
    }
  }

  load_balancers_map = { for lb in var.stack.load_balancers : lb.subdomain => lb }
  all_load_balancers = merge(local.grafana_load_balancer, local.load_balancers_map)

  servers_map = { for server in var.stack.servers : server.name => server }
  target_servers_to_lb = merge([
    for lb_key, lb in local.load_balancers_map: {
      for server in lb.target_servers:
        server => lb_key
    }
  ]...)
}

