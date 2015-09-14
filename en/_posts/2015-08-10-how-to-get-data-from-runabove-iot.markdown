---
layout: post
title: "How to get data from the RunAbove IoT metrics storage"
categories: iot
lang: en
author: babelouest
---

[IoT Labs][6] is an Internet of Things Platform designed to store and retrieve metric data, and automatically compute and process that data.

This documentation is about how to get data from the RunAbove IoT metrics storage. It explains how to transfer your data from the service via an https REST API.

We assume you have a valid READ token from the application you're working with. Applications and token management is explained in the [How to push data to the RunAbove IoT metrics storage][1]

# Get IoT Metrics Data

## Query data from OpenTSDB HTTPS REST API

The Runabove Metrics Storage system can be queried using a subset of the OpenTSDB REST API. [OpenTSDB](http://opentsdb.net) is a popular open source time series database which is integrated in many third-party tools such as [collectd](https://collectd.org/wiki/index.php/Plugin:OpenTSDB) or [Grafana](http://grafana.org/)

The endpoint to query data via the webservice is at `https://opentsdb.iot.runabove.io/api/query`

This endpoint uses the POST method, expecting data in the request body in JSON format. The complete documentation for OpenTSDB queries is available in the official [OpenTSDB Documentation][3]

A valid example body has the following form:

```json
{
	"start":1438956901,
	"queries":[{
		"metric":"my.metric",
		"aggregator":"sum",
		"tags":{
		    "boxid": "1F43"
		}
	}]
}
```

Please note that RunAbove IoT Metrics Storage does not implement TSUIDs, so a query filter using TSUID will be ignored.

The other most common parameters are the following:

- start: numeric, start date in Unix Epoch format in seconds (required)
- end: numeric, end date in Unix Epoch format in seconds (optional)
- queries: Array, a list of subqueries to filter data (required)

A subquery accepts (but not only) the following parameters:

- metric: string, the name of the metric stored (required)
- aggregator: string, the name of the [aggregator function][5] to use (required)

The authentication method is a HTTP Basic Auth using a read token: use the token id as the username, and the token key as the password.

On success, the body response has the following format:

```json
[{
	"metric":"my.metric",
	"tags":{
		"boxid":"1F43"
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

- metrics: string, the metric name
- tags: object, the common tags for the data,
- dps: object, the data points with the timestamp as key and the numeric value as value.

For a complete description, the query parameters are fully described in the official [OpenTSDB documentation][4].

  [1]: /kb/en/iot/how-to-push-data-to-runabove-iot.html
  [3]: http://opentsdb.net/docs/build/html/api_http/index.html
  [4]: http://opentsdb.net/docs/build/html/api_http/query/index.html
  [5]: http://opentsdb.net/docs/build/html/api_http/aggregators.html
  [6]: https://runabove.com/iot/
