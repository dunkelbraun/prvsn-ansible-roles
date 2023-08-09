check "network_name" {
  assert {
    condition = hcloud_network.network.name == var.stack.name
    error_message = <<-MSG
      Incorrect network name
        Expected: ${format("%#v", var.stack.name)}
          Actual: ${format("%#v", hcloud_network.network.name)}
    MSG
  }
}

check "network_ip_range" {
  assert {
    condition = hcloud_network.network.ip_range == var.stack.network_cidr
    error_message = <<-MSG
      Incorrect network ip_range
        Expected: ${format("%#v", var.stack.network_cidr)}
          Actual: ${format("%#v", hcloud_network.network.ip_range)}
    MSG
  }
}

check "network_delete_protection" {
  assert {
    condition = hcloud_network.network.delete_protection == false
    error_message = <<-MSG
      Incorrect network delete_protection
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_network.network.delete_protection)}
    MSG
  }
}

check "network_expose_routes_to_vswitch" {
  assert {
    condition = hcloud_network.network.expose_routes_to_vswitch == false
    error_message = <<-MSG
      Incorrect network expose_routes_to_vswitch
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_network.network.expose_routes_to_vswitch)}
    MSG
  }
}

check "subnet_network_zone" {
  assert {
    condition = hcloud_network_subnet.subnet.network_zone == var.stack.zone
    error_message = <<-MSG
      Incorrect subnet network_zone
        Expected: ${format("%#v", var.stack.zone)}
          Actual: ${format("%#v", hcloud_network_subnet.subnet.network_zone)}
    MSG
  }
}

check "subnet_ip_range" {
  assert {
    condition = hcloud_network_subnet.subnet.ip_range == replace(var.stack.network_cidr, ".0.0/16", ".1.0/24")
    error_message = <<-MSG
      Incorrect subnet ip_range
        Expected: ${format("%#v", replace(var.stack.network_cidr, ".0.0/16", ".1.0/24"))}
          Actual: ${format("%#v", hcloud_network_subnet.subnet.ip_range)}
    MSG
  }
}

check "subnet_type" {
  assert {
    condition = hcloud_network_subnet.subnet.type == "cloud"
    error_message = <<-MSG
      Incorrect subnet type
        Expected: ${format("%#v", "cloud")}
          Actual: ${format("%#v", hcloud_network_subnet.subnet.type)}
    MSG
  }
}

check "nat_gateway_name" {
  assert {
    condition = hcloud_server.nat_gateway.name == "nat-${hcloud_network.network.id}"
    error_message = <<-MSG
      Incorrect nat gateway name
        Expected: ${format("%#v", "nat-${hcloud_network.network.id}")}
          Actual: ${format("%#v", hcloud_server.nat_gateway.name)}
    MSG
  }
}

check "nat_gateway_keep_disk" {
  assert {
    condition = hcloud_server.nat_gateway.keep_disk == false
    error_message = <<-MSG
      Incorrect nat gateway keep_disk
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_server.nat_gateway.keep_disk)}
    MSG
  }
}

check "nat_gateway_backups" {
  assert {
    condition = hcloud_server.nat_gateway.backups == false
    error_message = <<-MSG
      Incorrect nat gateway backups
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_server.nat_gateway.backups)}
    MSG
  }
}

check "nat_gateway_delete_protection" {
  assert {
    condition = hcloud_server.nat_gateway.delete_protection == false
    error_message = <<-MSG
      Incorrect nat gateway delete_protection
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_server.nat_gateway.delete_protection)}
    MSG
  }
}

check "nat_gateway_network_id" {
  assert {
    condition = tolist(hcloud_server.nat_gateway.network)[0].network_id == tonumber(hcloud_network.network.id)
    error_message = <<-MSG
      Incorrect nat gateway network_id
        Expected: ${format("%#v", tonumber(hcloud_network.network.id))}
          Actual: ${format("%#v", tolist(hcloud_server.nat_gateway.network)[0].network_id)}
    MSG
  }
}

