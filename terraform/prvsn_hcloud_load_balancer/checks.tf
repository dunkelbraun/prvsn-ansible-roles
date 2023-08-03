check "load_balancer_name" {
  assert {
    condition = hcloud_load_balancer.load_balancer.name == "${var.subdomain}-${var.domain}-lb"
    error_message = <<-MSG
      Incorrect load balancer name
        Expected: "${var.subdomain}-${var.domain}-lb"
        Actual: "${hcloud_load_balancer.load_balancer.name}"
    MSG
  }
}

check "load_balancer_network" {
  assert {
    condition = tonumber(hcloud_load_balancer_network.load_balancer.load_balancer_id) == tonumber(hcloud_load_balancer.load_balancer.id)
    error_message = <<-MSG
      Incorrect load_balancer_id in load balancer network
        Expected: "${hcloud_load_balancer.load_balancer.id}"
        Actual: "${hcloud_load_balancer_network.load_balancer.load_balancer_id}"
    MSG
  }

  assert {
    condition = hcloud_load_balancer_network.load_balancer.subnet_id == var.subnet_id
    error_message = <<-MSG
      Incorrect subnet_id in load balancer network
        Expected: "${var.subnet_id}"
        Actual: "${hcloud_load_balancer_network.load_balancer.subnet_id}"
    MSG
  }

  assert {
    condition = hcloud_load_balancer_network.load_balancer.enable_public_interface == true
    error_message = <<-MSG
      Incorrect enable_public_interface in load balancer network
        Expected: true
        Actual: "${hcloud_load_balancer_network.load_balancer.enable_public_interface}"
    MSG
  }
}

check "load_balancer_targets" {
  assert {
    condition = length(hcloud_load_balancer_target.target) == length(var.target_server_ids)
    error_message = <<-MSG
      Incorrect number of targets
        Expected: "${length(var.target_server_ids)}"
        Actual: "${length(hcloud_load_balancer_target.target)}"
    MSG
  }

  assert {
    condition = alltrue([
      for target in hcloud_load_balancer_target.target : target.type == "server"
    ])
    error_message = <<-MSG
      Incorrect target type.
        Expected: ${format("%#v", [for _ in hcloud_load_balancer_target.target : "server"])}
          Actual: ${format("%#v", hcloud_load_balancer_target.target[*].type)}
    MSG
  }

  assert {
    condition = alltrue([
      for target in hcloud_load_balancer_target.target : target.use_private_ip == true
    ])
    error_message = <<-MSG
      Incorrect target type.
        Expected: ${format("%#v", [for _ in hcloud_load_balancer_target.target : true])}
          Actual: ${format("%#v", hcloud_load_balancer_target.target[*].use_private_ip)}
    MSG
  }

  assert {
    condition = alltrue([
      for target in hcloud_load_balancer_target.target : contains(var.target_server_ids, target.server_id)
    ])
    error_message = <<-MSG
      Incorrect target server ids.
      Expected: ${format("%#v", var.target_server_ids)}
        Actual: ${format("%#v", hcloud_load_balancer_target.target[*].server_id)}
    MSG
  }

  assert {
    condition = alltrue([
      for target in hcloud_load_balancer_target.target : target.load_balancer_id == tonumber(hcloud_load_balancer.load_balancer.id)
    ])
    error_message = <<-MSG
      Incorrect target server ids.
        Expected: ${format("%#v", [for _ in hcloud_load_balancer_target.target : tonumber(hcloud_load_balancer.load_balancer.id)])}
          Actual: ${format("%#v", hcloud_load_balancer_target.target[*].load_balancer_id)}
    MSG
  }
}

