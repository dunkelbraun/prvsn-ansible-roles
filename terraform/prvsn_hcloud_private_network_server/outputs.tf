output "private_network_server" {
  description = "Private Network Server Details"
  value = {
    name = hcloud_server.server.name,
    ip = tolist(hcloud_server.server.network)[0].ip
  }
}