check "nat_gateway_ip" {
  assert {
    condition = tolist(hcloud_server.nat_gateway.network)[0].ip == cidrhost(local.subnet_ip_range, 1)
    error_message = <<-MSG
      Incorrect nat gateway private ip
        Expected: ${format("%#v", cidrhost(local.subnet_ip_range, 1))}
          Actual: ${format("%#v", tolist(hcloud_server.nat_gateway.network)[0].ip)}
    MSG
  }
}

check "nat_gateway_server_type" {
  assert {
    condition = hcloud_server.nat_gateway.server_type == "cx11"
    error_message = <<-MSG
      Incorrect nat gateway server_type
        Expected: ${format("%#v", "cx11")}
          Actual: ${format("%#v", hcloud_server.nat_gateway.server_type)}
    MSG
  }
}

check "nat_gateway_firewall_ids_count" {
  assert {
    condition = length(hcloud_server.nat_gateway.firewall_ids) == 1
    error_message = <<-MSG
      Incorrect nat gateway firewall_ids count
        Expected: ${format("%#v", 1)}
          Actual: ${format("%#v", length(hcloud_server.nat_gateway.firewall_ids))}
    MSG
  }
}

check "nat_gateway_firewall_ids" {
  assert {
    condition = tolist(hcloud_server.nat_gateway.firewall_ids)[0] == tonumber(hcloud_firewall.ssh_traffic.id)
    error_message = <<-MSG
      Incorrect nat gateway firewall_ids
        Expected: ${format("%#v", hcloud_firewall.ssh_traffic.id)}
          Actual: ${format("%#v", tolist(hcloud_server.nat_gateway.firewall_ids))}
    MSG
  }
}

check "nat_gateway_datacenter" {
  assert {
    condition = contains(
      { "eu-central": ["nbg1-dc3", "hel1-dc2", "fsn1-dc14"], "us-east": ["ash-dc1"], "us-west": ["hil-dc1"] } [var.stack.zone],
      hcloud_server.nat_gateway.datacenter
    )
    error_message = <<-MSG
      Incorrect nat gateway datacenter
        Expected: (any) of ${format("%#v", { "eu-central": ["nbg1-dc3", "hel1-dc2", "fsn1-dc14"], "us-east": ["ash-dc1"], "us-west": ["hil-dc1"] } [var.stack.zone])}
          Actual: ${format("%#v", hcloud_server.nat_gateway.datacenter)}
    MSG
  }
}

check "nat_gateway_ssh_keys_count" {
  assert {
    condition = length(hcloud_server.nat_gateway.ssh_keys) == 1
    error_message = <<-MSG
      Incorrect nat gateway server ssh_keys length
        Expected: ${format("%#v", 1)}
          Actual: ${format("%#v", length(hcloud_server.nat_gateway.ssh_keys))}
    MSG
  }
}

check "nat_gateway_ssh_keys" {
  assert {
    condition = hcloud_server.nat_gateway.ssh_keys[0] == tostring(data.hcloud_ssh_key.ssh_key.id)
    error_message = <<-MSG
      Incorrect nat gateway server ssh_key
        Expected: ${format("%#v", tostring(data.hcloud_ssh_key.ssh_key.id))}
          Actual: ${format("%#v", hcloud_server.nat_gateway.ssh_keys[0])}
    MSG
  }
}

check "grafana_server_name" {
  assert {
    condition = hcloud_server.grafana.name == "grafana-${replace(var.stack.name, "_", "-")}"
    error_message = <<-MSG
      Incorrect grafana server name
        Expected: ${format("%#v", "grafana-${replace(var.stack.name, "_", "-")}")}
          Actual: ${format("%#v", hcloud_server.grafana.name)}
    MSG
  }
}

check "grafana_server_network_id" {
  assert {
    condition = tolist(hcloud_server.grafana.network)[0].network_id == tonumber(hcloud_network.network.id)
    error_message = <<-MSG
      Incorrect grafana server network_id
        Expected: ${format("%#v", tonumber(hcloud_network.network.id))}
          Actual: ${format("%#v", tolist(hcloud_server.grafana.network)[0].network_id)}
    MSG
  }
}

