---
layout: post
title:  "Health checks with Marathon"
categories: Docker
author: devatoria
lang: en
---

Health checks are useful to ensure that your containers are running; and even better, are behaving as expected. You can add multiple health checks per application. Marathon supports both high level HTTP and lower level TCP health checks.
HTTP checks allow for better, higher level checks on a specific URL like `http://localhost:port/my/health/path`. It automatically ignores informational status codes in the range 100 to 199.

# Configure a health check for a nginx application

In the [previous tutorial](/kb/en/docker/quick-start-with-marathon.html), we ran a simple nginx container. Let's now configure some HTTP health check for this application.

![Main interface](/kb/images/2016-04-20-marathon-health-checks/health_check.png)

- **Grace Period**: health check failures are ignored within this number of seconds or until the task becomes healthy for the first time *(useful if you have a task with a long startup time, to avoid having the  health check failing because of this)*.
- **Interval**: number of seconds to wait between each health check
- **Timeout**: number of seconds after which a health check is considered a failure regardless of the response.

##Configure the port to check

There are two ways to configure the port to check: by port *index* or by port *number*. By default, the port is passed by index: 0 is the first port you passed in the port mapping configuration, 1 is the second one, etc. You can also specify a port by simpply choosing the **port number** type.
