---
layout: post
title:  "Marathon containers metrics in PaaS Timeseries"
categories: Docker
author: devatoria
lang: en
---

We integrated the Docker PaaS with the [Timeseries PaaS lab](https://www.runabove.com/iot-paas-timeseries.xml), to allow you to graph your application metrics about your containers in a Grafana dashboard. We automatically send metrics for:

- CPU usage
- memory usage
- network I/O
- disk I/O
- out of memory kill count (coming soon!)

#Configure your token

From the RunAbove manager, join the PaaS Timeseries lab and generate a new credentials pair (read/write). Next, inject the write credentials into your applications using `USER_IOT_ID` and `USER_IOT_KEY` labels.

![Main interface](/kb/images/2016-04-21-marathon-metrics/metrics.png)

Metrics are aggregated, averaged and pushed every minute.

#Analyse my data
##Create graphs

Once your applications metrics are sent to the PaaS Timeseries, you can create some graphs to easily watch how your applications behave, and adapt your stack according to your needs. Available metrics for graphs are:

- cpu
- memory.usage
- memory.limit
- network.rx
- network.tx
- blkio.input
- blkio.output

![Main interface](/kb/images/2016-04-21-marathon-metrics/metrics_cpu.png)

###Filtering using tags

On each metrics, you can filter on the following tags:

- frameworkID: your marathon ID (useful if you have multiple stack logging metrics with the same credentials)
- appID: your application ID (useful if you want to graph multiple applications instead of the full stack)
- taskID: your task ID (identifying a single container)

###CPU data

The CPU data are not dependent of the host capacity, but on the limit you are setting in your application. For example, if you create an application with 2 cpus, and if it consumes only one, your CPU usage will be 50%

Be careful though, if you create an application with a cpu limit less than one, let's say 0.5, the application could be able to consume one cpu if needed resources are available. Your CPU usage will be 200%.

To interpret your data in Grafana, you have multiple ways. We have two interesting use cases:

- you have a few apps, or a graph per app: you should filter your CPU usage metrics using the flag `taskID: *` and a `sum aggregate`
- you have a lot of apps to be displayed in a single graph: you should filter your CPU usage metrics using the flag `appID: *` and an `average aggregate`

###Memory data

As for the CPU data, the usage and limit increase depending on your instances count. We recommend to use task ID tags to make the data more readable.

###Networking and disk data

These data are cumulative. We recommend to use rate graphs for these values, so you will be able to see usage variation. Be careful, you can sometime have **negative values**. This usually happens on a scale down because of the rate graph: collected data are cumulative, and when a container is deleted, they are removed from the sum. So, the rate is interpreting this as a negative value.