check "grafana_server_keep_disk" {
  assert {
    condition = hcloud_server.grafana.keep_disk == true
    error_message = <<-MSG
      Incorrect grafana keep_disk
        Expected: ${format("%#v", true)}
          Actual: ${format("%#v", hcloud_server.grafana.keep_disk)}
    MSG
  }
}

check "grafana_server_backups" {
  assert {
    condition = hcloud_server.grafana.backups == false
    error_message = <<-MSG
      Incorrect grafana backups
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_server.grafana.backups)}
    MSG
  }
}

check "grafana_server_delete_protection" {
  assert {
    condition = hcloud_server.grafana.delete_protection == false
    error_message = <<-MSG
      Incorrect grafan delete_protection
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_server.grafana.delete_protection)}
    MSG
  }
}

check "grafana_server_ipv4_enabled" {
  assert {
    condition = tolist(hcloud_server.grafana.public_net)[0].ipv4_enabled == false
    error_message = <<-MSG
      Incorrect grafana server ipv4_enabled
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", tolist(hcloud_server.grafana.public_net)[0].ipv4_enabled)}
    MSG
  }
}

check "grafana_server_ipv6_enabled" {
  assert {
    condition = tolist(hcloud_server.grafana.public_net)[0].ipv6_enabled == false
    error_message = <<-MSG
      Incorrect grafana server ipv6_enabled
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", tolist(hcloud_server.grafana.public_net)[0].ipv6_enabled)}
    MSG
  }
}

check "grafana_server_server_type" {
  assert {
    condition = hcloud_server.grafana.server_type == "cpx21"
    error_message = <<-MSG
      Incorrect grafana server server_type
        Expected: ${format("%#v", "cpx21")}
          Actual: ${format("%#v", hcloud_server.grafana.server_type)}
    MSG
  }
}

check "grafana_server_location" {
  assert {
    condition = contains(
      { "eu-central": ["nbg1", "hel1", "fsn1"], "us-east": ["ash"], "us-west": ["hil"] } [var.stack.zone],
      hcloud_server.grafana.location
    )
    error_message = <<-MSG
      Incorrect grafana server location
        Expected: (any) of ${format("%#v", { "eu-central": ["nbg1", "hel1", "fsn1"], "us-east": ["ash"], "us-west": ["hil"] } [var.stack.zone])}
          Actual: ${format("%#v", hcloud_server.grafana.location)}
    MSG
  }
}

check "grafana_server_ssh_keys_count" {
  assert {
    condition = length(hcloud_server.grafana.ssh_keys) == 1
    error_message = <<-MSG
      Incorrect grafana server ssh_keys length
        Expected: ${format("%#v", 1)}
          Actual: ${format("%#v", length(hcloud_server.grafana.ssh_keys))}
    MSG
  }
}

check "grafana_server_ssh_keys" {
  assert {
    condition = hcloud_server.grafana.ssh_keys[0] == tostring(data.hcloud_ssh_key.ssh_key.id)
    error_message = <<-MSG
      Incorrect granafa server ssh_key
        Expected: ${format("%#v", tostring(data.hcloud_ssh_key.ssh_key.id))}
          Actual: ${format("%#v", hcloud_server.grafana.ssh_keys[0])}
    MSG
  }
}

check "servers_count" {
  assert {
    condition = alltrue(
      [
        for server in var.stack.servers : hcloud_server.server[server.name] != null
      ]
    )
    error_message = <<-MSG
      Incorrect created servers
        Expected: ${format("%#v", [for server in var.stack.servers : server.name])}
          Actual: ${format("%#v", [for key, server in hcloud_server.server : key])}
    MSG
  }
}

check "servers_name" {
  assert {
    condition = alltrue(
      [
        for server in var.stack.servers : hcloud_server.server[server.name].name == server.name
      ]
    )
    error_message = <<-MSG
      Incorrect server names
        Expected: ${format("%#v", [for server in var.stack.servers : server.name])}
          Actual: ${format("%#v", [for server in hcloud_server.server : server.name])}
    MSG
  }
}

