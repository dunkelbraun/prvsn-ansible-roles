data "hcloud_ssh_key" "ssh_key" {
  name = var.stack.ssh_key_name
}

data "hetznerdns_zone" "dns_zone" {
    name = var.stack.domain
}
