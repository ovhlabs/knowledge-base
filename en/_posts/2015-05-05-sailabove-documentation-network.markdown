---
layout: post
title: "Working with networks"
categories: docker/documentation
tags: sailabove, reference
lang: en
author: yadutaf
---

[Sailabove][7] is the scalable, HA Cloud Docker Hosting platform by Runabove. It comes with out of the box load balancing, HA persistent volumes and seemless private networks.

This documentation is about Sailabove private networks. To get started, [Create your account][7] and see our [Getting Started guide][8] first.

Maybe you have already launched a couple of services on Sailabove and ran ``sail services inspect`` on any of them. If so, you may have noticed, that, by default, every service comes with 2 networks:

```
$ sail services inspect exampleuser/hello-go
...
container_network:
  public: true
  yadutaf/private: true
...
containers:
  hello-go-1:
    network:
      public:
        ip: 92.222.94.27
      exampleuser/private:
        ip: 192.168.0.25
...
```

``container_network`` shows that both the public network and private network are enabled for this service. ``containers.*.network`` gives the details for each of the service's container. In this case, there is only one.

Each new project is created with 3 networks:

 - **``public``:** For public IPs. IPs allocation is fully automatic, on each container start
 - **``<username>/private``:** For everything you'd rather not say aloud on a public place.
 - **``predictor``:** For free, automatic HTTP(s) load balancing. Replaces ``public``.

Here, we'll essentially focus on the private networks. They are a great feature when it comes to security and privacy. If this matters for you (and sure it does), keep on reading!

# What is a private network and why is it important

Private networks are an implicit and very powerful concept at the heart of Docker. By default, when a container is started, Docker automatically puts it in a private network. When a port is explicitly exposed, it is made available on the public network. Internally, it relies on a bridge called ``docker0`` and uses the ``172.17.0.0/16`` private subnet. The magic being that almost nobody notices it.

Private networks are a great security addition for an application by clearly isolating internal, potentially confidential traffic from public user facing traffic. A typical use-case would be traditional 2-tier application like WordPress. A working WordPress application uses 2 components:

 1. WordPress code itself.
 2. A MySQL or MariaDB database.

In this scenario, the wordpress application will only expose HTTP(s) to the outside and communicate with its private database server on the private network.

# Private networks with Sailabove

Just like Docker on your laptop, Sailabove has private networks at the heart of its design. And because security matters, each Sailabove account automatically gets a private network named ``<username>/private`` by default.

Technically, Sailabove networks are dedicated L2 segments with only *your* services on it. Private networks can be created with any IPv4 subnet from [the IANA reserved private address space][1].

## Default private network

By default, each account has a private network with:

 - **name**: ``<username>/private``
 - **subnet**: ``192.168.0.0/16``
 - **allocation range**: from ``192.168.0.10`` to ``192.168.0.254``

You can also retrieve these informations at any time using:

```
$ sail networks inspect private
```

When you start a service, It will automatically start with both a public interface and a private interface. To create only a private (or public) network interface, you can use ``--network private`` (or ``--network public``) on the service creation command line. for example, to start a WordPress with a MySQL restricted to the private network:

```
 Start MySQL on a private network, No internet access.
$ sail services add --network private -e MYSQL_ROOT_PASSWORD=mysecretpassword library/mysql <username>/wordpress-mysql

 Start Wordpress with a private and public interface (the default)
$ sail services add --link wordpress-mysql:mysql library/wordpress <username>/wordpress
```

> **Hint:** If, for any reason, we wanted to get Internet access from the MySQL container, we could first start a dummy container with both interfaces and the ``--gateway`` option.

## Create and use a custom private network

Advanced, production-grade multi-tiered application may require multiple private networks to guarantee proper isolation. For example, you may want to isolate the password validation service from any other service on the network with only a single "gateway" service being able to access it. This will require at least an additional private network, just like you would create a dedicated VLAN for instance.

You may create an additional private network at any time using ``sail networks add``. Be careful when choosing the subnets. If a single service is meant to have an interface in multiple private network, these networks MUST be fully disjoint (ie: no common IP between their subnets). If this requirement fails to be met, the Service will refuse to start. For example, you may choose ``10.1.1.0/24`` and ``10.1.2.0/24`` but not ``10.1.0.0/16`` and ``10.1.2.0/24`` as the later is included in the former.