check "servers_network_id" {
  assert {
    condition = alltrue(
      [
        for server in hcloud_server.server : tolist(server.network)[0].network_id == tonumber(hcloud_network.network.id)
      ]
    )
    error_message = <<-MSG
      Incorrect server network id
        Expected: all to be ${format("%#v", [ for server in var.stack.servers : tonumber(hcloud_network.network.id) ])}
          Actual: ${format("%#v", [for server in hcloud_server.server : tolist(server.network)[0].network_id])}
    MSG
  }
}

check "servers_ipv4_enabled" {
  assert {
    condition = alltrue(
      [
        for server in hcloud_server.server : tolist(server.public_net)[0].ipv4_enabled == false
      ]
    )
    error_message = <<-MSG
      Incorrect server ipv4_enabled
        Expected: ${format("%#v", [ for server in var.stack.servers : false ])}
          Actual: ${format("%#v", [ for server in hcloud_server.server : tolist(server.public_net)[0].ipv4_enabled ])}
    MSG
  }
}

check "servers_ipv6_enabled" {
  assert {
    condition = alltrue(
      [
        for server in hcloud_server.server : tolist(server.public_net)[0].ipv6_enabled == false
      ]
    )
    error_message = <<-MSG
      Incorrect server ipv6_enabled
        Expected: ${format("%#v", [ for server in var.stack.servers : false ])}
          Actual: ${format("%#v", [ for server in hcloud_server.server : tolist(server.public_net)[0].ipv6_enabled ])}
    MSG
  }
}

check "servers_backups" {
  assert {
    condition = alltrue(
      [
        for server in hcloud_server.server : server.backups == false
      ]
    )
    error_message = <<-MSG
      Incorrect server backups
        Expected: ${format("%#v", [ for server in var.stack.servers : false ])}
          Actual: ${format("%#v", [ for server in hcloud_server.server : server.backups])}
    MSG
  }
}

check "servers_delete_protection" {
  assert {
    condition = alltrue(
      [
        for server in hcloud_server.server : server.delete_protection == false
      ]
    )
    error_message = <<-MSG
      Incorrect server delete_protection
        Expected: ${format("%#v", [ for server in var.stack.servers : false ])}
          Actual: ${format("%#v", [ for server in hcloud_server.server : server.delete_protection])}
    MSG
  }
}

check "servers_keep_disk" {
  assert {
    condition = alltrue(
      [
        for server in hcloud_server.server : server.keep_disk == true
      ]
    )
    error_message = <<-MSG
      Incorrect server keep_disk
        Expected: ${format("%#v", [ for server in var.stack.servers : true ])}
          Actual: ${format("%#v", [ for server in hcloud_server.server : server.keep_disk])}
    MSG
  }
}

check "servers_server_type" {
  assert {
    condition = alltrue(
      [
        for key, server in hcloud_server.server : server.server_type == local.servers_map[key].type
      ]
    )
    error_message = <<-MSG
      Incorrect server server_type
        Expected: ${format("%#v", [ for server in local.servers_map : server.type ])}
          Actual: ${format("%#v", [ for server in hcloud_server.server : server.server_type])}
    MSG
  }
}

check "servers_ssh_keys_length" {
  assert {
    condition = alltrue(
      [
        for server in hcloud_server.server : length(server.ssh_keys) == 1
      ]
    )
    error_message = <<-MSG
      Incorrect server ssh_keys length
        Expected: ${format("%#v", [ for server in var.stack.servers : 1 ])}
          Actual: ${format("%#v", [ for server in hcloud_server.server : length(server.ssh_keys)])}
    MSG
  }
}

check "servers_ssh_keys" {
  assert {
    condition = alltrue(
      [
        for server in hcloud_server.server : server.ssh_keys[0] == tostring(data.hcloud_ssh_key.ssh_key.id)
      ]
    )
    error_message = <<-MSG
      Incorrect server ssh_key
        Expected: ${format("%#v", [ for server in var.stack.servers : tostring(data.hcloud_ssh_key.ssh_key.id) ])}
          Actual: ${format("%#v", [ for server in hcloud_server.server : server.ssh_keys[0]])}
    MSG
  }
}

check "volumes_format" {
  assert {
    condition = alltrue(
      [
        for volume in hcloud_volume.data : volume.format == "ext4"
      ]
    )
    error_message = <<-MSG
      Incorrect data volume format
        Expected: ${format("%#v", [ for volume in hcloud_volume.data : "ext4" ])}
          Actual: ${format("%#v", [ for volume in hcloud_volume.data : volume.format ])}
    MSG
  }
}

