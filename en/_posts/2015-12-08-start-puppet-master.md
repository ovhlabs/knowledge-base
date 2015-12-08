---
layout: post
title: "Start a Managed Puppet Master"
categories: puppet
author: NicolasLM
lang: en
---

In this guide you will learn how to create a Puppet Master service. You are going to:

- generate a deployment key to put in your Git repository,
- create a master pointing to your puppet modules,
- connect a puppet agent to your master.

Requirements:

- Your Puppet modules must be stored in a Git repository (public or private) reachable from the Internet.

Connect to Puppet as a Service interface
========================================

To activate the Puppet as a Service lab, please go to [runabove.com][3] and create your credentials. Then go to [Puppet as a Service manager](https://manager.puppet.runabove.io). Use your credentials to sign in there.

Create a deployment key
=======================

_You can skip this step if your Git repository is public._

Go to the `Deploy keys` tab and create your first deploy key. Copy the public part of the key pair and add it to your Git repository's permissions in order to allow the puppet master service to clone your puppet modules.

![Create deploy key](/kb/images/2015-12-08-start-puppet-master/deploykey.png)

Create a Puppet Master
======================

Go to `Masters` tab and create your master. A straightforward form will ask you a few parameters about your master setup.

![Create master](/kb/images/2015-12-08-start-puppet-master/create-master.png)

- `Name`: The name of your master. Its final URL will include this name.
- `Git repository`: The URL of your git repository. It can be either SSH, HTTP or HTTPS.
- `Deploy key`: If your Git repository is accessed by SSH you can select your key pair here.
- `Type`: The size of your master. A bigger master will be able to handle more agents concurrently.

Connect an agent to your master
===============================

On the page with the details of your master you will find the command used for connecting an agent to your master. Copy this command and execute it on a remote server. Refresh the page of your master and you will see the pending certificate of your agent.

![Sign agent certificate](/kb/images/2015-12-08-start-puppet-master/certificate.png)

Sign the certificate and your agent will be able to fetch its configuration during the next run.

For more explanations, see the [dedicated guide][5] about connecting an agent to your Puppet master.

Go further
==========

You may have a look at:

- Guide: [how to use hiera with the Puppet as a Service lab][4]
- Documentation: [Reference documentation][1], [Guides][2]
- Create your account: [runabove.com][3]

[1]: http://puppet.runabove.io/doc
[2]: /kb/en/puppet
[3]: https://www.runabove.com
[4]: how-to-use-hiera.html
[5]: how-to-connect-an-agent.html


Troubleshooting
===============

Unreachable code repository
---------------------------

The master status `Cannot fetch git repository` means the service could not clone your code repository.

- Double-check the URL.
- Make sure you have loaded the deployment key in your repository.

Those are examples of working URLs using HTTPS and SSH protocols:

- `https://git.company.com/username/puppet-modules.git`
- `ssh://git@git.company.com/username/puppet-modules.git`
