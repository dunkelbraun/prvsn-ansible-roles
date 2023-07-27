variable "name" {
  description = "Name of the network"
  type        = string
}

variable "network_cidr" {
  description = "Network CIDR"
  type        = string

  validation {
    condition = can(regex("^10\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.0\\.0\\/16$", var.network_cidr))
    error_message = "must be an CIDR in the range 10.0.0.0 through 10.255.0.0 with a subnet mask of 16 bits"
  }
}

variable "network_zone" {
  description = "Network zones to create the subnet"
  type        = string

  validation {
    condition = contains(["eu-central", "us-east", "us-west"], var.network_zone)
    error_message = "must be one of eu-central, us-east, or us-west"
  }
}
