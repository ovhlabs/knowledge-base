---
layout: post
title:  "Produce and consume Kafka messages over HTTPS with OVH Queue DBaaS"
categories: queue
author: sebgl
lang: en
---

This tutorial assumes you already have an OVH account and have subscribed to the [Queue DBaaS](https://www.runabove.com/dbaas-queue.xml).
If not, have a look at our [Getting Started](https://community.runabove.com/kb/en/queue/getting-started-with-queue-as-a-service.html) guide that will also introduce you to Kafka

## Why HTTP(S)?

Kafka protocol is built over TCP for multiple reasons, including performance and message ordering.
However we realized that for some use cases, Kafka clients usage can be quite complex since many parameters have to be taken into consideration:

- Number of partitions and partition leaders
- Offset commit
- Consumer groups

According to your programming language of choice, Kafka clients can be more or less efficient and easy to use.
Sometimes what you need is a simpler queue platform that you can use with any programming language. HTTP is the de-facto standard for that usage.

Queue DBaaS platform implements a simple HTTP layer that allows you to:

- Produce one or many messages to your topic with a POST request
- Consume one or many messages from your topic with a GET request

Moreover, it comes with HTTPS support, for free.

## Usage

### Pre-requisite: Know your region

According to how you created your Queue DBaaS app, you chose one of the available region, which can be retrieved on your [Sunrise Manager](https://www.ovh.com/manager/sunrise/dbaasQueue/index.html#/dbaasQueue).
Example: 

```
sbg.queue.ovh.net:9092
```

This corresponds to the "normal" Kafka usage over TCP, required by most Kafka clients.
If you want to use DBaaS Queue over HTTP, you have to use the associated HTTPS URL:

```
https://sbg.queue.ovh.net
```

### Pre-requisite: Know your key and topic prefix

As with traditionnal Queue DBaaS usage with Kafka Clients, you will have to use:

- your key (token)
- your topic prefix

See our [Getting Started guide](https://community.runabove.com/kb/en/queue/getting-started-with-queue-as-a-service.html) for more information.

### Authentication

User authentication is made with a custom HTTP header that you must pass in with your requests:

```
"X-Ovh-Queue-Token: <your-key>"
```

### POST messages

You can post one or multiple messages, using _curl_ or HTTP clients in any language:

```
curl -H "X-Ovh-Queue-Token: <your-key>"
  -XPOST https://sbg.queue.ovh.net/topic/<topic-prefix.topic-name> 
  -d '[{"Value": "first message"},
       {"Value":"second message"}]'
``` 

### GET messages

You can retrieve one or multiple messages, using _curl_ or HTTP clients in any language:

```
curl -H "X-Ovh-Queue-Token: <your-key>"
  https://sbg.queue.ovh.net/topic/<topic-prefix.topic-name>[?limit=2]
```

The optional _limit_ parameter allows you to specify how many messages you want to retrieve.

### Offset management

Offsets are managed automatically at each GET request. It means that each message will be read only once.
We plan to support manual offset and consumer group specification later on.

### Message type

As seen in the examples above, messages are sent through a JSON object, and must be strings.
This does not prevent you from using other data types, by encoding your binary data as base64 for example. 

## Performance concerns

Despite the ease-of-use, using HTTPS instead of TCP implies a performance hit.
To put it simple: if you need a very high read/write throughput, use a normal TCP-based Kafka Client.

As an example, here are numbers on producing and consuming "hello world" messages:

- via a TCP Kafka Client: 200k+ messages per second
- via the HTTPS endpoint: 5-10k messages per second

Note that the number of messages you send or receive with a single HTTP request has an impact on performance: don't hesitate to batch messages together. 


## Contact and feedbacks

Please feel free to contact us for any question, feedback, or improvement that may come to your mind !

- [DBaaS Queue](https://www.runabove.com/dbaas-queue.xml)
- [Mailing list](mailto:dbaas.queue-subscribe@ml.ovh.net)