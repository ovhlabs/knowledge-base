---
layout: redirected
title:  "Using Timelion with PaaS Logs"
categories: Logs
author: Babacar Diassé
lang: en
sitemap: false
redirect_to: https://docs.ovh.com/gb/en/mobile-hosting/logs-data-platform/using-timelion-with-logs/
---

Timelion is a Kibana plugin wich allows you to query multiple datasources from a single Kibana instance a bit like Grafana. This tool is very powerful to analyze metric contained in logs (or simply the logs count) sent to Elasticsearch (so PaaS Logs here). What you can do include but is not limited to :

 - Compute an average over a period of time, compute a moving average over a period of time
 - Compute the derivative of a metric or the results of a specific query to quickly see the variations. 
 - Doing arithmetic operation between your metric (division, sum, cumulative sum, multiply, percentage...)
 - Grabbing series from other sources to mix your datas with It ([Quandl](https://www.quandl.com), [World Bank Indicators](http://data.worldbank.org/), [Graphite](http://graphite.readthedocs.io/en/latest/)). 

All the informations about this wonderful plugin can be found here :

