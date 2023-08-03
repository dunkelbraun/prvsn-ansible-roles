check "name" {
  assert {
    condition = hcloud_server.server.name == var.name
    error_message = <<-MSG
      Incorrect server name
        Expected: ${format("%#v", var.name)}
          Actual: ${format("%#v", hcloud_server.server.name)}
    MSG
  }
}

check "network_id" {
  assert {
    condition = tolist(hcloud_server.server.network)[0].network_id == data.hcloud_network.network.id
    error_message = <<-MSG
      Incorrect server network id
        Expected: ${format("%#v", data.hcloud_network.network.id)}
          Actual: ${format("%#v", tolist(hcloud_server.server.network)[0].network_id)}
    MSG
  }
}

check "public_ip" {
  assert {
    condition = tolist(hcloud_server.server.public_net)[0].ipv4 == 0
    error_message = <<-MSG
      Incorrect server ipv4
        Expected: ${format("%#v", 0)}
          Actual: ${format("%#v", tolist(hcloud_server.server.public_net)[0].ipv4)}
    MSG
  }

  assert {
    condition = tolist(hcloud_server.server.public_net)[0].ipv4_enabled == false
    error_message = <<-MSG
      Incorrect server ipv4_enabled
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", tolist(hcloud_server.server.public_net)[0].ipv4_enabled)}
    MSG
  }

  assert {
    condition = tolist(hcloud_server.server.public_net)[0].ipv6 == 0
    error_message = <<-MSG
      Incorrect server ipv6
        Expected: ${format("%#v", 0)}
          Actual: ${format("%#v", tolist(hcloud_server.server.public_net)[0].ipv6)}
    MSG
  }

  assert {
    condition = tolist(hcloud_server.server.public_net)[0].ipv6_enabled == false
    error_message = <<-MSG
      Incorrect server ipv6_enabled
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", tolist(hcloud_server.server.public_net)[0].ipv6_enabled)}
    MSG
  }
}

check "backups" {
  assert {
    condition = hcloud_server.server.backups == false
    error_message = <<-MSG
      Incorrect server backups
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_server.server.backups)}
    MSG
  }
}

check "delete_protection" {
  assert {
    condition = hcloud_server.server.delete_protection == false
    error_message = <<-MSG
      Incorrect server delete_protection
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_server.server.delete_protection)}
    MSG
  }
}

check "keep_disk" {
  assert {
    condition = hcloud_server.server.keep_disk == true
    error_message = <<-MSG
      Incorrect server keep_disk
        Expected: ${format("%#v", true)}
          Actual: ${format("%#v", hcloud_server.server.keep_disk)}
    MSG
  }
}

check "server_type" {
  assert {
    condition = hcloud_server.server.server_type == local.hetzner_server_types[var.server_type]
    error_message = <<-MSG
      Incorrect server server_type
        Expected: ${format("%#v", local.hetzner_server_types[var.server_type])}
          Actual: ${format("%#v", hcloud_server.server.server_type)}
    MSG
  }
}

check "ssh_keys" {
  assert {
    condition = length(hcloud_server.server.ssh_keys) == 1
    error_message = <<-MSG
      Incorrect server ssh_keys length
        Expected: ${format("%#v", 1)}
          Actual: ${format("%#v", length(hcloud_server.server.ssh_keys))}
    MSG
  }

  assert {
    condition = hcloud_server.server.ssh_keys[0] == var.ssh_key_id
    error_message = <<-MSG
      Incorrect server ssh_key
        Expected: ${format("%#v", var.ssh_key_id)}
          Actual: ${format("%#v", hcloud_server.server.ssh_keys[0])}
    MSG
  }
}

check "data_volume" {
  assert {
    condition = hcloud_volume.data.format == "ext4"
    error_message = <<-MSG
      Incorrect server data volume format
        Expected: ${format("%#v", "ext4")}
          Actual: ${format("%#v", hcloud_volume.data.format)}
    MSG
  }

  assert {
    condition = hcloud_volume.data.size == var.data_volume_size
    error_message = <<-MSG
      Incorrect server data volume size
        Expected: ${format("%#v", var.data_volume_size)}
          Actual: ${format("%#v", hcloud_volume.data.size)}
    MSG
  }

  assert {
    condition = hcloud_volume.data.delete_protection == false
    error_message = <<-MSG
      Incorrect server data volume delete_protection
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_volume.data.delete_protection)}
    MSG
  }

  assert {
    condition = contains(
      { "eu-central": ["fsn1", "nbg1", "hel1"], "us-east": ["ash"], "us-west": ["hil"] } [var.network_zone],
      hcloud_server.server.location
    )
    error_message = <<-MSG
      Incorrect server data volume location
        Expected: (any) of ${format("%#v", { "eu-central": ["fsn1", "nbg1", "hel1"], "us-east": ["ash"], "us-west": ["hil"] } [var.network_zone])}
          Actual: ${format("%#v", hcloud_volume.data.location)}
    MSG
  }
}

check "data_volume_attachment" {
  assert {
    condition = hcloud_volume_attachment.main.volume_id == tonumber(hcloud_volume.data.id)
    error_message = <<-MSG
      Incorrect server data volume attachment volume_id
        Expected: ${format("%#v", tonumber(hcloud_volume.data.id))}
          Actual: ${format("%#v", hcloud_volume_attachment.main.volume_id)}
    MSG
  }

  assert {
    condition = hcloud_volume_attachment.main.server_id == tonumber(hcloud_server.server.id)
    error_message = <<-MSG
      Incorrect server data volume attachment server_id
        Expected: ${format("%#v", tonumber(hcloud_server.server.id))}
          Actual: ${format("%#v", hcloud_volume_attachment.main.server_id)}
    MSG
  }

  assert {
    condition = hcloud_volume_attachment.main.automount == false
    error_message = <<-MSG
      Incorrect server data volume attachment automount
        Expected: ${format("%#v", false)}
          Actual: ${format("%#v", hcloud_volume_attachment.main.automount)}
    MSG
  }
}
