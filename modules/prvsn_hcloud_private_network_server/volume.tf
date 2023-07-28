resource "hcloud_volume" "data" {
  name              = replace("${var.name}-data", "/\\s+/", "")
  size              = var.data_volume_size
  location          = local.location
  format            = "ext4"
  delete_protection = false

  labels = {
    "created-by" = "prvsn-hcloud-starter",
    "role" = "data-volume",
    "server" = var.name
  }
}

resource "hcloud_volume_attachment" "main" {
  volume_id = hcloud_volume.data.id
  server_id = hcloud_server.server.id
  automount = false
}
