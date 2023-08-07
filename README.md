## Requirements

The following requirements are needed by this module:

- <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) (1.41.0)

- <a name="requirement_hetznerdns"></a> [hetznerdns](#requirement\_hetznerdns) (2.2.0)

## Providers

The following providers are used by this module:

- <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) (1.41.0)

- <a name="provider_hetznerdns"></a> [hetznerdns](#provider\_hetznerdns) (2.2.0)

- <a name="provider_random"></a> [random](#provider\_random)

## Modules

No modules.

## Resources

The following resources are used by this module:

- [hcloud_firewall.ssh_traffic](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/firewall) (resource)
- [hcloud_load_balancer.load_balancer](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/load_balancer) (resource)
- [hcloud_load_balancer_network.load_balancer](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/load_balancer_network) (resource)
- [hcloud_load_balancer_service.service](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/load_balancer_service) (resource)
- [hcloud_load_balancer_target.target](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/load_balancer_target) (resource)
- [hcloud_managed_certificate.certificate](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/managed_certificate) (resource)
- [hcloud_network.network](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/network) (resource)
- [hcloud_network_route.nat_gateway_route](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/network_route) (resource)
- [hcloud_network_subnet.subnet](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/network_subnet) (resource)
- [hcloud_server.grafana](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/server) (resource)
- [hcloud_server.nat_gateway](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/server) (resource)
- [hcloud_server.server](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/server) (resource)
- [hcloud_volume.data](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/volume) (resource)
- [hcloud_volume_attachment.main](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/resources/volume_attachment) (resource)
- [hetznerdns_record.record](https://registry.terraform.io/providers/timohirt/hetznerdns/2.2.0/docs/resources/record) (resource)
- [random_id.volume](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)
- [random_shuffle.datacenter](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) (resource)
- [random_shuffle.location](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/shuffle) (resource)
- [hcloud_ssh_key.ssh_key](https://registry.terraform.io/providers/hetznercloud/hcloud/1.41.0/docs/data-sources/ssh_key) (data source)
- [hetznerdns_zone.dns_zone](https://registry.terraform.io/providers/timohirt/hetznerdns/2.2.0/docs/data-sources/zone) (data source)

## Required Inputs

The following input variables are required:

### <a name="input_hcloud_read_token"></a> [hcloud\_read\_token](#input\_hcloud\_read\_token)

Description: Hetzner Cloud API Token with reading rights

Type: `string`

### <a name="input_stack"></a> [stack](#input\_stack)

Description: Configuration for servers and load balancers

Type:

```hcl
object({
    name = string

    zone = string

    ssh_key_name = string

    network_cidr = string

    domain = string

    servers = list(object({
      name             = string
      type             = string
      data_volume_size = number
    }))

    load_balancers = list(object({
      type                = string
      subdomain           = string
      target_port         = number
      target_servers      = list(string)
    }))
  })
```

## Optional Inputs

No optional inputs.

## Outputs

The following outputs are exported:

### <a name="output_grafana_server"></a> [grafana\_server](#output\_grafana\_server)

Description: Grafana server details

### <a name="output_grafana_url"></a> [grafana\_url](#output\_grafana\_url)

Description: Grafana URL

### <a name="output_nat_gateway"></a> [nat\_gateway](#output\_nat\_gateway)

Description: NAT Gateway details

### <a name="output_network"></a> [network](#output\_network)

Description: Network Details

### <a name="output_server_ips"></a> [server\_ips](#output\_server\_ips)

Description: Server IPs
