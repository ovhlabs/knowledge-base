---
layout: post
title:  "Marathon containers logs in PaaS Logs"
categories: Docker
author: devatoria
lang: en
---

It may be useful to send your application logs to the [PaaS Logs RunAbove lab](https://www.runabove.com/paas-logs.xml). Indeed, if your containers stop, or if you want to be able ti debug something, you will be happy to have access to your application logs.

#Inject my token into my container

To be able to push logs into the PaaS Logs platform, you have to generate a new token from the RunAbove user interface. You will find more information on the [PaaS Logs quick start guide](https://community.runabove.com/kb/en/logs/quick-start.html). Once you have your token, you must inject it into your application containers using the label `USER_THOT_TOKEN`, when creating/editing your app.

![Main interface](/kb/images/2016-04-21-marathon-logs/logs.png)
