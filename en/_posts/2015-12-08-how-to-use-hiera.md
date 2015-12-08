---
layout: post
title: "How to use hiera with your Puppet Master"
categories: puppet
author: marcus-at-ovh
lang: en
---

In this guide you will learn how to use _hiera_ with Puppet as a Service API. The example is based on the [hiera's complete example][6] from PuppetLabs. The example from PuppetLabs is well written and more detailed, you may read first if you are not familiar with hiera.

You will setup a hierarchy for the primary NTP server called `kermit` to retrieve a specific configuration. The Puppet service will handle:

- Hiera backend gems installations on your master.
- The generation of the hiera.yaml configuration file.

You are going to:

- create a hiera YAML backend using the API,
- attach it to your master,
- add a hierarchy of data sources to your master,
- test that the hiera lookup is working properly.

You will be needing a working master on the Puppet service, see the [guide to deploy a master][1].

This is for the sake of command lines' brevity.

```bash
user@desk:~$ PUPPET_LAB=https://puppet.runabove.io
user@desk:~$ MASTER_ID=change-me-to-master-id
user@desk:~$ alias auth_curl='curl --include --user YOUR_USERNAME:YOUR_PASSWORD --header "Content-Type: application/json"'
```

Create your YAML hiera backend
==============================

The `datadir` property is the directory in your Git repository where the _hiera_ backend will look for the data sources. The root here is the root of your Git repo.

```bash
user@desk:~$ auth_curl -X POST ${PUPPET_LAB}/hieras --data '{"name": "yaml_backend", "backend": "yaml", "parameters": {"datadir": "/hiera_yaml_data"}}'
```

```json
{
    "backend": "yaml",
    "name": "yaml_backend",
    "parameters": {
        "datadir": "/hiera_yaml_data"
    }
}
```

Add the YAML hiera backend to your master
=========================================

```bash
user@desk:~$ auth_curl -X PATCH ${PUPPET_LAB}/masters/${MASTER_ID} --data '{"backend": ["yaml_backend"]'
```

```json
{
    [...]
    "hieras": [
        "yaml_backend"
    ],
    [...]
}
```

Add a hierarchy to your master
==============================

You want _puppet_ to look up for _hiera_ variables in two _data sources_:

- `node/::fqdn`: for instances like `node/kermit.example.com`.
- `common`: for default values.

Add this hierarchy to your master. The order of the hierarchy matters: _data sources_ are searched for values in order (lower index first).

```bash
user@desk:~$ auth_curl -X PATCH ${PUPPET_LAB}/masters/${MASTER_ID} --data '{"hierarchy": ["node/%{::fqdn}", "common"]}'
```

```json
{
	[...]
    "hierarchy": [
        "node/%{::fqdn}",
        "common"
    ],
    [...]
}
```

Test hiera lookup
=================

Push the following YAML files in your Puppet modules repository.

`hiera_yaml_data/node/kermit.example.com.yaml`

```yaml
---
ntp::restrict:
  -
ntp::autoupdate: false
ntp::enable: true
ntp::servers:
  - 0.us.pool.ntp.org iburst
  - 1.us.pool.ntp.org iburst
  - 2.us.pool.ntp.org iburst
  - 3.us.pool.ntp.org iburst
```

`hiera_yaml_data/common.yaml`

```yaml
---
ntp::autoupdate: true
ntp::enable: true
ntp::servers:
  - grover.example.com iburst
  - kermit.example.com iburst
```

Refresh your master.

```bash
user@desk:~$ auth_curl -X POST ${PUPPET_LAB}/masters/${MASTER_ID}/refresh
```

```
HTTP/1.1 204 NO CONTENT
```

Use the hiera-query endpoint to test hiera lookup on your master.

```bash
user@desk:~$ auth-curl -X POST ${PUPPET_LAB}/masters/${MASTER_ID}/hiera-query --data '{"key": "ntp::servers", "type": "array", "parameters": {"::fqdn": "kermit.example.com", "::environment": "production"}}'
```

```json
{
    "result": [
        "0.us.pool.ntp.org iburst",
        "1.us.pool.ntp.org iburst",
        "2.us.pool.ntp.org iburst",
        "3.us.pool.ntp.org iburst"
    ]
}
```

```bash
user@desk:~$ auth-curl -X POST ${PUPPET_LAB}/masters/${MASTER_ID}/hiera-query --data '{"key": "ntp::servers", "type": "array", "parameters": {"::fqdn": "any-other.example.com", "::environment": "production"}}'
```

```json
{
    "result": [
        "grover.example.com iburst",
        "kermit.example.com iburst"
    ]
}
```

You have succesfully used _hiera_ with Puppet as a Service.

To go further
=============

You may get the other available _hiera_ backends and try them.

```bash
user@desk:~$ curl -X GET ${PUPPET_LAB}/available-hiera-backends
```

```json
{
    [...]
    "yaml": {
        "properties": {
            "datadir": {
                "default": "/hieradata",
                "required": false,
                "type": "string"
            }
        },
        "type": "object"
    },
    [...]
}
```

Check the [API documentation][5].

Getting help
============

- Get started: [deploy your master][1]
- Documentation: [Reference documentation][2], [Guides][3]
- Create your account: [runabove.com][4]

[1]: start-puppet-master-api.html
[2]: http://puppet.runabove.io/doc
[3]: /kb/en/puppet
[4]: https://www.runabove.com
[5]: http://puppet.runabove.io/doc/api/api.html
[6]: https://docs.puppetlabs.com/hiera/1/complete_example.html