check "volumes_name" {
  assert {
    condition = alltrue(
      [
        for key, volume in hcloud_volume.data : volume.size == local.servers_map[key].data_volume_size
      ]
    )
    error_message = <<-MSG
      Incorrect data volume size
        Expected: ${format("%#v", [ for key, volume in hcloud_volume.data : local.servers_map[key].data_volume_size ])}
          Actual: ${format("%#v", [ for key, volume in hcloud_volume.data : volume.size ])}
    MSG
  }
}

check "volumes_delete_protection" {
  assert {
    condition = alltrue(
      [
        for key, volume in hcloud_volume.data : volume.delete_protection == false
      ]
    )
    error_message = <<-MSG
      Incorrect server data volume delete_protection
        Expected: ${format("%#v", [ for volume in hcloud_volume.data : false ])}
          Actual: ${format("%#v", [ for volume in hcloud_volume.data : volume.delete_protection ])}
    MSG
  }
}

check "volumes_location" {
  assert {
    condition = alltrue(
      [
        for key, volume in hcloud_volume.data :
          contains(
            { "eu-central": ["fsn1", "nbg1", "hel1"], "us-east": ["ash"], "us-west": ["hil"] }[var.stack.zone],
            volume.location
          )
      ]
    )
    error_message = <<-MSG
      Incorrect server data volume location
        Expected: any of ${format("%#v", [ for volume in hcloud_volume.data : { "eu-central": ["fsn1", "nbg1", "hel1"], "us-east": ["ash"], "us-west": ["hil"] }[var.stack.zone] ])}
          Actual: ${format("%#v", [ for volume in hcloud_volume.data : volume.location ])}
    MSG
  }
}

check "volume_attachment_volume_id" {
  assert {
    condition = alltrue(
      [
        for key, attachment in hcloud_volume_attachment.main : attachment.volume_id == tonumber(hcloud_volume.data[key].id)
      ]
    )

    error_message = <<-MSG
      Incorrect data volume attachment volume_id
        Expected: ${format("%#v", [ for key, attachment in hcloud_volume_attachment.main : tonumber(hcloud_volume.data[key].id)])}
          Actual: ${format("%#v", [ for key, attachment in hcloud_volume_attachment.main : attachment.volume_id])}
    MSG
  }
}

check "volume_attachment_server_id" {
  assert {
    condition = alltrue(
      [
        for key, attachment in hcloud_volume_attachment.main : attachment.server_id == tonumber(hcloud_server.server[key].id)
      ]
    )
    error_message = <<-MSG
      Incorrect server data volume attachment server_id
        Expected: ${format("%#v", [ for key, attachment in hcloud_volume_attachment.main : tonumber(hcloud_server.server[key].id)])}
          Actual: ${format("%#v", [ for key, attachment in hcloud_volume_attachment.main : attachment.server_id])}
    MSG
  }
}

check "volume_attachment_automount" {
  assert {
    condition = alltrue(
      [
        for key, attachment in hcloud_volume_attachment.main : attachment.automount == false
      ]
    )
    error_message = <<-MSG
      Incorrect server data volume attachment automount
        Expected: ${format("%#v", [ for key, attachment in hcloud_volume_attachment.main : false])}
          Actual: ${format("%#v", [ for key, attachment in hcloud_volume_attachment.main : attachment.automount])}
    MSG
  }
}

