---
layout: post
title:  "Marathon containers logs in Logs Data Plateform"
categories: Docker
author: devatoria
lang: en
---

It may be useful to send your application logs to the [Logs Data Platform](https://www.ovh.com/fr/data-platforms/logs/). Indeed, if your containers stop, or if you want to be able to debug something, you will be happy to have access to your application logs.

#Setup Log Data Plateform
First you need an account on *Logs Data Platform*, you can find all information you need to begin on the [Logs Data Platform quick start guide](https://docs.ovh.com/gb/en/mobile-hosting/logs-data-platform/quick-start/).

To be able to push logs into the *Logs Data Platform*, you have to get the token, the address and port of your *Logs Data Plateform* stream for Gelf format from the sunrise manager.

you can retrieve the token from the *Logs Data Platform* manager > graylog stream page. There is a "Copy the token" button you can click on :
![graylog stream list](/kb/images/2016-04-21-marathon-logs/token.png)

The address and port can be found on *Logs Data Platform* manager > about page :
![about page](/kb/images/2016-04-21-marathon-logs/about.png)

Be sure to get the port for **Gelf** in **TCP/TLS**, usually it's *12202*.

You will find more information on the [Logs Data Platform quick start guide](https://docs.ovh.com/gb/en/mobile-hosting/logs-data-platform/quick-start/).

#Inject Logs Data Plateform infos into my container
Once you have your token, adress and port, you must inject them into your application containers using the following labels when creating or editing your app.

```
+------------------------------+-------------------+
| Label name                   | Label value       |
+==============================+===================+
| CONTAINERS_LOG_LOGS_SINKADDR | gra1.logs.ovh.com |
+------------------------------+-------------------+
| CONTAINERS_LOG_LOGS_SINKPORT | 12202             |
+------------------------------+-------------------+
| CONTAINERS_LOG_LOGS_TOKEN    | "your token"      |
+------------------------------+-------------------+
```

It will result in something like this in marathon:

![marathon labels](/kb/images/2016-04-21-marathon-logs/labels.png)

You should know see your logs in Graylog. To access Graylog please refer to [Logs Data Platform quick start guide](https://docs.ovh.com/gb/en/mobile-hosting/logs-data-platform/quick-start/).
