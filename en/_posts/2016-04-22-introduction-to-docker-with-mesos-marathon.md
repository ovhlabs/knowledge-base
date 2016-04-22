---
layout: post
title:  "Introduction to Docker with Apache Mesos & Marathon"
categories: Docker
author: devatoria
lang: en
---

#Welcome to the Docker PaaS lab!

This article is here to guide your first steps through our lab, with a little explanation of what is Docker, Apache Mesos and Marathon, and how you will be able to use it using our technology stack.

##What is Docker?

Docker is now a standard containerization solution. It uses multiple technologies, like **control groups** and **namespaces**, to isolate your application.

##What is Apache Mesos?

Apache Mesos abstracts cluster **resources**, like CPU or memory, to distribute it to **frameworks** using an **offer system**. It is based on a Master/Slave architecture with a ZooKeeper Quorum, ensuring you a high availablity.

Frameworks are used to launch **tasks** on slaves. In fact, it is composed of two main components: the **scheduler** and the **executor**. The scheduler registers with the master, so the framework will be able to receive resources offers. The executor is a process that will be launched on slaves to run the **tasks**.

If you want more information about the Apache Mesos architecture, please read the really good [the architecture documentation](http://mesos.apache.org/documentation/latest/architecture/).

##What is Marathon?

Marathon is an Apache Mesos framework to run Docker containers. It provides a lot of features like framework high availibility through an active/passive system, constraints to ensure containers to be launched on different hosts or racks, application health checks, and many other things. You can manager your applications and containers using a web UI, allowing you to easily launch new containers, scale your applications, and more.

#What do we provide?

The Docker PaaS lab is based on all these technologies, adding some other cool stuff. Our lab is stack managed, it means that **we** deploy and manage your infrastructure.

##Your resources are dedicated

We are not providing a pool of slaves where everybody launches containers. You have dedicated slaves from OVH Cloud, and dedicated resources. Your containers are running on your slaves, and only yours, without noisy neighbours.

##We manage everything, but...

We manage masters, ZooKeepers, load balancers and slaves. But, we provide you accesses to the marathon web UI, and also to your HAProxy load balancer, so you can have stats even if you can't manage it.

##We do not only provide you containers...

We provide you a full stack with an OVH environment integration. When you are asking for a new stack, we deploy you OVH Cloud instances and provision it to integrate it to the cluster. It means that you stack is fully extensible. You can add new instances as you want, and to fill your needs at the moment.

You could say: what are my needs today?! To easily know if you have enough resources for your running applications, we provide you [a way to have concrete metrics using the PaaS Timeseries lab](/kb/en/docker/marathon-container-metrics.html), and exploit them with Grafana graphs.

Also, you can have your application logs [using the PaaS Logs lab](/kb/en/docker/marathon-container-logs.html) in Graylog.

#How do I start?

If you want to run your first application now, please [register to our lab](https://www.runabove.com/docker-with-mesos-marathon.xml) and read the [quick start guide](/kb/en/docker/quick-start-with-marathon.html).