For example, let's create a private network dedicated to MariaDB replication:
```
$ sail networks add mariadb-replication 10.1.0.0/24
name: exampleuser/mariadb-replication
subnet: 10.1.0.0/24
```

We now need to specify an allocation range. In this example, we'll use the full available address space. The 10 first IPs are reserved for internal use, the last one is the broadcast address.

```
$ sail networks range-add mariadb-replication 10.1.0.10 10.1.0.254
ip_from: 10.1.0.10
ip_to: 10.1.0.254
```

To use it, we can now use ``--network private --network mariadb-replication`` when starting the MariaDB service. And we're done.

For a complete list of available commands along with their options, please visit the command line reference.

## IP addresses lifecycle

When a container starts for the first time, the private network will allocate an IP from from one of the allocation ranges declared with ``sail networks range-add``. This IP is reserved during the whole container lifecycle and is released when the container is destroyed.

As the private IPs are reserved, a container will always restart with the same private IPs. This is great for application resiliency since it eases a lot the recovery process in the event of service failure.

> **Note:** This only applies on applications private network. On the public network, new IPs may be allocated on each start. Use DNS for application discovery or the predictor load balancer if keeping a constant entry point is important.

# Advanced security

Now that main application data streams have been classified into isolated logical streams ie: private networks, we can go deeper in the security. The next step is to control precisely what are the exposed services / ports and to restrict access to the front-end service.

Under the hood, these commands will dynamically install iptable based firewall rules straight into all your containers.

## Choose what services to expose and remap them to public port

By default, when creating a service, all ports are exposed on all networks. With private networks, the bulk of the security work has been done. To go further, the first thing to do is to explicitly configure published ports.

The list of published ports must be specified when creating the service initially or as part of a redeploy. See the command line reference documentation for more informations regarding ``sail services add`` and ``sail services redeploy`` option ``--publish``.

For example, let's consider an application built with the lightweight ``express.js`` Node.JS micro-framework. By default it will listen listen on port 3000. Let's expose it on port 80 and filter out any other traffic:

```
 Publish port 3000 of my-express-app Docker image on port 80
sail service add my-express-app my-express-app -p 80:3000
```

Now, let's say this express.js application depends on a MongoDB database started on the private network and We want to make sure the database does not send requests to the front end application (why would a database make requests anyway ?), we may restrict the networks on which the application is published. For example:

```
 If the application has been started on the "predictor" network (recommended)
sail services redeploy my-express-app --publish predictor:80:3000

 If the application had been started on the public Internet
sail services redeploy my-express-app --publish public:80:3000
```

## Filter incoming connections by IP

Complementary to port filtering, Sailabove supports filter access to a given service based on the source address so that the service does not have to worry about managing its Access Control Lists itself, at the application layer. This is great for applications that should only be accessed from the company proxy. This includes intranet application, development environment and many others.

The list of whitelisted IPs or subnets must be specified when creating the service initially or as part of a redeploy. See the command line reference documentation for more informations regarding ``sail services add`` and ``sail services redeploy`` option ``--network-allow``.

For example, to restrict access to a Ghost blog to only 1.2.3.4 we can:

```
sail services add library/ghost <username>/internal-blog --network-allow 1.2.3.4
```

Or maybe the company proxy has moved to a new HA, load balanced system on a shared '/24'. Additionaly, we now want to make sure that only accesses to port 80 are allowed. We need to update the ACLs:

```
sail services redeploy internal-blog --network-allow 1.2.3.0/24:80
```

And we're done !

# Getting help

- Get started: [Getting started quide][8]
- Join OVH Docker mailing list: [docker-subscribe@ml.ovh.net][3]
- Visit our Community: [https://community.runabove.com/][4]
- Drop us an e-mail: [sailabove@ovh.net][5]
- Create your account: [Sailabove.com][7]


  [1]: http://en.wikipedia.org/wiki/Private_network#Private_IPv4_address_spaces
  [3]: mailto:docker-subscribe@ml.ovh.net
  [4]: https://community.runabove.com/
  [5]: mailto:sailabove@ovh.net
  [7]: https://sailabove.com/
  [8]: /kb/en/docker/getting-started-with-sailabove-docker.html
  [9]: /kb/en/docker/documentation
  [10]: /kb/en/docker/