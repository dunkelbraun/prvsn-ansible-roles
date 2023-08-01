locals {
  hetzner_server_types = {
    "small"   = "cpx11",
    "medium"  = "cpx21",
    "large"   = "cpx31",
    "xlarge"  = "cpx41",
    "2xlarge" = "cpx51",
  }
  location = random_shuffle.location.result[0]
  network_id = data.hcloud_network.network.id
  network_name = data.hcloud_network.network.name
}
