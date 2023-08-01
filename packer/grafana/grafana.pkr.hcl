variable "hcloud_token" {
  type    = string
  default = "${env("HCLOUD_TOKEN")}"
}

variable "loki_server_ip" {
  type    = string
}

variable "network_name" {
  type    = string
}

variable "hcloud_read_token" {
  type    = string
}

variable "internal_network_cidr" {
  type    = string
}

variable "environment" {
  type    = string
  default = "production"
}

variable "prometheus_network_name" {
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
  snapshot_name = "${var.environment == "production" ? join("-", ["prvsn-grafana", var.version]) : join("-", ["prvsn-grafana", var.version, var.network_name]) }"
  snapshot_labels = {
    "created_by" = "prvsn",
    "role"       = "grafana",
    "version"    = var.version,
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
    extra_arguments = [ "--extra-vars", "internal_network_cidr=${var.internal_network_cidr} prvsn_promtail_loki_server=${var.loki_server_ip} prvsn_prometheus_network_name=${var.prometheus_network_name} prvsn_prometheus_hcloud_read_token=${var.hcloud_read_token}" ]
  }
}
