output "private_network_server" {
  description = "Private Network Server (hcloud_server attributes)"
  value = hcloud_server.server
}

output "private_network_server_data_volume" {
  description = "Private Network Server Data Volume (hcloud_volume attributes)"
  value = hcloud_volume.data
}
