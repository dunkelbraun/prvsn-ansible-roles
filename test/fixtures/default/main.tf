
module "default" {
  source  = "../../../terraform/prvsn_hcloud_starter"
  hcloud_read_token = var.hcloud_read_token
  stack = var.stack
}
