variable "hcloud_token" {
  type    = string
  default = "${env("HCLOUD_TOKEN")}"
}

variable "loki_server_ip" {
  type    = string
}

variable "internal_network_cidr" {
  type    = string
}

variable "environment" {
  type    = string
  default = "production"
}

variable "network_name" {
  type    = string
}

variable "version" {
  type    = string
  default = "0.1.0"
}

source "hcloud" "ubuntu_22_04" {
  image        = "ubuntu-22.04"
  location     = "nbg1"
  server_type  = "cpx11"
  ssh_username = "root"
  token        = var.hcloud_token
  snapshot_name = "${var.environment == "production" ? join("-", ["prvsn-base", var.version]) : join("-", ["prvsn-base", var.version, var.network_name]) }"
  snapshot_labels = {
    "created_by"   = "prvsn",
    "role"         = "base-server",
    "version"      = var.version,
    "network_name" = var.network_name
  }
}

build {
  sources = ["source.hcloud.ubuntu_22_04"]

  provisioner "ansible" {
    playbook_file = "./playbook.yml"
    use_proxy = false
    user = "root"
    ansible_env_vars = [
      "OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES"
    ]
    extra_arguments = [ "--extra-vars", "internal_network_cidr=${var.internal_network_cidr} loki_server=${var.loki_server_ip}" ]
  }
}