check "load_balancer_count" {
  assert {
    condition = alltrue(
      [
        for key, lb in hcloud_load_balancer.load_balancer : local.all_load_balancers[key] != null
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer
        Expected: ${format("%#v", [ for key, lb in local.all_load_balancers : key ])}
          Actual: ${format("%#v", [ for key, lb in hcloud_load_balancer.load_balancer : key ])}
    MSG
  }
}

check "load_balancer_name" {
  assert {
    condition = alltrue(
      [
        for key, lb in hcloud_load_balancer.load_balancer : lb.name == local.all_load_balancers[key].subdomain
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer name
        Expected: ${format("%#v", [ for key, lb in local.all_load_balancers : local.all_load_balancers[key].subdomain ])}
          Actual: ${format("%#v", [ for key, lb in hcloud_load_balancer.load_balancer : lb.name ])}
    MSG
  }
}

check "load_balancer_network_network_id" {
  assert {
    condition = alltrue(
      [
        for key, lbn in hcloud_load_balancer_network.load_balancer :
          lbn.load_balancer_id == tonumber(hcloud_load_balancer.load_balancer[key].id)
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer network
        Expected: ${format("%#v", [ for key, lb in hcloud_load_balancer.load_balancer : tonumber(lb.id) ])}
          Actual: ${format("%#v", [ for key, lbn in hcloud_load_balancer_network.load_balancer : lbn.load_balancer_id ])}
    MSG
  }
}

check "load_balancer_network_subnet_id" {
  assert {
    condition = alltrue(
      [
        for key, lbn in hcloud_load_balancer_network.load_balancer :
          lbn.subnet_id == hcloud_network_subnet.subnet.id
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer network subnet id
        Expected: ${format("%#v", [ for key, lbn in hcloud_load_balancer_network.load_balancer : hcloud_network_subnet.subnet.id ])}
          Actual: ${format("%#v", [ for key, lbn in hcloud_load_balancer_network.load_balancer : lbn.subnet_id ])}
    MSG
  }
}

check "load_balancer_network_enable_public_interface" {
  assert {
    condition = alltrue(
      [
        for key, lbn in hcloud_load_balancer_network.load_balancer :
          lbn.enable_public_interface == true
      ]
    )
    error_message = <<-MSG
      Incorrect enable_public_interface in load balancer network
        Expected: ${format("%#v", [ for key, lbn in hcloud_load_balancer_network.load_balancer : true ])}
          Actual: ${format("%#v", [ for key, lbn in hcloud_load_balancer_network.load_balancer : lbn.enable_public_interface ])}
    MSG
  }
}

check "load_balancer_targets_type" {
  assert {
    condition = alltrue(
      [
        for key, target in hcloud_load_balancer_target.target :
          target.type == "label_selector"
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer target type
        Expected: ${format("%#v", [ for key, target in hcloud_load_balancer_target.target : "label_selector" ])}
          Actual: ${format("%#v", [ for key, target in hcloud_load_balancer_target.target : target.type ])}
    MSG
  }
}

check "load_balancer_targets_use_private_ip" {
  assert {
    condition = alltrue(
      [
        for key, target in hcloud_load_balancer_target.target :
          target.use_private_ip == true
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer target use_private_ip
        Expected: ${format("%#v", [ for key, target in hcloud_load_balancer_target.target : true ])}
          Actual: ${format("%#v", [ for key, target in hcloud_load_balancer_target.target : target.use_private_ip ])}
    MSG
  }
}

check "load_balancer_targets_load_balancer_id" {
  assert {
    condition = alltrue(
      [
        for key, target in hcloud_load_balancer_target.target :
          target.load_balancer_id == tonumber(hcloud_load_balancer.load_balancer[key].id)
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer target use_private_ip
        Expected: ${format("%#v", [ for key, target in hcloud_load_balancer_target.target : tonumber(hcloud_load_balancer.load_balancer[key].id) ])}
          Actual: ${format("%#v", [ for key, target in hcloud_load_balancer_target.target : target.load_balancer_id ])}
    MSG
  }
}

check "load_balancer_targets_label_selector" {
  assert {
    condition = alltrue(
      [
        for key, target in hcloud_load_balancer_target.target :
          target.label_selector == "subdomain=${local.all_load_balancers[key]["subdomain"]}"
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer target label_selector
        Expected: ${format("%#v", [ for key, target in hcloud_load_balancer_target.target : "subdomain=${local.all_load_balancers[key]["subdomain"]}" ])}
          Actual: ${format("%#v", [ for key, target in hcloud_load_balancer_target.target : target.label_selector ])}
    MSG
  }
}

check "load_balancer_service_load_balancer_id" {
  assert {
    condition = alltrue(
      [
        for key, service in hcloud_load_balancer_service.service :
          service.load_balancer_id == hcloud_load_balancer.load_balancer[key].id
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer service load_balancer_id
        Expected: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : hcloud_load_balancer.load_balancer[key].id ])}
          Actual: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : service.load_balancer_id ])}
    MSG
  }
}

check "load_balancer_service_protocol" {
  assert {
    condition = alltrue(
      [
        for key, service in hcloud_load_balancer_service.service :
          service.protocol == "https"
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer service protocol
        Expected: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : "https" ])}
          Actual: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : service.protocol ])}
    MSG
  }
}

check "load_balancer_service_listen_port" {
  assert {
    condition = alltrue(
      [
        for key, service in hcloud_load_balancer_service.service :
          service.listen_port == 443
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer service protocol
        Expected: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : 443 ])}
          Actual: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : service.listen_port ])}
    MSG
  }
}

check "load_balancer_service_redirect_http" {
  assert {
    condition = alltrue(
      [
        for key, service in hcloud_load_balancer_service.service :
          service.http[0].redirect_http == true
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer service redirect_http
        Expected: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : true ])}
          Actual: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : service.http[0].redirect_http ])}
    MSG
  }
}

