# Ansible Role: provsn_promtail

This role installs the Promtail agent for Loki.

## Distros tested

Ubuntu 22.04

## Requirements

None.

## Role Variables

- prvsn_promtail_loki_server

  The address of the Loki server to send logs to.

  Default: localhost

## Dependencies

None.

## Example Playbook

```yml
---

- hosts: some_server
  become: yes
  roles:
    - role: prvsn_promtail
      prvsn_promtail_loki_server: localhost
```
