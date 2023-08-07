
module "default" {
  source  = "../../../"
  hcloud_read_token = var.hcloud_read_token
  stack = var.stack
}
