data "hcloud_ssh_key" "ssh_key" {
  name = var.stack.ssh_key_name
}

data "hetznerdns_zone" "dns_zone" {
    name = var.stack.domain
}

data "archive_file" "compose_grafana" {
  type        = "zip"
  source_dir  = "${path.module}/services/grafana"
  output_path = "${path.module}/services/grafana.zip"
}

data "archive_file" "compose_loki" {
  type        = "zip"
  source_dir  = "${path.module}/services/loki"
  output_path = "${path.module}/services/loki.zip"
}

data "archive_file" "compose_node_exporter" {
  type        = "zip"
  source_dir  = "${path.module}/services/node_exporter"
  output_path = "${path.module}/services/node_exporter.zip"
}

data "archive_file" "compose_prometheus" {
  type        = "zip"
  source_dir  = "${path.module}/services/prometheus"
  output_path = "${path.module}/services/prometheus.zip"
}

data "archive_file" "compose_promtail" {
  type        = "zip"
  source_dir  = "${path.module}/services/promtail"
  output_path = "${path.module}/services/promtail.zip"
}
