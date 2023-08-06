# data "hcloud_image" "base_server_snapshot" {
#   with_selector = "role=base-server,network_name=${var.name}"
#   most_recent = true
# }

# data "hcloud_image" "grafana_server_snapshot" {
#   with_selector = "role=grafana,network_name=${var.name}"
#   most_recent = true
# }
