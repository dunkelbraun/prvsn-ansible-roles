check "nat_gateway" {
  assert {
    condition = hcloud_server.nat_gateway.name == "nat-${replace(lower(var.name), " ", "-")}"
    error_message = <<-MSG
      Incorrect nat gateway name
        Expected: ${format("%#v", "nat-${replace(lower(var.name), " ", "-")}")}
          Actual: ${format("%#v", hcloud_server.nat_gateway.name)}
    MSG
  }

  assert {
    condition = hcloud_server.nat_gateway.keep_disk == false
    error_message = <<-MSG
      Incorrect nat gateway name
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_server.nat_gateway.keep_disk)}
    MSG
  }

  assert {
    condition = hcloud_server.nat_gateway.backups == false
    error_message = <<-MSG
      Incorrect nat gateway backups
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_server.nat_gateway.backups)}
    MSG
  }

  assert {
    condition = hcloud_server.nat_gateway.delete_protection == false
    error_message = <<-MSG
      Incorrect nat gateway delete_protection
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_server.nat_gateway.delete_protection)}
    MSG
  }

  assert {
    condition = tolist(hcloud_server.nat_gateway.network)[0].network_id == tonumber(hcloud_network.network.id)
    error_message = <<-MSG
      Incorrect nat gateway network_id
        Expected: ${format("%#v", tonumber(hcloud_network.network.id))}
          Actual: ${format("%#v", tolist(hcloud_server.nat_gateway.network)[0].network_id)}
    MSG
  }

  assert {
    condition = tolist(hcloud_server.nat_gateway.network)[0].ip == cidrhost(local.subnet_ip_range, 1)
    error_message = <<-MSG
      Incorrect nat gateway private ip
        Expected: ${format("%#v", cidrhost(local.subnet_ip_range, 1))}
          Actual: ${format("%#v", tolist(hcloud_server.nat_gateway.network)[0].ip)}
    MSG
  }

  assert {
    condition = hcloud_server.nat_gateway.server_type == var.nat_gateway_server_type
    error_message = <<-MSG
      Incorrect nat gateway server_type
        Expected: ${format("%#v", var.nat_gateway_server_type)}
          Actual: ${format("%#v", hcloud_server.nat_gateway.server_type)}
    MSG
  }

  assert {
    condition = length(hcloud_server.nat_gateway.firewall_ids) == 1
    error_message = <<-MSG
      Incorrect nat gateway firewall_ids length
        Expected: ${format("%#v", 1)}
          Actual: ${format("%#v", length(hcloud_server.nat_gateway.firewall_ids))}
    MSG
  }

  assert {
    condition = tolist(hcloud_server.nat_gateway.firewall_ids)[0] == tonumber(hcloud_firewall.ssh_traffic.id)
    error_message = <<-MSG
      Incorrect nat gateway firewall_ids
        Expected: ${format("%#v", hcloud_firewall.ssh_traffic.id)}
          Actual: ${format("%#v", tolist(hcloud_server.nat_gateway.firewall_ids))}
    MSG
  }

  assert {
    condition = contains(
      { "eu-central": ["nbg1-dc3", "hel1-dc2", "fsn1-dc14"], "us-east": ["ash-dc1"], "us-west": ["hil-dc1"] } [var.network_zone],
      hcloud_server.nat_gateway.datacenter
    )
    error_message = <<-MSG
      Incorrect nat gateway datacenter
        Expected: (any) of ${format("%#v", { "eu-central": ["nbg1-dc3", "hel1-dc2", "fsn1-dc14"], "us-east": ["ash-dc1"], "us-west": ["hil-dc1"] } [var.network_zone])}
          Actual: ${format("%#v", hcloud_server.nat_gateway.datacenter)}
    MSG
  }
}

check "ssh_firewall" {

  assert {
    condition = length(hcloud_firewall.ssh_traffic.rule) == 1
    error_message = <<-MSG
      Incorrect ssh firewall rules length
        Expected: ${format("%#v", 1)}
          Actual: ${format("%#v", length(hcloud_firewall.ssh_traffic.rule))}
    MSG
  }

  assert {
    condition = tolist(hcloud_firewall.ssh_traffic.rule)[0].direction == "in"
    error_message = <<-MSG
      Incorrect ssh firewall direction
        Expected: ${format("%#v", "in")}
          Actual: ${format("%#v", tolist(hcloud_firewall.ssh_traffic.rule)[0].direction)}
    MSG
  }

  assert {
    condition = tolist(hcloud_firewall.ssh_traffic.rule)[0].port == "22"
    error_message = <<-MSG
      Incorrect ssh firewall port
        Expected: ${format("%#v", "22")}
          Actual: ${format("%#v", tolist(hcloud_firewall.ssh_traffic.rule)[0].port)}
    MSG
  }

  assert {
    condition = tolist(hcloud_firewall.ssh_traffic.rule)[0].protocol == "tcp"
    error_message = <<-MSG
      Incorrect ssh firewall protocol
        Expected: ${format("%#v", "tcp")}
          Actual: ${format("%#v", tolist(hcloud_firewall.ssh_traffic.rule)[0].protocol)}
    MSG
  }

  assert {
    condition = alltrue([
      for source_ip in tolist(hcloud_firewall.ssh_traffic.rule)[0].source_ips : contains(["0.0.0.0/0", "::/0"], source_ip)
    ])
    error_message = <<-MSG
      Incorrect ssh firewall source_ips
        Expected: allowed ${format("%#v", ["0.0.0.0/0", "::/0"])}
          Actual: all values ${format("%#v", tolist(hcloud_firewall.ssh_traffic.rule)[0].source_ips)}
    MSG
  }
}
