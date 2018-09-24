ansible-role-hashicorp
======================

[![Apache-2.0 License](https://img.shields.io/github/license/bluk/ansible-role-hashicorp.svg)][license] [![Build Status](https://travis-ci.org/bluk/ansible-role-hashicorp.svg?branch=master)][travis-ci]

An [Ansible](https://www.ansible.com) role to install [HashiCorp](https://hashicorp.com/) tools.

Requirements
------------

It is assumed that `curl`, `gpg`, `shasum`, and `unzip` are installed.

Role Variables
--------------

* `hashicorp_program` - The name of the tool to install (e.g. `vault` or `consul`).

* `hashicorp_version` - The version of the tool (e.g. `0.11.1`).

* `hashicorp_platform` - The platform of the tool to install (e.g. `linux_amd64` or `darwin_amd64`).

* `hashicorp_install_path` - The path to install the tools.

* `hashicorp_check_gpg_signature` - If the GPG signature of the SHA sum file should be checked (e.g. `"true"`).

Dependencies
------------

No dependencies.

Example Playbook
----------------

```
- hosts: servers
  roles:
     - role: bluk.hashicorp
       vars:
         hashicorp_program: vault
         hashicorp_version: 0.11.1
         hashicorp_platform: linux_amd64
         hashicorp_install_path: /usr/local/bin
```

License
-------

[Apache 2.0][license]

[license]: https://github.com/bluk/ansible-role-hashicorp/blob/master/LICENSE
[travis-ci]: https://travis-ci.org/bluk/ansible-role-hashicorp
