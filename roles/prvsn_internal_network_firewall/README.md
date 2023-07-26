# Ansible Role: prvsn_internal_network_firewall

This role configures the internal network firewall on a Hetzner server with firewalld.

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
    - prvsn_internal_network_firewall
```
