---
layout: post
title:  "Marathon containers logs in PaaS Logs"
categories: Docker
author: devatoria
lang: en
---

It may be useful to send your application logs to the [Logs Data Platform](https://www.ovh.com/fr/data-platforms/logs/). Indeed, if your containers stop, or if you want to be able to debug something, you will be happy to have access to your application logs.

#Inject my token into my container

To be able to push logs into the Logs Data Platform, you have to get a token from the sunrise manager of Logs Data Platform. You will find more information on the [Logs Data Platform quick start guide](https://docs.ovh.com/gb/en/mobile-hosting/logs-data-platform/quick-start/). Once you have your token, you must inject it into your application containers using the label `CONTAINERS_LOG_LOGS_TOKEN` (`USER_LOGS_TOKEN` is also supported), when creating/editing your app.

By default, logs are sent to `laas.runabove.com:12202`, the gelf input of Logs.

You can specify another sink by using labels `CONTAINERS_LOG_LOGS_SINKADDR` and `CONTAINERS_LOG_LOGS_SINKPORT`. Be sure to specify the address and port for Gelf input.

![Main interface](/kb/images/2016-04-21-marathon-logs/logs.png)
