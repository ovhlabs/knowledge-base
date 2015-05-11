---
layout: post
title: "Working with services discovery"
categories: docker/documentation
tags: sailabove, reference
lang: en
author: yadutaf
---

[Sailabove][7] is the scalable, HA Cloud Docker Hosting platform by Runabove. It comes with out of the box load balancing, HA persistent volumes and seemless private networks.

This documentation is about Sailabove service discovery. To get started, [Create your account][7] and see our [Getting Started guide][8] first.

If you've already built an application with more than a single building block in a cloud environment, then you're most probably already familiar with questions like:

 - How do I know where my backend is ?
 - What if it reboots ?
 - Will its IP change ?

All these questions are related to what's commonly referred to as "service discovery". In other words, discovering where a given service is. To solve this problem, Docker introduced the *link* concept. Additionally, Sailabove will automatically provision RR DNS entries for all containers listening on the ``public`` and ``predictor`` network.

For bigger application, it may be interesting to complement this tools with components dedicated to service discovery like ``etcd`` and ``zookeeper``.

# Using Docker links

In a nutshell, creating a Docker link is telling Docker that this new service "C", will rely on a previously started service "B" which itself may also depend on a service "A". When Docker starts container "C" it will automatically:

 - Copy the full environment from "B", prefixed by "``B_``".
 - Insert an entry of the form "``<container B IP> a``" into ``/etc/hosts``

As Sailabove services may be scaled to multiple containers, it will add 2 additional aliases per container of the linked service.

 - The container internal UUID, as found in ``sail containers ps``.
 - The container service name, suffixed by an ordinal id.

For example, if service B is composed of 2 containers:

 1. a7d4be92-2761-4455-85c2-78e5ab283b38 with IP 192.168.0.11/24 and listens on port 6789
 2. c440ecc9-af9d-4b1f-bfa6-14220165aaf8 with IP 192.168.0.12/24 and listens on port 5672

And has these environment variables:

 - ``USERNAME=frontend``
 - ``PASSWORD=Passw0rd``

A Container of service C will have the following environment variables, inherited from B:

 - ``B_ENV_USERNAME=frontend``
 - ``B_ENV_PASSWORD=Passw0rd``
 - ``B_PORT=tcp://192.168.0.11:5672``
 - ``DB_PORT_5672_TCP_PORT=5672``
 - ``DB_PORT_5672_TCP_PROTO=tcp``
 - ``DB_PORT_5672_TCP_ADDR=192.168.0.11``
 - ``DB_PORT_5672_TCP=tcp://192.168.0.11:5672``

Its ``/etc/hosts`` will look like:

```
127.0.0.1 localhost c-1.exampleuser.app.sailabove.io c.exampleuser.app.sailabove.io f680b794-a3aa-4f0d-b91b-0fcda98e94aa.container.app.sailabove.io
192.168.0.11 b a7d4be92-2761-4455-85c2-78e5ab283b38 b_1
192.168.0.12   c440ecc9-af9d-4b1f-bfa6-14220165aaf8 b_2
```

This is extremely powerful when provisioning, for instance, a database and a service relying on this database. The credentials will only need to be set once. Most Docker image from the Docker Registry follow this convention.

A good security practice is to flush (erase/delete) environment variables containing sensitive informations, typically credentials, as early as possible in the container lifecycle. This will greatly reduce the risk to accidentally leak sensitive informations at run time.

# Using DNS

Docker links are great for self-discovery. To better integrate with external services, Sailabove also provisions special DNS entries for all public facing services. That is to say, services exposed on the ``predictor`` or ``public`` networks.

These entries are of the form:

 - ``service-name.app-name.app.sailabove.io``: Round-Robin DNS with the ips of all endpoints
 - ``service-name-<ordinal>.app-name.sailabove.io``: IP of container #ordinal of service "service-name"

For example, let's say we have created a ``techcrunch`` application whose API service is scaled to 2 nodes. We will have entries like:

```
api.tweetcrunch.app.sailabove.io. IN A 1.1.1.1
api.tweetcrunch.app.sailabove.io. IN A 1.1.1.2
api-1.tweetcrunch.app.sailabove.io. IN A 1.1.1.1
api-2.tweetcrunch.app.sailabove.io. IN A 1.1.1.2
```

To connect to the API, one could just use the domain name ``api.tweetcrunch.app.sailabove.io`` and will be automatically redirected to one of the online containers.

> **Hint:** To get nicer URLs, you may create a domain name and point it to the automatic internal domain name. For instance, ``api.tweetcrunch.com. IN CNAME api.tweetcrunch.app.sailabove.io.``. If your container lives on the predictor network, make sure to [attach it to your service][4].

# Using external tools like ``etcd`` and ``zookeeper``

When building a large application, potentially built around dozens of independently scaled micro-services, Docker links and DNS entries will benefit from a dedicated complementary tool. A possible setup could be to:

 1. Create a ``discovery`` private network with a subnet large enough to host all the containers.
 2. Start a first etcd or zookeeper node.
 3. Start at least 2 more nodes, linked to the first one. They should have a script in it to automatically join the first node. If the image supports it, you may even simply ``sail services scale <discovery-service> --number 3``.
 4. When creating a new service, make sure that it registers itself on the discovery service on start.
 5. Discover!

# Getting help

- Get started: [Getting started quide][8]
- Documentation: [Reference documentation][9], [Guides][10]
- Join OVH Docker mailing list: [docker-subscribe@ml.ovh.net][1]
- Visit our Community: [https://community.runabove.com/][2]
- Drop us an e-mail: [sailabove@ovh.net][3]
- Create your account: [Sailabove.com][7]


  [1]: mailto:docker-subscribe@ml.ovh.net
  [2]: https://community.runabove.com/
  [3]: mailto:sailabove@ovh.net
  [4]: /kb/en/docker/documentation/sailabove-documentation-predictor.html
  [7]: https://sailabove.com/
  [8]: /kb/en/docker/getting-started-with-sailabove-docker.html
  [9]: /kb/en/docker/documentation
  [10]: /kb/en/docker/