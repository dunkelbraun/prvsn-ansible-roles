resource "random_shuffle" "datacenter" {
  input = {
    "eu-central": ["nbg1-dc3", "hel1-dc2", "fsn1-dc14"],
    "us-east": ["ash-dc1"],
    "us-west": ["hil-dc1"]
  }[var.network_zone]
  result_count = 1
}
