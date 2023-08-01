locals {
  hetzner_local_balancer_types = {
    "small"   = "lb11",
    "medium"  = "lb21",
    "large"   = "lb31"
  }
  load_balancer_name = "${var.subdomain}-${var.domain}-lb"
  load_balancer_type = local.hetzner_local_balancer_types[var.load_balancer_type]
}
