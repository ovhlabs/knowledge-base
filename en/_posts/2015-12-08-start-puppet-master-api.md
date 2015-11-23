---
layout: post
title: "Start a Puppet Master using the API"
categories: puppet
author: marcus-at-ovh
lang: en
---

To activate the Puppet as a Service lab, please go to [runabove.com][4] and get your login and password.

In this guide you will learn how to create a Puppet Master service with the Puppet as a Service API. By providing the API with the clone address of the Git repository containing your Puppet modules you will get a domain for your agents to get their configuration. Puppet as a Service provides additional advantages in terms of scalability and dashboards. You will learn at the end of the guide how to connect to the PuppetDB dashboard of your master.

You are going to:

- generate a deployment key to put on your Git repository,
- create a master pointing to your puppet modules,
- connect to your master's PuppetDB dashboard.

Requirements:

- Your Puppet modules must be stored in a Git repository (public or private) reachable from the Internet.

For the sake of command lines' brevity you can define this helpful aliases to interact with Puppet as a Service API.

```bash
user@desk:~$ PUPPET_LAB=https://puppet.runabove.io
user@desk:~$ alias auth_curl='curl --include --user YOUR_USERNAME:YOUR_PASSWORD --header "Content-Type: application/json"'
```

Request a deployment key
========================

_You can skip this step if your Git repository is public._

```bash
user@desk:~$ auth_curl -X POST ${PUPPET_LAB}/deploy-keys --data '{"name": "github"}'
```

```json
{
    "name": "github",
    "fingerprint": "69:2f:e1:29:82:10:66:fa:59:a7:1e:22:40:66:1a",
    "public": "ssh-rsa AAAAB3NzaC1yc2EAAAAD[...]XP1BmhOtTOw=="
}
```

Copy the public part of the deployment key and add it to your Git repository's permissions in order to allow the puppet master service to clone your puppet modules.

Create a Puppet master using the API
====================================

```bash
user@desk:~$ auth_curl -X POST ${PUPPET_LAB}/masters --data '{"name": "my_master", "source": "git@github.com:myself/my_repo.git", "deploy_key": "github"}'
```

```json
{
    "allowed_networks": [
        "0.0.0.0/0"
    ],
    "deploy_key": "github",
    "hierarchy": [],
    "hieras": [],
    "hostname": "my_master.user.puppet.runabove.io",
    "id": "1e42-34f9",
    "modification_time": 1445950405,
    "name": "my_master",
    "nb": 1,
    "servers": {},
    "source": "git@github.com:myself/my_repo.git",
    "status": {
        "code": 0,
        "msg": "Deploying server"
    },
    "token": "d4K1cxIPklE",
    "type": "vps-ssd-1",
    "vars": {}
}
```

Here is a short description of the most important attributes of you master:

- `allowed_networks`: `0.0.0.0/0` shows that your master will be reachable from anywhere
- `hostname`: this is the address to pass to your agents
- `status`:
    + `0` --> DEPLOYING: the master is being deployed
	+ `1` --> ACTIVE: the master is ready
	+ `2` --> ERROR: the master encountered a problem, see the status message for information
- `token`: private token to authenticate on interfaces related to this master.
- `type`, `nb`: the kind and the number of hosts your master is running on (as OVH Public Cloud flavors).

Next commands will make use of the `MASTER_ID` variable, set it with your master's ID (this is `1e42-34f9` in the example).

```bash
user@desk:~$ export MASTER_ID=change-me-to-master-id
```

When your master will be ready its status code will change to 1.

```bash
user@desk:~$ auth_curl -X GET ${PUPPET_LAB}/masters/${MASTER_ID}
```

```json
{
	[...]
    "status": {
        "code": 1,
        "msg": "Puppet Master running"
    }
    [...]
}
```

Connect an agent to your master
===============================

See the [dedicated guide][6] about connecting an agent to your Puppet master.

Puppetboard
===========

Browse to `https://<your_puppet_hostname>`. Use login: `admin`, password: `<your-master-token>` to authenticate. We provide a classic [PuppetBoard](https://github.com/puppet-community/puppetboard).

![PuppetBoard](/kb/images/2015-11-24-how-to-start-simple-puppet-master/puppetboard.png)


Go further
==========

You may have a look at:

- Guide: [how to use hiera with the Puppet as a Service lab][5]
- Documentation: [Reference documentation][2], [Guides][3]
- Create your account: [runabove.com][4]

[1]: start-puppet-master-api.html
[2]: http://puppet.runabove.io/doc
[3]: /kb/en/puppet
[4]: https://www.runabove.com
[5]: how-to-use-hiera.html
[6]: how-to-connect-an-agent.html


Troubleshooting
===============

Unreachable code repository
---------------------------

```bash
user@desk:~$ auth_curl -X GET ${PUPPET_LAB}/masters/${MASTER_ID}
```

```json
{
    [...]
    "status": {
        "code": 2,
        "msg": "Cannot fetch git repository"
    }
    [...]
}
```

This master status means the service could not clone your code repository.

- Double-check the URL.
- Make sure you have loaded the deployment key in your repository.

Those are examples of working URLs (using HTTPS and SSH protocols):

- `https://git.company.com/username/puppet-modules.git`
- `ssh://git@git.company.com/username/puppet-modules.git`
