---
layout: post
title:  "Marathon load balancer configuration"
categories: Docker
author: devatoria
lang: en
---

In this tutorial, we'll see how to configure the frontends and backends of our application in the [HAProxy](https://cbonte.github.io/haproxy-dconv/intro-1.6.html) load balancer, through application labels.

## First and foremost

This tutorial assumes you have an nginx container up and running. If that's not the case, please read [the previous tutorial](/kb/en/docker/quick-start-with-marathon.html).


## Architecture

Inside the `[marathon-lb](https://github.com/mesosphere/marathon-lb)` container, the marathon-lb.py script connects to the Marathon API to retrieve all running apps, generates a HAProxy config and reloads HAProxy. By default, marathon-lb binds to the service port of every application and sends incoming requests to the application instances.

![Marathon-lb architecture](/kb/images/2016-04-21-marathon-load-balancer/architecture.png)

Marathon provides you with a way of configuring the [HAProxy](https://cbonte.github.io/haproxy-dconv/intro-1.6.html) frontend and backends: application labels.


## Configuring your load balancer using labels

The Marathon load balancer can be configured to expose your HTTP application behing a virtual host. Let's say we'd like to have access to our nginx container via the ``myapp.info`` domain. First, add a CNAME entry into the domain DNS zone, redirecting `myapp.info` to `<username>.lb.<cluster>.containers.ovh.net`.

**Note**: you can derive the value of both `username` and `cluster` from the address of your marathon web ui. For example, if your UI URL is `http://lb.sbg-1.containers.ovh.net/marathon/docker-abcdef-1/`, the value of `cluster` and `username` are respectively `sbg-1` and `docker-abcdef-1`.

To make marathon-lb configure HAProxy with your virtual host, you just have to add the following labels to your application:

- **HAPROXY\_0\_MODE**: "http"
- **HAPROXY\_0\_VHOST**: "myapp.info"

![Main interface](/kb/images/2016-04-21-marathon-load-balancer/haproxy.png)

**Note**: the `HAPROXY_0_` prefix will make sure the labels will apply to the first (remember, arrays indexes start at 0) service port defined in the application port mappings.

Marathon-lb will then generate the following HAProxy backend and frontends:

```
frontend marathon_http_in
  bind *:80
  mode http
  acl host_myapp_info hdr(host) -i myapp.info
  use_backend nginx_10080 if host_myapp_info

frontend marathon_https_in
  bind *:443 ssl crt /etc/ssl/mesosphere.com.pem
  mode http
  use_backend nginx_10080 if { ssl_fc_sni myapp.info }

frontend nginx_10080
  bind *:10080
  mode http
  use_backend nginx_10080

backend nginx_10080
  balance leastconn
  mode http    option forwardfor
  http-request set-header X-Forwarded-Port %[dst_port]
  http-request add-header X-Forwarded-Proto https if { ssl_fc }
  option  httpchk GET /
  timeout check 20s
  server somehost_31736 127.0.1.1:31736 check inter 60s fall 4
```

To reach you nginx, you can thus connect to the load balancer on the port 10080 (the application service port), or just request ``http://myapp.info`` (or even https). The global http (or https) HAProxy frontend will then redirect you to the `nginx_10080` backend.

## Configuring ACLs

You can configure ACLs (Access Control List) on your applications, thus only allowing given IPs or networks to have access to your containers.
To use this feature, add the ``HAPROXY_{n}_BACKEND_NETWORK_ALLOWED_ACL`` label, with value a space separated list of allowed IPs and/or networks (example: ``167.114.239.226 167.114.238.0/22``).

## Other labels

Marathon-lb defines a [list of labels](https://github.com/mesosphere/marathon-lb/blob/master/Longhelp.md#other-labels) you can apply on each service port of each of your apps, to configure the backend weights, groups, path, stickyness, etc.
