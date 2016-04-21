---
layout: post
title:  "Marathon load balancer configuration"
categories: Docker
author: devatoria
lang: en
---

Marathon load balancer can be configured to use a specific vhost, so the URL to access your application will be more user-friendly. For example, let's say we have a nginx application and we want it to be available at `http://myapp.info`.

Considering your domain name is pointing to your load balancer URL (http://username.lb.sbg-1.containers.ovh.net), you just have to add the following labels:

- **HAPROXY\_0\_MODE**: "http"
- **HAPROXY\_0\_VHOST**: "myapp.info"

![Main interface](/kb/images/2016-04-21-marathon-load-balancer/haproxy.png)

If you want more information about how to configure your HAProxy load balancer, please [read this documentation](https://github.com/mesosphere/marathon-lb#haproxy-configuration).
