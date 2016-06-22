---
layout: post
title:  "Getting started with Shinken as a Service"
categories: shinken
author: NicolasLM
lang: en
---

# Shinken as a Service

[Shinken](http://www.shinken-monitoring.org) is a monitoring software designed to keep an eye on
your infrastructure and alert you if anything happens. It is designed to scale and handle large
setups.

As we believe that anyone should be able to monitor their services without investing a lot of time
and money in deploying monitoring software, we built Shinken as a Service: a simple solution that
provides you a fully managed dedicated Shinken cluster.

You can use this cluster to monitor your OVH products (dedicated servers, VPS, cloud instances...)
as well as websites and on-premise systems.

# Getting started

During the lab, anyone can activate one monitoring stack per OVH account.

## Joining the lab

Before starting to use [Shinken as a Service](https://www.runabove.com/shinken.xml) you need
to make sure that you have an OVH.com account. If you don't, go to
[ovh.com](https://www.ovh.com/manager/web/login/) and select "Create Account".

You can then activate the free monitoring lab on your account by going to the [Shinken as a Service
page](https://www.runabove.com/shinken.xml) and click **Start Now**.

## Deploying your Shinken cluster

Once your free order has been completed, you will notice a that a stack is ready to be deployed in
the Sunrise part of your OVH manager.

Select the stack, choose a name for your cluster, select a region and you're done. After a few
minutes your dedicated shinken cluster will be available.

Note that the name your pick will be in the DNS name you will use to contact your Shinken service.

## Configuration

### Resources

In order to add hosts and services to monitor, you must configure Shinken resources. Shinken as
a Service exposes the bare Shinken configuration resources: hosts, services, hostgroups... Head to
the official [Shiken documentation on
resources](http://shinken.readthedocs.io/en/latest/08_configobjects/index.html) for detailed
definitions of these objects.

Once you have edited the resources, you can test the resulting configuration by pushing the **Test
resources** button. You will get a confirmation if the configuration is valid, otherwise the errors
will be displayed.

Once you are satisfied with the result you can push the current configuration to your Shinken
cluster by pressing **Apply**.

All these resources are accessible through the [OVH
API](https://api.ovh.com/console/#/paas/monitoring) so you can fully automate the monitoring of
cloud infrastructures.

### Alerts

By default a contact called ``admin`` is created when you deploy the stack. Change the default
email address associated to the contact to receive alerts by email.

### Thruk web interface

Every Shinken cluster comes with a [web dashboard](https://www.thruk.org) showing the state of your
infrastructure. The direct link to the web interface can be found in the manager.

Thruk credentials are linked to Shinken’s contacts. To authorize a user to connect just add
a ``thruk_password`` attribute with the new password of the user. Once set, a password cannot be
retrieved but can be changed to a new one. You can add as many Thruk users as you want.

### Passive checks

By default your Shinken only uses active checks where Shinken contacts your host or service to
retrieve its status. You can also enable passive checks where your host pushes checks to your
Shinken cluster. A common way to do that is through NSCA.

NSCA is a simple protocol to submit host and service checks to a monitoring server. When activating
it you will be able to choose:

- an "encryption method", currently supported modes are 0 (no encryption) and 1 (XOR obfuscation).
- a key, which should be very long and random. Only used with encryption method 1.

Many agents can push from your servers to Shinken through NSCA. If you do not know which one to
use, [sauna](https://github.com/NicolasLM/sauna) can be a good starting point.

Passive checks can also be submitted through the LiveStatus API.

### Firewall

For security reasons you can decide to limit the access to your Shinken cluster to selected
networks only. You can filter access to:

- Thruk web dashboard
- LiveStatus API
- NSCA receiver

To manage allowed networks, click on the **Firewall** button in the web interface and edit the
white-list.

# Going further

- [Shinken documentation](http://shinken.readthedocs.io/en/latest/index.html)
- [Shinken as a Service API](https://api.ovh.com/console/#/paas/monitoring)
- Talk with us, #runabove on freenode
- User mailing list, send an email to paas.monitoring-subscribe@ml.ovh.net
