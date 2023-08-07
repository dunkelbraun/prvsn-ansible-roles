variable "hcloud_read_token" {
  type = string
}

variable "stack" {
  type = object({
    name = string
    zone = string
    ssh_key_name = string
    network_cidr = string
    domain = string
    servers = list(object({
      name             = string
      type             = string
      data_volume_size = number
    }))
    load_balancers = list(object({
      type                = string
      subdomain           = string
      target_port         = number
      target_servers      = list(string)
    }))
  })
}
