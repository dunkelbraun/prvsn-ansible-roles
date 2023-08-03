check "network" {
  assert {
    condition = hcloud_network.network.name == var.name
    error_message = <<-MSG
      Incorrect network name
        Expected: ${format("%#v", var.name)}
          Actual: ${format("%#v", hcloud_network.network.name)}
    MSG
  }

  assert {
    condition = hcloud_network.network.ip_range == var.network_cidr
    error_message = <<-MSG
      Incorrect network ip_range
        Expected: ${format("%#v", var.network_cidr)}
          Actual: ${format("%#v", hcloud_network.network.ip_range)}
    MSG
  }

  assert {
    condition = hcloud_network.network.delete_protection == false
    error_message = <<-MSG
      Incorrect network delete_protection
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_network.network.delete_protection)}
    MSG
  }

  assert {
    condition = hcloud_network.network.expose_routes_to_vswitch == false
    error_message = <<-MSG
      Incorrect network expose_routes_to_vswitch
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_network.network.expose_routes_to_vswitch)}
    MSG
  }

  assert {
    condition = hcloud_network_subnet.subnet.network_zone == var.network_zone
    error_message = <<-MSG
      Incorrect subnet network_zone
        Expected: ${format("%#v", var.network_zone)}
          Actual: ${format("%#v", hcloud_network_subnet.subnet.network_zone)}
    MSG
  }

  assert {
    condition = hcloud_network_subnet.subnet.ip_range == replace(var.network_cidr, ".0.0/16", ".1.0/24")
    error_message = <<-MSG
      Incorrect subnet ip_range
        Expected: ${format("%#v", replace(var.network_cidr, ".0.0/16", ".1.0/24"))}
          Actual: ${format("%#v", hcloud_network_subnet.subnet.ip_range)}
    MSG
  }

  assert {
    condition = hcloud_network_subnet.subnet.type == "cloud"
    error_message = <<-MSG
      Incorrect subnet type
        Expected: ${format("%#v", "cloud")}
          Actual: ${format("%#v", hcloud_network_subnet.subnet.type)}
    MSG
  }
}

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
      Incorrect nat gateway keep_disk
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

  assert {
    condition = length(hcloud_server.nat_gateway.ssh_keys) == 1
    error_message = <<-MSG
      Incorrect grafana server ssh_keys length
        Expected: ${format("%#v", 1)}
          Actual: ${format("%#v", length(hcloud_server.nat_gateway.ssh_keys))}
    MSG
  }

  assert {
    condition = hcloud_server.nat_gateway.ssh_keys[0] == var.ssh_key_id
    error_message = <<-MSG
      Incorrect granafa server ssh_key
        Expected: ${format("%#v", var.ssh_key_id)}
          Actual: ${format("%#v", hcloud_server.nat_gateway.ssh_keys[0])}
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

check "grafana_server" {
  assert {
    condition = hcloud_server.grafana.name == "grafana-${replace(lower(var.name), " ", "-")}"
    error_message = <<-MSG
      Incorrect grafana server name
        Expected: ${format("%#v", "grafana-${replace(lower(var.name), " ", "-")}")}
          Actual: ${format("%#v", hcloud_server.grafana.name)}
    MSG
  }

  assert {
    condition = tolist(hcloud_server.grafana.network)[0].network_id == tonumber(hcloud_network.network.id)
    error_message = <<-MSG
      Incorrect grafana server network_id
        Expected: ${format("%#v", tonumber(hcloud_network.network.id))}
          Actual: ${format("%#v", tolist(hcloud_server.grafana.network)[0].network_id)}
    MSG
  }

  assert {
    condition = hcloud_server.grafana.keep_disk == true
    error_message = <<-MSG
      Incorrect grafana keep_disk
        Expected: ${format("%#v", true)}
          Actual: ${format("%#v", hcloud_server.grafana.keep_disk)}
    MSG
  }

  assert {
    condition = hcloud_server.grafana.backups == false
    error_message = <<-MSG
      Incorrect grafana backups
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_server.grafana.backups)}
    MSG
  }

  assert {
    condition = hcloud_server.grafana.delete_protection == false
    error_message = <<-MSG
      Incorrect grafan delete_protection
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_server.grafana.delete_protection)}
    MSG
  }

  assert {
    condition = tolist(hcloud_server.grafana.public_net)[0].ipv4 == 0
    error_message = <<-MSG
      Incorrect grafana server ipv4
        Expected: ${format("%#v", 0)}
          Actual: ${format("%#v", tolist(hcloud_server.grafana.public_net)[0].ipv4)}
    MSG
  }

  assert {
    condition = tolist(hcloud_server.grafana.public_net)[0].ipv4_enabled == false
    error_message = <<-MSG
      Incorrect grafana server ipv4_enabled
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", tolist(hcloud_server.grafana.public_net)[0].ipv4_enabled)}
    MSG
  }

  assert {
    condition = tolist(hcloud_server.grafana.public_net)[0].ipv6 == 0
    error_message = <<-MSG
      Incorrect grafana server ipv6
        Expected: ${format("%#v", 0)}
          Actual: ${format("%#v", tolist(hcloud_server.grafana.public_net)[0].ipv6)}
    MSG
  }

  assert {
    condition = tolist(hcloud_server.grafana.public_net)[0].ipv6_enabled == false
    error_message = <<-MSG
      Incorrect grafana server ipv6_enabled
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", tolist(hcloud_server.grafana.public_net)[0].ipv6_enabled)}
    MSG
  }

  assert {
    condition = hcloud_server.grafana.server_type == var.grafana_server_type
    error_message = <<-MSG
      Incorrect grafana server server_type
        Expected: ${format("%#v", var.grafana_server_type)}
          Actual: ${format("%#v", hcloud_server.grafana.server_type)}
    MSG
  }

  assert {
    condition = contains(
      { "eu-central": ["nbg1", "hel1", "fsn1"], "us-east": ["ash"], "us-west": ["hil"] } [var.network_zone],
      hcloud_server.grafana.location
    )
    error_message = <<-MSG
      Incorrect grafana server location
        Expected: (any) of ${format("%#v", { "eu-central": ["nbg1", "hel1", "fsn1"], "us-east": ["ash"], "us-west": ["hil"] } [var.network_zone])}
          Actual: ${format("%#v", hcloud_server.grafana.location)}
    MSG
  }

  assert {
    condition = length(hcloud_server.grafana.ssh_keys) == 1
    error_message = <<-MSG
      Incorrect grafana server ssh_keys length
        Expected: ${format("%#v", 1)}
          Actual: ${format("%#v", length(hcloud_server.grafana.ssh_keys))}
    MSG
  }

  assert {
    condition = hcloud_server.grafana.ssh_keys[0] == var.ssh_key_id
    error_message = <<-MSG
      Incorrect granafa server ssh_key
        Expected: ${format("%#v", var.ssh_key_id)}
          Actual: ${format("%#v", hcloud_server.grafana.ssh_keys[0])}
    MSG
  }
}
