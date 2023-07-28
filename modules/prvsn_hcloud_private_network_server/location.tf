resource "random_shuffle" "location" {
  input = {
    "eu-central": ["fsn1", "nbg1", "hel1"],
    "us-east": ["ash"],
    "us-west": ["hil"]
  }[var.network_zone]
  result_count = 1
}
