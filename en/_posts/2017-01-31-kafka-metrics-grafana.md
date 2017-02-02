---
layout: post
title:  "Display Kafka metrics using Grafana"
categories: queue
author: thcdrt
lang: en
---

## Introduction

This tutorial assumes you already have an OVH account, have subscribed to [OVH Kafka](https://www.runabove.com/dbaas-queue.xml) and have created an OVH Kafka application.

If you don't, have a look at our [Getting Started](https://community.runabove.com/kb/en/queue/getting-started-with-queue-as-a-service.html) guide that will also introduce you to Kafka.

This guide will help you to understand step by step how to display your Kafka applications metrics using [Grafana](https://grafana.tsaas.ovh.com) and the [Metrics Data Platform](https://www.ovh.com/fr/data-platforms/metrics/).

## Preparation
### Get your application token to use the Metrics API
Read the token using this link: [Token OVH API](https://api.ovh.com/console/#/dbaas/queue/%7BserviceName%7D/metrics/account#GET).

![Application Token](/kb/images/2017-01-31-kafka-metrics-grafana/token.png)

The token is composed by 2 parts: the user and the password. Save both somewhere safe.

Note: The `serviceName` required must be your OVH Kafka application ID. You can find it in your [OVH manager](https://www.ovh.com/manager/sunrise/dbaasQueue/index.html#/dbaasQueue) when you click on the "DBaaS Queue" menu. On the left you can see the list of your applications including their IDs:

![Application ID](/kb/images/2017-01-31-kafka-metrics-grafana/application_id.png)

## Grafana configuration
Open [OVH Grafana](https://grafana.tsaas.ovh.com) and log in with your OVH account.
To configure a new datasource, you first need to create your own organization.

### Create your own organization

Once you're logged in, go in the top left hand corner menu (with the Grafana logo), and click on your name, then a submenu is opened, click on "+ New Organization":

![New Organization](/kb/images/2017-01-31-kafka-metrics-grafana/new_organization.png)

Fill the organization name that you want and create it.

### Configure a datasource

Now go back in the menu, you should see now an item called "Data Sources".

![New Data Source](/kb/images/2017-01-31-kafka-metrics-grafana/data_source.png)

Click on it.
Then click on the "Add data source" button to configure one as below:

HTTP Settings:

  - Name: This is up to you
  - Type: OpenTSDB
  - Url: https://opentsdb-gra1.tsaas.ovh.com
  - Access: Proxy
  - Http Auth: Basic Auth: true
  - With Credentials: false
  - User: The first part of the token (before the semi-colon) that you got previously.
  - Password: The second part of the token (after the semi-colon).

OpenTSDB Settings:

  - Version: ==2.2
  - Resolution: second

Then add it.

### Create a dashboard

Go back once again in the menu, go in "Dashboards" and click on "New".
You should have a blank page. On the left under the menu, you should see a green menu.

### Display Metrics on a Graph

Open it and click on "Add Panel" -> "Graph".

![New Graph](/kb/images/2017-01-31-kafka-metrics-grafana/new_graph.png)

#### Graph general configuration

Let's fill the "Metrics" tab, which is the most important. Firstly in "Panel data source", select the datasource that you just created:

![New Graph](/kb/images/2017-01-31-kafka-metrics-grafana/select_datasource.png)

Then fill the fields:

  - Metric: kafka.bytes-in-per-sec.m1 or kafka.bytes-in-per-sec.m1 or
   kafka.bytes-out-per-sec.m1 depending on what you want to visualize.
  - Aggregator: You can choose the aggregator that you want, knowing that by default it will be used to aggregate your differents topics.

 At this step you should see a graph aggregating all your topics:

![Graph without tag](/kb/images/2017-01-31-kafka-metrics-grafana/graph_without_tag.png)

Optional: If you prefer to see a different graph for each topic, you can set the alias and tag as below:

 - Alias: [[tag_topic-name]]
 - Tags (Add a new one): key=topic-name, value=*
The star allows to see metrics per topic. You can choose to display just one replacing the star by the name of the topic wished.

Now you should see each topic separated from the others:

![Graph with tag](/kb/images/2017-01-31-kafka-metrics-grafana/graph_with_tag.png)

You can now personalize your graph as you wish using the others configuration tabs.

#### Graph further configuration

 - "General" tab: Change the title of your graph
 - "Axes" tab: Modify the axes units, scale, range
 - "Legends" tab: Modify the legend format
 - "Display" tab: Change the graph appearance
 - "Time Range": Modify the X range, you can for exemple choose to only see the last hour, or the last 24 hours of data. Moreover you can shift the period displayed

Happy graphing!

## Go further

- [DBaaS Queue](https://www.runabove.com/dbaas-queue.xml)
- [Grafana Documentation](http://docs.grafana.org/)
- [Keep in touch with us!](mailto:dbaas.queue-subscribe@ml.ovh.net)