check "load_balancer_service" {
  assert {
    condition = hcloud_load_balancer_service.service.load_balancer_id == hcloud_load_balancer.load_balancer.id
    error_message = <<-MSG
      Incorrect load_balancer_id in load balancer service
        Expected: ${format("%#v", hcloud_load_balancer.load_balancer.id)}
          Actual: ${format("%#v", hcloud_load_balancer_service.service.load_balancer_id)}
    MSG
  }

  assert {
    condition = hcloud_load_balancer_service.service.protocol == "https"
    error_message = <<-MSG
      Incorrect protocol in load balancer service
        Expected: "https
          Actual: ${format("%#v", hcloud_load_balancer_service.service.protocol)}
    MSG
  }

  assert {
    condition = hcloud_load_balancer_service.service.listen_port == 443
    error_message = <<-MSG
      Incorrect listen_port in load balancer service
        Expected: 443
          Actual: ${format("%#v", hcloud_load_balancer_service.service.listen_port)}
    MSG
  }

  assert {
    condition = hcloud_load_balancer_service.service.destination_port == var.destination_port
    error_message = <<-MSG
      Incorrect destination_port in load balancer service
        Expected: ${format("%#v", var.destination_port)}
          Actual: ${format("%#v", hcloud_load_balancer_service.service.listen_port)}
    MSG
  }

  assert {
    condition = hcloud_load_balancer_service.service.http[0].redirect_http == true
    error_message = <<-MSG
      Incorrect destination_port in load balancer service
        Expected: ${format("%#v", true)}
          Actual: ${format("%#v", hcloud_load_balancer_service.service.http[0].redirect_http)}
    MSG
  }

  assert {
    condition = length(hcloud_load_balancer_service.service.http[0].certificates) == 1
    error_message = <<-MSG
      Incorrect number of certificates in load balancer service
        Expected: ${format("%#v", 1)}
          Actual: ${format("%#v", length(hcloud_load_balancer_service.service.http[0].certificates))}
    MSG
  }

  assert {
    condition = tolist(hcloud_load_balancer_service.service.http[0].certificates)[0] == tonumber(hcloud_managed_certificate.certificate.id)
    error_message = <<-MSG
      Incorrect certificate in load balancer service
        Expected: ${format("%#v", tonumber(hcloud_managed_certificate.certificate.id))}
          Actual: ${format("%#v", tolist(hcloud_load_balancer_service.service.http[0].certificates)[0])}
    MSG
  }
}

check "load_balancer_record" {
  assert {
    condition = hetznerdns_record.record.zone_id == data.hetznerdns_zone.dns_zone.id
    error_message = <<-MSG
      Incorrect zone_id in load balancer record
        Expected: ${format("%#v", data.hetznerdns_zone.dns_zone.id)}
          Actual: ${format("%#v", hetznerdns_record.record.zone_id)}
    MSG
  }

  assert {
    condition = hetznerdns_record.record.name == var.subdomain
    error_message = <<-MSG
      Incorrect name in load balancer record
        Expected: ${format("%#v", var.subdomain)}
          Actual: ${format("%#v", hetznerdns_record.record.name)}
    MSG
  }

  assert {
    condition = hetznerdns_record.record.value == hcloud_load_balancer.load_balancer.ipv4
    error_message = <<-MSG
      Incorrect value in load balancer record
        Expected: ${format("%#v", hcloud_load_balancer.load_balancer.ipv4)}
          Actual: ${format("%#v", hetznerdns_record.record.value)}
    MSG
  }

  assert {
    condition = hetznerdns_record.record.type == "A"
    error_message = <<-MSG
      Incorrect type in load balancer record
        Expected: ${format("%#v", "A")}
          Actual: ${format("%#v", hetznerdns_record.record.type)}
    MSG
  }

  assert {
    condition = hetznerdns_record.record.ttl == 60
    error_message = <<-MSG
      Incorrect ttl in load balancer record
        Expected: ${format("%#v", 60)}
          Actual: ${format("%#v", hetznerdns_record.record.ttl)}
    MSG
  }
}

check "managed_certificate" {
  assert {
    condition = hcloud_managed_certificate.certificate.name == join("-", [var.domain, var.subdomain, "lb"])
    error_message = <<-MSG
      Incorrect name in managed certificate
        Expected: ${format("%#v", join("-", [var.domain, var.subdomain, "lb"]))}
          Actual: ${format("%#v", hcloud_managed_certificate.certificate.name)}
    MSG
  }

  assert {
    condition = length(hcloud_managed_certificate.certificate.domain_names) == 1
    error_message = <<-MSG
      Incorrect number of domain_names in managed certificate
        Expected: ${format("%#v", 1)}
          Actual: ${format("%#v", length(hcloud_managed_certificate.certificate.domain_names))}
    MSG
  }

  assert {
    condition = tolist(hcloud_managed_certificate.certificate.domain_names)[0] == join(".", [var.subdomain, var.domain])
    error_message = <<-MSG
      Incorrect domain_names in managed certificate
        Expected: ${format("%#v", join(".", [var.subdomain, var.domain]))}
          Actual: ${format("%#v", tolist(hcloud_managed_certificate.certificate.domain_names)[0])}
    MSG
  }
}
