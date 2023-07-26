# Ansible Role: provsn_prometheus

This role installs and configures Prometheus.

## Distros tested

Ubuntu 22.04

## Requirements

None.

## Role Variables

- prvsn_prometheus_network_name

  The name of the Hetzner network for the scrape configuration.

  Default: none

- prvsn_prometheus_hcloud_read_token

  The Hetzner Cloud read token.

  Default: none

## Dependencies

### Collections

- ansible.posix
- prometheus.prometheus

## Example Playbook

```yml
---

- hosts: some_server
  become: yes
  roles:
    - role: prvsn_prometheus
      prvsn_prometheus_network_name: "a_network_name"
      prvsn_prometheus_hcloud_read_token: "some_token"
```
