variable "load_balancer_type" {
  description = "The type of load balancer to create"
  type        = string
  default     = "small"

  validation {
    condition = contains(["small", "medium", "large"], var.load_balancer_type)
    error_message = "must be one of small, medium, large"
  }
}

variable "network_zone" {
  description = "The network zone to create the load balancer in"
  type        = string
}

variable "destination_port" {
  description = "The port the load balancer service connects to the targets"
  type        = number
  default     = 80
}

variable "subnet_id" {
  description = "The id of the subnet to create the load balancer in"
  type        = string
}

variable "domain" {
  description = "The domain to create the load balancer for"
  type        = string
}

variable "subdomain" {
  description = "The subdomain to create the load balancer for"
  type        = string
}

variable "target_server_ids" {
  description = "The ids of the servers to add as targets to the load balancer"
  type        = list(string)
}
