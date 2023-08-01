variable "name" {
  description = "Name of the server"
  type        = string
}

variable "server_type" {
  description = "Server type"
  type        = string

  validation {
    condition = contains(["small", "medium", "large", "xlarge", "2xlarge"], var.server_type)
    error_message = "must be one of small, medium, large, xlarge, 2xlarge"
  }
}

variable "network_name" {
  description = "Name of the network to attach the server to"
  type        = string
}

variable "network_zone" {
  description = "Network zones to create the subnet"
  type        = string

  validation {
    condition = contains(["eu-central", "us-east", "us-west"], var.network_zone)
    error_message = "must be one of eu-central, us-east, or us-west"
  }
}

variable "ssh_key_id" {
  description = "SSH key ID to use as the default for the NAT Gateway instance"
  type = string
}

variable "data_volume_size" {
  description = "Size of the data volume in GB"
  type        = number
}

variable "grafana_private_ip" {
  description = "Private IP address of the Grafana server"
  type        = string
}

variable "network_gateway" {
  description = "IP address of the network gateway"
  type        = string
}

variable "nat_gateway_ipv4_address" {
  description = "IP address of the NAT Gateway instance"
  type        = string
}