check "load_balancer_service_destination_port" {
  assert {
    condition = alltrue(
      [
        for key, service in hcloud_load_balancer_service.service :
          service.destination_port == local.all_load_balancers[key]["target_port"]
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer service destination_port
        Expected: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : local.all_load_balancers[key]["target_port"] ])}
          Actual: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : service.destination_port ])}
    MSG
  }
}

check "load_balancer_service_certificates_count" {
  assert {
    condition = alltrue(
      [
        for key, service in hcloud_load_balancer_service.service :
          length(service.http[0].certificates) == 1
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer service certificates length
        Expected: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : 1 ])}
          Actual: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : length(service.http[0].certificates) ])}
    MSG
  }
}

check "load_balancer_service_certificate" {
  assert {
    condition = alltrue(
      [
        for key, service in hcloud_load_balancer_service.service :
          tolist(service.http[0].certificates)[0] == tonumber(hcloud_managed_certificate.certificate[key].id)
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer service destination_port
        Expected: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : tonumber(hcloud_managed_certificate.certificate[key].id) ])}
          Actual: ${format("%#v", [ for key, service in hcloud_load_balancer_service.service : tolist(service.http[0].certificates)[0] ])}
    MSG
  }
}

check "load_balancer_record_zone_id" {
  assert {
    condition = alltrue(
      [
        for key, record in hetznerdns_record.record :
          record.zone_id == data.hetznerdns_zone.dns_zone.id
      ]
    )
    error_message = <<-MSG
      Incorrect zone_id in load balancer record
        Expected: ${format("%#v", [ for key, record in hetznerdns_record.record : data.hetznerdns_zone.dns_zone.id])}
          Actual: ${format("%#v", [ for key, record in hetznerdns_record.record : record.zone_id])}
    MSG
  }
}

