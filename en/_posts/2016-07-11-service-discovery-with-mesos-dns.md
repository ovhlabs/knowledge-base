---
layout: post
title:  "Service discovery with Mesos DNS"
categories: docker
author: thomas-maurice
lang: en
---



This tutorial introduces how to use the Mesos DNS service discovery with OVH PaaS Docker.



# Motivation

As you might have noticed, in the OVH PaaS Docker, each container has a private IP address, which is unique within a given cluster. You would
logically want to make two of your containers communicate without having to get out on the Internet and go through the load balancer.
The problem is that the IP addresses are assigned by Mesos in a quite unpredictable way. To fix this issue we now enable you to access your
containers with DNS records refreshed on a regular basis.

# Introducing Mesos DNS
[Mesos DNS](https://github.com/mesosphere/mesos-dns) is a nice piece of software developped by Mesosphere which enables service discovery within
a Mesos cluster. It acts like a DNS server, and maintains an up to date list of *A* and *SRV* records to allow your containers to speak with one another
even though they might move between hosts at any time.

An important information to understand is that if you scale your containers, Mesos DNS will return you several A fields for the service you wish
to reach. You have absolutely no idempotence guarantee: the same request might not hit the same container twice.

# Demo time
As a small demonstration is always better than a long speech, let's go! We shall assume the following:

 * My stack name is `docker-mt42-1`
 * I have an `api` service, scaled to 3
 * I want to reach it from another container, for the sake of the demo we will just assume I have a shell opened inside to do stuff.

The DNS names of the services are formed as it follows :

```
<service-name>-<stack-name>.customers-marathon.mesos
```

For simplicity reasons, you can ommit the `customers-marathon.mesos` part. So following this construction if I want to access my `api` service
all I have to do is:

```
root@c0c899be1d7f:/# host api-docker-mt42-1
api-docker-mt42-1.customers-marathon.mesos has address 172.16.78.5
api-docker-mt42-1.customers-marathon.mesos has address 172.16.78.3
api-docker-mt42-1.customers-marathon.mesos has address 172.16.78.6
```

And unsurprisingly it works!

Let's try a little curl:

```
root@c0c899be1d7f:/# curl api-docker-mt42-1:5000
Hello world!
```

Nice !

Note that when talking to the IP addresses of your containers, you can ignore the hostPort field given by the Marathon UI, since the container is
exposed directly on the internal network. This said, other customers, even though they are able to get your container's IP
addresses in some way, are unable to access your containers. Each portion of the network being dedicated to a customer, it is isolated from
the rest.

Happy marathon!

# Further readings
[Mesos DNS naming conventions](https://mesosphere.github.io/mesos-dns/docs/naming.html)

