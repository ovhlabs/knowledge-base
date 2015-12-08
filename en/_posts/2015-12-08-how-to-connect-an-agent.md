---
layout: post
title: "Connect an Agent to your Puppet Master"
categories: puppet
author: bewiwi
lang: en
---

This post is about how to configure a Puppet agent to securely retrieve its configuration from its master.

You are going to :

- get your master's CA certificate and set it onto the agent
- connect the Puppet agent to your master
- sign its certificate
- run puppet agent

You will be needing a working master on the Puppet service, see the [guide to deploy a master][1].

Helpful aliases
===============

Since we will be calling Puppet as a Service API with `curl`, we recommend to use these helpful aliases.

```bash
user@desk:~$ export PUPPET_LAB=https://puppet.runabove.io
user@desk:~$ export MASTER_ID=change-me-to-master-id
user@desk:~$ alias auth_curl='curl --include --user YOUR_USERNAME:YOUR_PASSWORD  --header "Content-Type: application/json"'
```

Get your Master's CA
====================

To connect an agent securely it is recommended to first copy the master's CA on the agent. This mitigates MITM attacks between the agent and the master. Do a GET request on your master endpoint to get its certificate.

```bash
user@desk:~$ auth_curl -X GET ${PUPPET_LAB}/masters/${MASTER_ID}
```

```json
{
	[...]
    "ca_certificate": "--My CA certificate--"
    [...]
}
```

Connect an agent
================

Log onto a server and copy the CA.

```bash
root@agent:~# ssl_dir=$(puppet config print ssldir)
root@agent:~# nano $ssl_dir/certs/ca.pem
root@agent:~# chown puppet:puppet $ssl_dir/certs/ca.pem
```

You can then run the agent safely

```bash
root@agent:~# puppet agent --test --server my_master.user.puppet.runabove.io
Info: Creating a new SSL key for agent.localdomain
Info: csr_attributes file loading from /etc/puppet/csr_attributes.yaml
Info: Creating a new SSL certificate request for agent.localdomain
Info: Certificate Request fingerprint (SHA256): A7:DA:...:BE:17
```

At this point the agent is waiting for the master to sign its certificate.

Sign your agent's certificate
=============================

Get the certificate signature requests associated to your master.

```bash
user@desk:~$ auth_curl -X GET ${PUPPET_LAB}/masters/${MASTER_ID}/certs
```

```json
{
    "certs": [{
        [...]
        "fingerprint": "A7:DA:[...]:BE:17",
        "hostname": "agent.localdomain",
        [...]
        "status": {
            "code": 0,
            "message": "SIGNATURE PENDING"
        }
    }]
}
```

Check the fingerprint against the puppet run output and sign the certificate request from your agent.

```bash
user@desk:~$ curl -X POST ${PUPPET_LAB}/masters/${MASTER_ID}/certs/agent.localdomain/sign
```

```
HTTP/1.1 204 NO CONTENT
```

Back to your agent output you will see that it has successfully fetched its certificate and its catalog.

```bash
root@agent:~# puppet agent --test --server my_master.user.puppet.runabove.io
Info: Caching certificate for agent.localdomain
Info: Caching certificate_revocation_list for ca
Info: Retrieving pluginfacts
Info: Retrieving plugin
Info: Caching catalog for agent.localdomain
Info: Applying configuration version '1448293643'
Notice: Finished catalog run in 15.18 seconds

```

Your agent is now ready to fetch its configuration from your master!

Getting help
============

- Get started: [deploy your master][1]
- Documentation: [Reference documentation][2], [Guides][3]
- Create your account: [runabove.com][4]

[1]: start-puppet-master-api.html
[2]: http://puppet.runabove.io/doc
[3]: /kb/en/puppet
[4]: https://www.runabove.com
