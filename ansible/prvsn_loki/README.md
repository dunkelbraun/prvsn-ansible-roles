# Ansible Role: provsn_loki

This role installs Loki.

## Distros tested

Ubuntu 22.04

## Requirements

None.

## Role Variables

- prvsn_loki_internal_network_cidr

  Internal Network CIDR.

  Default: none.

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
    - prvsn_loki
```
