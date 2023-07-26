# Ansible Role: provsn_node_exporter

This role installs Promertheus Node exporter.

## Distros tested

Ubuntu 22.04

## Requirements

None.

## Role Variables

None.

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
    - prvsn_node_exporter
```
