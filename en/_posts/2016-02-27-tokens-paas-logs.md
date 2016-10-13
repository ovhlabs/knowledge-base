---
layout: redirected
title:  "Using tokens to query PaaS Logs"
categories: Logs
author: Babacar Diassé
lang: en
sitemap: false
redirect_to: https://docs.ovh.com/gb/en/mobile-hosting/logs-data-platform/tokens-logs-data-platform/ 
---


With PaaS Logs, there are 3 ways to query your logs.
 
 - The [Graylog Web Interface](https://graylog.laas.runabove.com)
 - The [Graylog API](https://laas.runabove.com:12900/api-browser#!/Search/Relative)
 - The [Elasticsearch API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search.html) located at https://laas.runabove.com:9200 against your [alias](/kb/en/logs/using-kibana-with-laas.html#alias). 


So you can pop up a [Kibana](/kb/en/logs/using-kibana-with-laas.html) or a [Grafana](/kb/en/logs/using-grafana-with-laas.html) or even [a terminal Dashboard for Graylog](https://github.com/Graylog2/cli-dashboard). All these accesses are secured by your username and password. But what if you don't want to put your PaaS Logs credentials everywhere? You can just use tokens to access all these endpoints and revoke them anytime you want. This tutorial is here to tell you how.

