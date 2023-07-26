# Ansible Role: provsn_grafana_oss

This role installs Grafana OSS.

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
    - prvsn_grafana
```
