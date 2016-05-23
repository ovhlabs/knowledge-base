---
layout: post
title:  "Introduction to Docker with Apache Mesos & Marathon"
categories: Docker
author: devatoria
lang: en
---

#Welcome to the Docker PaaS lab!

In this series of articles, we'll guide you through using our Docker PaaS, explaining what [Docker](https://www.docker.com/), [Apache Mesos](https://mesos.apache.org/) and [Marathon](https://mesosphere.github.io/marathon/) are, and how we use them to provide you with a managed Docker as a Service platform.

##What is Docker?

Docker is now a standard containerization software. It allows you to build an read-only image of your application and all its dependencies, and run this image in software containers (isolated user-space processes), on any server supporting Docker (bare metal, public/provate cloud, VM, etc).

##What is Apache Mesos?

Apache Mesos abstracts cluster **resources**, like CPU, disk or memory, to distribute it to **frameworks** (applications using Mesos resources) using an **offer system**. It is based on a Master/Slave architecture with a ZooKeeper quorum, ensuring you a high availablity.

Frameworks are used to launch **tasks** on Mesos slaves. Each framework is composed of two main components: the **scheduler** and the **executor**. The scheduler registers with the Mesos master, to be able to receive resources offers. The executor is a process that will be launched on Mesos slaves to run the **tasks**.

If you want more information about the Apache Mesos architecture, please read the really good [Mesos architecture documentation](http://mesos.apache.org/documentation/latest/architecture/).

##What is Marathon?

[Marathon](https://mesosphere.github.io/marathon/) is an Apache Mesos framework to run Docker containers. It provides a lot of features like framework high availibility through an active/passive system, anti-affinity constraints to ensure containers are launched on different hosts or racks, application health checks, etc. You can manage your applications and containers using a web UI, allowing you to easily launch new containers, scale your applications, and more.

#What do we provide?

The Docker PaaS lab is based on all these software stacks, adding some other cool stuff, like redirecting your application Logs to our PaaS Logs, and your application metrics our PaaS Timeseries.. Our lab is stack managed, it means that **we** deploy and manage your infrastructure.

##Your resources are dedicated

We are not providing a pool of slaves where everybody launches containers. You have **dedicated** Public Cloud instances, and dedicated resources. Your containers are running on your instances, and only yours, without noisy neighbours.
During the beta, you'll be limited to a single (and free) [VPS SSD 3](https://www.ovh.com/fr/vps/vps-ssd.xml). However, you'll be able to add more resources as we advance, not limited to the OVH cloud.

##We manage everything

We manage Mesos masters, ZooKeepers, load balancers and Mesos slaves. However, we provide you with an access to the marathon web UI and to your HAProxy load balancer stats.

##We do not only give you containers
We provide you with a full stack, integrated with the OVH ecosystem. It means that your stack is fully extensible: as the beta evolves, you'll be able to add new instances, as your needs evolve, from any kind (Public Cloud, Dedicated Server, etc).

To easily assess if you have enough resources for your running applications, we provide you with [a way to obtain metrics using the Timeseries PaaS lab](/kb/en/docker/marathon-container-metrics.html), and exploit them with Grafana dashboards.

Also, you can have access to your application logs [using the PaaS Logs lab](/kb/en/docker/marathon-container-logs.html) in Graylog.

#How do I start?

If you want to run your first application now, please [register to our lab](https://www.runabove.com/docker-with-mesos-marathon.xml) and read the [quick start guide](/kb/en/docker/quick-start-with-marathon.html).
