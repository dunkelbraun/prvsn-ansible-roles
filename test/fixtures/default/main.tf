locals {
  stack   = {
    name = "test_starter_stack"
    network_cidr = "10.1.0.0/16"
    zone = "eu-central"
    ssh_key_name = "default-key"
    domain = "prvsn.dev"

    servers = [
      {
        name = "web-1"
        type = "cpx11"
        data_volume_size = 10
      },
      {
        name = "web-2"
        type = "cpx11"
      },
    ],
    load_balancers = [
      {
        type           = "lb11"
        subdomain      = var.www_subdomain
        target_port    = 3000
        target_servers = [
          "web-1"
        ]
      }
    ]
  }
}

module "default" {
  source  = "../../../"
  hcloud_read_token = var.hcloud_read_token
  stack = local.stack
}
