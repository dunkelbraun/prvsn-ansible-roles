output "load_balancer_url" {
  description = "Load Balancer Domain Name"
  value = "https://${tolist(hcloud_managed_certificate.certificate.domain_names)[0]}"
}