check "load_balancer_record_name" {
  assert {
    condition = alltrue(
      [
        for key, record in hetznerdns_record.record :
          record.name == local.all_load_balancers[key]["subdomain"]
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer record name
        Expected: ${format("%#v", [ for key, record in hetznerdns_record.record : local.all_load_balancers[key]["subdomain"] ])}
          Actual: ${format("%#v", [ for key, record in hetznerdns_record.record : record.name ])}
    MSG
  }
}

check "load_balancer_record_value" {
  assert {
    condition = alltrue(
      [
        for key, record in hetznerdns_record.record :
          record.value == hcloud_load_balancer.load_balancer[key].ipv4
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer record value
        Expected: ${format("%#v", [ for key, record in hetznerdns_record.record : hcloud_load_balancer.load_balancer[key].ipv4 ])}
          Actual: ${format("%#v", [ for key, record in hetznerdns_record.record : record.value ])}
    MSG
  }
}

check "load_balancer_record_type" {
  assert {
    condition = alltrue(
      [
        for key, record in hetznerdns_record.record :
          record.type == "A"
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer record type
        Expected: ${format("%#v", [ for key, record in hetznerdns_record.record : "A" ])}
          Actual: ${format("%#v", [ for key, record in hetznerdns_record.record : record.type ])}
    MSG
  }
}

check "load_balancer_record_ttl" {
  assert {
    condition = alltrue(
      [
        for key, record in hetznerdns_record.record :
          record.ttl == 60
      ]
    )
    error_message = <<-MSG
      Incorrect load balancer record ttl
        Expected: ${format("%#v", [ for key, record in hetznerdns_record.record : 60 ])}
          Actual: ${format("%#v", [ for key, record in hetznerdns_record.record : record.ttl ])}
    MSG
  }
}


check "managed_certificate_name" {
  assert {
    condition = alltrue(
      [
        for key, certificate in hcloud_managed_certificate.certificate :
          certificate.name == join("-", [var.stack.domain, local.all_load_balancers[key]["subdomain"], "lb"])
      ]
    )
    error_message = <<-MSG
      Incorrect certificate name
        Expected: ${format("%#v", [ for key, certificate in hcloud_managed_certificate.certificate : join("-", [var.stack.domain, local.all_load_balancers[key]["subdomain"], "lb"]) ])}
          Actual: ${format("%#v", [ for key, certificate in hcloud_managed_certificate.certificate : certificate.name ])}
    MSG
  }
}

check "managed_certificate_domain_names_count" {
  assert {
    condition = alltrue(
      [
        for key, certificate in hcloud_managed_certificate.certificate :
          length(certificate.domain_names) == 1
      ]
    )
    error_message = <<-MSG
      Incorrect certificate domain names length
        Expected: ${format("%#v", [ for key, certificate in hcloud_managed_certificate.certificate : 1 ])}
          Actual: ${format("%#v", [ for key, certificate in hcloud_managed_certificate.certificate : length(certificate.domain_names) ])}
    MSG
  }
}

check "managed_certificate_domain_name" {
  assert {
    condition = alltrue(
      [
        for key, certificate in hcloud_managed_certificate.certificate :
          tolist(certificate.domain_names)[0] == join(".", [local.all_load_balancers[key]["subdomain"], var.stack.domain])
      ]
    )
    error_message = <<-MSG
      Incorrect certificate domain names
        Expected: ${format("%#v", [ for key, certificate in hcloud_managed_certificate.certificate : join(".", [local.all_load_balancers[key]["subdomain"], var.stack.domain]) ])}
          Actual: ${format("%#v", [ for key, certificate in hcloud_managed_certificate.certificate : tolist(certificate.domain_names)[0] ])}
    MSG
  }
}

check "ssh_firewall_rule_count" {
  assert {
    condition = length(hcloud_firewall.ssh_traffic.rule) == 1
    error_message = <<-MSG
      Incorrect ssh firewall rules length
        Expected: ${format("%#v", 1)}
          Actual: ${format("%#v", length(hcloud_firewall.ssh_traffic.rule))}
    MSG
  }
}

check "ssh_firewall_direction" {
  assert {
    condition = tolist(hcloud_firewall.ssh_traffic.rule)[0].direction == "in"
    error_message = <<-MSG
      Incorrect ssh firewall direction
        Expected: ${format("%#v", "in")}
          Actual: ${format("%#v", tolist(hcloud_firewall.ssh_traffic.rule)[0].direction)}
    MSG
  }
}

check "ssh_firewall_port" {
  assert {
    condition = tolist(hcloud_firewall.ssh_traffic.rule)[0].port == "22"
    error_message = <<-MSG
      Incorrect ssh firewall port
        Expected: ${format("%#v", "22")}
          Actual: ${format("%#v", tolist(hcloud_firewall.ssh_traffic.rule)[0].port)}
    MSG
  }
}

check "ssh_firewall_protocol" {
  assert {
    condition = tolist(hcloud_firewall.ssh_traffic.rule)[0].protocol == "tcp"
    error_message = <<-MSG
      Incorrect ssh firewall protocol
        Expected: ${format("%#v", "tcp")}
          Actual: ${format("%#v", tolist(hcloud_firewall.ssh_traffic.rule)[0].protocol)}
    MSG
  }
}

check "ssh_firewall_source_ips" {
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
