---
layout: post
title:  "Health checks with Marathon"
categories: Docker
author: devatoria
lang: en
---

Health checks are useful to ensure that your container is running; and better, is running as expected. You can add multiple health checks per application. A health check can be of two types:

- HTTP
- TCP

The only difference is that the HTTP check is checking a path (using http://localhost:port/path), and is able to ignore some HTTP status code (informational ones, from 100 to 199).

#Configure a health check for a nginx application

In the previous tutorial, we ran a simple nginx application. Let's add some health check for this application.

![Main interface](/kb/images/2016-04-20-marathon-health-checks/health_check.png)

- **Grace Period**: the time to wait from the launch of the task where health check errors will be ignored *(useful if you have a task which is long to be healthy and do not want your health check to fail because of this)*
- **Interval**: the time to wait before each health check
- **Timeout**: the time to wait before a health check is considered as failed regardless of the result

##Configure the port to check

There are two ways to configure the port to check. By default, the port is passed by index: 0 is the first port you passed in port mapping configuration, 1 the second, ... But you can also specify a port by choosing the **port number** type.
