variable "stack" {
  description = "Configuration for servers and load balancers"

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

  # name
  validation {
    condition = can(regex("^[a-zA-Z0-9_]+$", var.stack.name))
    error_message = "Name must be alphanumeric, allowing underscores, and without spaces."
  }

  # network_cidr
  validation {
    condition = can(regex("^10\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.0\\.0\\/16$", var.stack.network_cidr))
    error_message = "must be an CIDR in the range 10.0.0.0 through 10.255.0.0 with a subnet mask of 16 bits"
  }

  # zone
  validation {
    condition = contains(["eu-central", "us-east", "us-west"], var.stack.zone)
    error_message = "must be one of eu-central, us-east, or us-west"
  }

  # server.name
  validation {
    condition = alltrue(
      [
        for server in var.stack.servers : can(regex("^[a-zA-Z0-9-]+$", server.name))
      ]
    )
    error_message = "Server name must be alphanumeric, allowing dashes, and without spaces."
  }
  validation {
    condition = length(distinct([for server in var.stack.servers : server.name])) == length(var.stack.servers)
    error_message = "Names must be unique amongst servers."
  }

  # servers.type
  validation {
    condition = alltrue(
      [
        for server in var.stack.servers : contains(
          ["cpx11", "cpx21", "cpx31", "cpx41", "cpx51"], server.type
        )
      ]
    )
    error_message = "All server types must be one of cpx11, cpx21, cpx31, cpx41, or cpx51."
  }

  # servers.data_volume_size
  validation {
    condition = alltrue(
      [
        for server in var.stack.servers : server.data_volume_size >= 10 && server.data_volume_size <= 1000
      ]
    )
    error_message = "data_volume_size must be between 10 and 1000."
  }

  # load_balancers.type
  validation {
    condition = alltrue(
      [
        for lb in var.stack.load_balancers : contains(["lb11", "lb21", "lb31"], lb.type)
      ]
    )
    error_message = "All load balancer types must be one of lb11, lb21, or lb31."
  }

  # load_balancers.subdomain
  validation {
    condition = alltrue(
      [
        for lb in var.stack.load_balancers : can(regex("^[a-zA-Z0-9][a-zA-Z0-9.-]+[a-zA-Z0-9]$", lb.subdomain))
      ]
    )
    error_message = "All load balancer subdomains must be valid subdomains."
  }
  validation {
    condition = length(distinct([for lb in var.stack.load_balancers : lb.subdomain])) == length(var.stack.load_balancers)
    error_message = "Subdomain values must be unique amongst the load balancers."
  }


  # load_balancer.target_server_names
  validation {
    condition = alltrue(
      [
        for lb in var.stack.load_balancers :
          alltrue(
            [
              for target_server in lb.target_servers : contains(
                [for server in var.stack.servers : server.name],
                target_server
              )
            ]
          )
      ]
    )
    error_message = "All target_servers must correspond to a server defined in servers."
  }
  validation {
    condition = alltrue([for lb in var.stack.load_balancers : length(lb.target_servers) == length(distinct(lb.target_servers))])
    error_message = "target_server_names must be a distinct list for a load_balancer."
  }
}

variable "hcloud_read_token" {
  description = "Hetzner Cloud API Token with reading rights"
  type        = string
}
