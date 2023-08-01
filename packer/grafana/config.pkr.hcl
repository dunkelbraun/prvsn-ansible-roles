packer {
  required_plugins {
    hcloud = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/hcloud"
    }

    ansible = {
      source  = "github.com/hashicorp/ansible"
      version = "~> 1.1.0"
    }
  }
}
