# Ansible Role: prvsn_internal_network_firewall

This role configures a Hetzner Cloud server to act as a NAT gateway.

## Distros tested

Ubuntu 22.04

## Requirements

None.

## Role Variables

None.

## Dependencies

### Collections

- ansible.posix

## Example Playbook

```yml
---

- hosts: some_server
  become: yes
  roles:
    - prvsn_nat_gateway
```
