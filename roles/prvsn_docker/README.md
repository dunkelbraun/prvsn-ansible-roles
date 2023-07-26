# Ansible Role: prvsn_docker

This role installs Docker.

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
    - prvsn_docker
```
