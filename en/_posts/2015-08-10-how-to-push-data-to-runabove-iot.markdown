---
layout: post
title: "How to push data to RunAbove IoT Lab"
categories: iot
tags: iot opentsdb
lang: en
author: babelouest
---

The [Runabove IoT Lab][1] is an Internet of Things Platform designed to store and retrieve numeric data, and automatically compute and process the data.

This tutorial explains how to push data into the IoT metrics storage. It assumes you have a valid RunAbove account and have subscribed to the IoT Lab.

In order to push and get data from IoT Lab, you first have to create an application and a token. See the [application and token management tutorial][7] for this. You will need a WRITE token's identifier and key.

All connections to the IoT Lab metrics storages are encrypted using TLS and authenticated with your tokens.

# Pushing IoT metrics

## Metric name, value and tags

Every time series in the IoT Lab metric storage is identified by:

- the metric name, representing what is measured, e.g. `temperature`, `speed`, `humidity`
- metric tags, that identify the source of the metric, e.g. `room=cellar` for temperature or humidity, `car=5BBM99` for speed.

The combination of metric name and tags and their value uniquely identify a time series.

Separating metric name and tag values allow to easily select entire collections of time series to perform calculations and aggregations. So you have to "design" your metric names and tags according to how you plan to filter and aggregate metrics afterwards.

Allowed characters for metric names, tag names and tag values are letters, numbers, dash and points ([a-zA-Z0-9-.]). Timestamps are in Unix Epoch format, either in seconds or milliseconds.

In IoT Lab, each data must be provided with a metric and a timestamp value. You can also improve the metadata with an additional set of tags. Each tag is a pair of key and value.

When you push data in IoT Lab, you have to use a valid WRITE Token provided by the token management. The data will be authenticated with the token provided, as metadata, you will also have its application and the token tags. You can also provide additional tags for any purpose (identification, grouping, filter, geolocalisation, etc.).

The metric metadata will represent the type of data you send such as `"cpu.temp"` or `"network.packets.in"`. Characters allowed are letters, numbers, dash and points ([a-zA-Z0-9-.]). The timestamp is in Epoch Unix format -- both seconds and milliseconds are accepted.

## Sample programs

Sample programs are available and written in different languages (C, Java, Python, Go) as examples to help you write your own programs to push data. The source code of the sample is available [here][5]. You can also find [Unix shell scripts][6] using command-line tools to push data.

## Pushing data via a HTTPS

The IoT Lab metric storage uses the [OpenTSDB](http://opentsdb.net/) API to push data. Authentication is handled using HTTP Basic authentication, using the WRITE token id as user name, and the token key as password.

The endpoint to push data via the webservice is `https://opentsdb.iot.runabove.io/api/put/`. It uses the POST method with metric values in a JSON request body.

A valid request body has the following form:

```json
[{
	"metric":"app.test",
	"timestamp":1437591536,
	"value":1,
	"tags":{
		"key1":"value1",
		"key2":"value0",
	}
},{
	"metric":"app.test",
	"timestamp":1437591539,
	"value":2,
	"tags":{
		"key1":"value1",
		"key2":"value2",
	}
}]
```

The parameters are as follows:

- metric: string, the metric used to name the data type (required)
- timestamp: numeric, the timestamp associated with the value in Unix Epoch format in seconds or milliseconds (required)
- value: numeric, the valu itself (required)
- tags: object, a set of additional tags for the data

The parameters are fully described in the [OpenTSDB documentation][2].

On success, the response is a 2xx HTTP Response code. On error, the response code and the response body will explain the issue.

## Pushing data via the Telnet Protocol

OpenTSDB offers also a telnet protocol (text over TCP/IP) to push data. To use it, you must connect to `opentsdb.iot.runabove.io:4243` with a TLS connection.

When you are connected, you can ask for the complete command list by typing `help` and quit by typing `exit`.

To push data in telnet mode, you must use a command `put` for each data. The format of `put` is:

`put <metric> <timestamp> <value> <tagk1=tagv1[tagk2=tagv2 ...tagkN=tagvN]>`

As in the https endpoint, you must provide a valid WRITE token. The OpenTSDB telnet has no native support for authentication, so the IoT Lab added ways to pass the token. Two methods are available, depending on what your environment allows:

- send the token in a special tag: `ovh.auth=<token-id>:<token-key>` (token id and key separated with a colon). This tag only serves for authentication purposes and is not stored in the metrics storage.
- use the special `auth` command before sending metrics. The format for this command is `auth <token-id>:<token-key>` (token id and key separated with a colon).

Using the `auth` command is recommended to save bandwidth and CPU cycles, but you may not be able to send it when using existing tools. The `ovh.auth` tag is there for these situations.

If the data is properly stored, no answer will be sent from the server. If an error occurs, the server will send back an error message explaining the issue, and close the connection.

# Using your data

When your data is properly sent into the RunAbove IoT Lab platform, you can start managing the data for your needs. This is explained in the tutorial [How to get data from the RunAbove IoT metrics storage][3]

  [1]: https://runabove.com/iot/
  [2]: http://opentsdb.net/docs/build/html/api_http/put.html
  [3]: how-to-get-data-from-runabove-iot.html
  [5]: http://url.to.sample.code.source/
  [6]: http://url.to.sample.shell.scripts/
  [7]: how-to-manage-applications-using-runabove-manager.html
