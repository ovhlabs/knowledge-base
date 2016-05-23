---
layout: post
title:  "Marathon load balancer configuration"
categories: Docker
author: devatoria
lang: en
---

The Marathon load balancer can be configured to use a specific domain name, to make you application URL more user-friendly. For example, let's say we have a nginx application and we want it to be available at `https://myapp.info`.

Considering your domain name is pointing to your load balancer URL (https://<username>.lb.sbg-1.containers.ovh.net), you just have to add the following labels:

- **HAPROXY\_0\_MODE**: "http"
- **HAPROXY\_0\_VHOST**: "myapp.info"

![Main interface](/kb/images/2016-04-21-marathon-load-balancer/haproxy.png)

For more information about how to configure your HAProxy load balancer, please read the [marathon-lb documentation](https://github.com/mesosphere/marathon-lb#haproxy-configuration). You'll see for example how to set weight on backends, how to enable sticky sessions on each backend.

## Configuring ACLs 

You can configure ACLs (Access Control List) on your applications, thus only allowing given IPs or networks to have access to your containers.
To use this feature, add the ``HAPROXY_BACKEND_NETWORK_ALLOWED_ACL`` label, with value a space separated list of allowed IPs and/or networks (example: ``167.114.239.226 167.114.238.0/22``)
