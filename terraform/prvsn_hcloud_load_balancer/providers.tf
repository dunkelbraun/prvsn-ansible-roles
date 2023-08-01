terraform {
    required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.41.0"
    }

    hetznerdns = {
      source = "timohirt/hetznerdns"
      version = "2.2.0"
    }
  }
}
