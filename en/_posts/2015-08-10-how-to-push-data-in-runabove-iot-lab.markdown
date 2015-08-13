---
layout: post
title: "How to push data in Runabove IOT Lab"
categories: iot opentsdb
lab: iot
tags: iot opentsdb reference
lang: en
author: babelouest
---

Runabove is a lab platform for new projects and new technology. Through this platform you can test labs and new features and connect them with your own environment.

[IOT Labs][1] is an IOT Platform designed to store and retrieve numeric data, and furthermore, automatically compute and process the data.

This documentation is about how to push data into the Runabove IOT Lab. It will explain the architecture including the token management and how to transfer your data to the service via an https webservice or a pseudo secured telnet session.

We assume you have a valid Runabove account and have subscribed to the IOT Lab. This documentation will explain how to use the lab but it needs you to already have complete those steps.

# Solution and Token management

In order to push and get data from IOT Lab, a token generator is provided as authentification factor to send data streams. In this case, a token system is more flexible and optimized than a user/password system. A lab user can create, modify and revoke different sets of tokens independently very easily.

A user can create, modify and remove solutions, and in each of them, the user can generate, modify and revoke tokens sets. A pair of token is composed of a READ and a WRITE token.

In this documentation, we will simply describe solution and token management through Runabove UI. A more complete documentation for solutions and token management can be found in the following Runabove Documentations: [Solution management][7], [Token management][8].

## Solution management

In Runabove IOT Lab, you can add, modify and delete solutions. A solution is dedicated to a cluster where the data is stored. A solution has a name (alphanumeric and dash characters only), a description and a cluster. The cluster represent where the data will be stored, so after creation, a solution can't be moved to another cluster.

## Token management

When you have created a solution, you can generate and manage pairs of tokens in this solution. Each token pair is characterized with a description, an expiration date, a tag list with keys and a value for each key, and 2 token strings: READ and WRITE. In the chapter below, you will learn how to use the WRITE token to push data in your IOT Lab.

When you have generated a pair of token, you are ready to push your own data in the IOT Lab.

# IOT Data push

## Warning

In Runabove IOT Lab, when you generate a pair of tokens for a solution, the READ token allows you to read all data pushed in the same solution. You must be aware of that in the use of your solutions, tokens and data stored.

## Before you start

In IOT Lab, each data must be provided with a metric and a timestamp value. You can also improve the metadata with an additional set of tags. Each tag is a pair of key and value.

When you push data in IOT Lab, you have to use a valid WRITE Token provided by the token management. The data will be authenticated with the token provided, as metadata, you will also have its solution and the token tags. You can also provide additional tags for any purpose (identification, grouping, filter, geolocalisation, etc.).

The metric metadata will represent the type of data you send such as `"cpu.temp"` or `"network.packets.in"`. Characters allowed are letters, numbers, dash and points ([a-zA-Z0-9-.]). The timestamp is in Epoch Unix format (in seconds).

Sample programs are available and written in different languages (C, Java, Python, Go) as examples to help you write your own programs to push data. The source code of the sample is available [here][5]. You can also find [Unix shell scripts][6] using command-line tools to push data.

## Push data via a HTTPS Webservice

OpenTSDB has a webservice with a standardized interface to push data.

The endpoint to push data via the webservice is the following: [https://opentsdb.iot.runabove.io/api/put/][4]

The webservice uses the verb POST and the data in the http body is in json format.

A valid example body has the following form:

```json
[{
	"metric":"app.test",
	"timestamp":1437591536,
	"value":1,
	"tags":{
		"key1":"value1",
		"key2":"value0",
		"ovh.auth":"xyv123xyv123xyv123xyz123"
	}
},{
	"metric":"app.test",
	"timestamp":1437591539,
	"value":2,
	"tags":{
		"key1":"value1",
		"key2":"value2",
		"ovh.auth":"xyv123xyv123xyv123xyz123"
	}
}]
```

In this example, the parameters are the following:

- metric: string, the metric used to name the data type (required)
- timestamp: numeric, the timestamp associated with the value in Unix Epoch format in seconds (required)
- value: numeric, the valu itself (required)
- tags: object, a set of additional tags for the data (optional, except for the tag ovh.auth)

The parameters are fully described in the [OpenTSDB documentation][2]. A tag ovh.auth is mandatory and must contain your WRITE token as value.

On success, the response is a 2xx HTTP Response code. On error, the response code and the response body will explain the issue.

## Push data via Telnet Protocol

OpenTSDB offers also a telnet protocol to push data. To use it, you must connect to the host opentsdb.iot.runabove.io:4243 with a TLS connection.

When you are connected, you can ask for the complete command list by typing `help` and quit by typing `exit`. The command `version` will show you the OpenTSDB version of the server.

To push data in telnet mode, you must use a command `put` for each data. The format of `put` is:

`put <metric> <timestamp> <value> <tagk1=tagv1[tagk2=tagv2 ...tagkN=tagvN]>`

As in the https webservice, to authenticate your data, you must provide the token. You can specify the token in a tag using the tag `ovh.auth=xyv123xyv123xyv123xyz123`, but you can also specify the WRITE token once per telnet session using the command `auth <token>` before the `put` commands. This last option can help you save bandwidth and CPU cycles.

If the data is properly stored, no answer will be sent from the server. On the contrary, if an error occurs, the server will send you an error message explaining the issue.

# Conclusion

When your data is properly sent into the Runabove IOT Lab platform, you can start managing the data for your needs. This will be explained in the documentation [How to get data in Runabove IOT Lab][3]

  [1]: https://runabove.com/iot/
  [2]: http://opentsdb.net/docs/build/html/api_http/put.html
  [3]: iot-documentation-how-to-get-data-in-runabove-iot-lab.html
  [4]: https://opentsdb.iot.runabove.io/api/put/
  [5]: http://url.to.sample.code.source/
  [6]: http://url.to.sample.shell.scripts/
  [7]: how-to-create-new-solutions.html
  [8]: how-to-manage-tokens.html
