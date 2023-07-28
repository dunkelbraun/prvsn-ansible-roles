locals {
  hetzner_server_types = {
    "small"   = "cpx11",
    "medium"  = "cpx21",
    "large"   = "cpx31",
    "xlarge"  = "cpx41",
    "2xlarge" = "cpx51",
  }
  location = random_shuffle.location.result[0]
}
