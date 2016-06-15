---
layout: post
title:  "Getting started with OVH Queue PaaS"
categories: queue
author: guillaumebreton
lang: en
---
# OVH Queue PaaS and Kafka 101

Welcome to the getting started guide of the OVH Queue PaaS. This guide will help you to understand the core concepts behind the OVH Queue PaaS
and how to produce your first message to the platform and consume it.

## What is the OVH Queue PaaS ?

It provides you a shared queuing system based on [Apache Kafka](http://kafka.apache.org/).

It powers fast, scalable and global low-latency messaging allowing you to connect anything to everything.

It is a solution to send and receive messages between independent applications, to decouple systems and components or
to connect, build, and scale realtime applications.

## What is Kafka ?

Kafka is a high-throughput, distributed, publish-subscribe messaging system.
It allows you to connect producers and consumers through topics with fault tolerance as well as journalized events.
All messages are persisted on disk and replicated within the cluster to prevent data loss.

## What is a producer and a consumer ?

![prod_consumer_description](/kb/images/2016-06-15-getting-started-with-queue-as-a-service/queue_description.png)

Kafka maintains feeds of messages in topics. Producers write data to topics and
consumers read from topics. Since Kafka is a distributed system, topics are partitioned
and replicated across multiple nodes.
Each message in a partition is assigned a unique offset. A consumer can save its offset position
to remember the messages read.

# Getting started

The OVH Queue PaaS has been built so that you can connect painlessly to it.
Topics are automatically created at the first request and a partitionning strategy is applied by default.

## Joining the lab

Before starting to use the [Queue PaaS lab](https://www.runabove.com/paas-queue.xml) you need to make sure that you have
an OVH.com account.

Go to [ovh.com](https://www.ovh.com/manager/web/login/) and
select "Create Account".

## Create an application

The first step to use OVH Queue PaaS is to create an application.

1. Go to the [Queue PaaS lab page](https://www.runabove.com/paas-queue.xml) and click on the
**Start Now** button.

2. Follow the order steps. You will receive an email as soon as your application is ready.

3. Go to the [OVH Manager](https://www.ovh.com/manager/sunrise/index.html).

    ![Sunrise](/kb/images/2016-06-15-getting-started-with-queue-as-a-service/queue_sunrise.png)

4. In the Sunrise manager, a new 'Not configured app' is available under the Queue PaaS section.

    ![Sunrise](/kb/images/2016-06-15-getting-started-with-queue-as-a-service/queue_not_configure_app_menu.png)

5. Select the application. Choose its name, select a region and save it.

    ![Sunrise](/kb/images/2016-06-15-getting-started-with-queue-as-a-service/queue_not_configure_app.png)

## Create a key

Once your application is created and configured, you will need a key to be able to write and read data.

1. In the previously created app, click on the **new key** button.

    ![Sunrise](/kb/images/2016-06-15-getting-started-with-queue-as-a-service/queue_configured_app.png)

2. Give it a name.

    ![Sunrise](/kb/images/2016-06-15-getting-started-with-queue-as-a-service/queue_new_key.png)

3. Save the generated key in your secrets (the key is only displayed once. If you forget it you can regenerate it.)

    ![Sunrise](/kb/images/2016-06-15-getting-started-with-queue-as-a-service/queue_created_key.png)

## Produce and consume

**Important**: to be authenticated to the Queue PaaS, you must:

- Set a key as the `client id` of your Kafka client.
- Use a human application id to prefix all your topics (the id can be found in the [OVH Manager](https://www.ovh.com/manager/sunrise/index.html))

## Produce

1. Download the [golang queue example](https://github.com/runabove/queue-examples/releases).

2. Start a consumer

    ```
    ./qaas-client-$(uname -s)-amd64 consume --kafka $HOST:9092 --key $KEY --topic $PREFIX.$TOPIC --group ${PREFIX}.queue-example
    ```

3. Start a producer and write something to stdin to produce one message (the topic is automatically created).

    ```
    ./qaas-client-$(uname -s)-amd64 produce --kafka $HOST:9092 --key $KEY --topic $PREFIX.$TOPIC
    # Then write to STDIN to send a message
    ```

# Supported Languages

The OVH Queue PaaS supports any [Kafka standard client](https://cwiki.apache.org/confluence/display/KAFKA/Clients).

In the [queue examples repository](https://github.com/runabove/queue-examples), you can find examples for:

  - [Golang](https://github.com/runabove/queue-examples/tree/master/golang)
  - [NodeJS](https://github.com/runabove/queue-examples/tree/master/nodejs)
  - [Python](https://github.com/runabove/queue-examples/tree/master/python)
  - [Scala](https://github.com/runabove/queue-examples/tree/master/scala)

# Going further

- [Kafka documentation](http://kafka.apache.org/documentation.html#introduction)
