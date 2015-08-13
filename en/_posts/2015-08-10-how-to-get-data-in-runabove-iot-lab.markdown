---
layout: post
title: "How to get data in Runabove IOT Lab"
categories: iot opentsdb
lab: iot
tags: iot opentsdb reference
lang: en
author: babelouest
---

Runabove is a lab platform for new projects and new technology. Through this platform you can test labs and new features and connect them with your own environment.

[IOT Labs][6] is an IOT Platform designed to store and retrieve numeric data, and furthermore, automatically compute and process the data.

This documentation is about how to get data from the Runabove IOT Lab. It will explain how to transfer your data from the service via an https REST API.

We assume you have a valid READ token from the solution you're working with. Solutions and token management is explained in the doucmentation [How to push data in Runabove IOT Lab][1]

# Get IOT Data

## Warning

In Runabove IOT Lab, when you generate a pair of tokens for a solution, the READ token allows you to read all data pushed in the same solution. You must be aware of that in the use of your solutions, tokens and data stored.

## Query data from OpenTSDB HTTPS REST API

OpenTSDB has a webservice with a standardized REST API interface to query data.

The endpoint to query data via the webservice is the following: [https://opentsdb.iot.runabove.io/api/query][2]

The webservice uses the verb POST and the data in the http body in json format. The complete documentation for OpenTSDB queries is available in the official [OpenTSDB Documentation][3]

A valid example body has the following form:

```json
{
	"start":1438956901,
	"queries":[{
		"metric":"my.metric",
		"aggregator":"sum",
		"tags":{
		}
	}]
}
```

Please note that Runabove IOT Lab does not implement TSUIDs, so a query filter using TSUID will be ignored.

The other most common parameters are the following:

- start: numeric, start date in Unix Epoch format in seconds (required)plop
- end: numeric, end date in Unix Epoch format in seconds (optional)
- queries: Array, a list of subqueries to filter data (required)

A subquery implements (but not only) the following parameters:

- metric: string, the name of the metric stored (required)
- aggregator: string, the name of the [aggregator function][5] to use (required)

The authentication method is a HTTP Auth using `'x'` as username and your READ token as password.

On success, the body response has the following format:

```json
[{
	"metric":"app.test",
	"tags":{
		".app":"grafana-test",
		"ovh.app":"legacy",
		"tag1":"value1"
	},
	"aggregateTags":[],
	"dps":{
		"1438956980":1,
		"1438957000":4,
		"1438957110":3,
		"1438957280":1
	}
}]
```

In this exemple, the main parameters are the following:

- metrics: string, The metric of the data
- tags: object, the common tags for the data, 
- dps: object, the data itself with the timestamp as key and the numeric value as value.

If you want a more complete information, the query parameters are fully described in the official [OpenTSDB documentation][4].

  [1]: iot-documentation-how-to-push-data-in-runabove-iot-lab.html
  [2]: https://opentsdb.iot.runabove.io/api/query/
  [3]: http://opentsdb.net/docs/build/html/api_http/index.html
  [4]: http://opentsdb.net/docs/build/html/api_http/query/index.html
  [5]: http://opentsdb.net/docs/build/html/api_http/aggregators.html
  [6]: https://runabove.com/iot/
