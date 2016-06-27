---
layout: post
title:  "Using Timelion with PaaS Logs"
categories: Logs
author: Babacar Diassé
lang: en
---

Timelion is a Kibana plugin wich allows you to query multiple datasources from a single Kibana instance a bit like Grafana. This tool is very powerful to analyze metric contained in logs (or simply the logs count) sent to Elasticsearch (so PaaS Logs here). What you can do include but is not limited to :

 - Compute an average over a period of time, compute a moving average over a period of time
 - Compute the derivative of a metric or the results of a specific query to quickly see the variations. 
 - Doing arithmetic operation between your metric (division, sum, cumulative sum, multiply, percentage...)
 - Grabbing series from other sources to mix your datas with It ([Quandl](https://www.quandl.com), [World Bank Indicators](http://data.worldbank.org/), [Graphite](http://graphite.readthedocs.io/en/latest/)). 

All the informations about this wonderful plugin can be found here :


[https://www.elastic.co/blog/timelion-timeline](https://www.elastic.co/blog/timelion-timeline).


In order to use Timelion, your Kibana access has to be already configured. If you don't have it already, you can visit [this Kibana turtorial](/kb/en/logs/using-kibana-with-laas.html). 
If you're ready, let's get started !

#1 Installing Timelion on Kibana 

The [documentation](https://github.com/elastic/timelion#installation) will help you through the installation process, but here is how do to do it actually : 

 - stop your kibana
 - issue the following from your kibana installation folder `./bin/kibana plugin -i elastic/timelion`
 - restart Kibana. you should see a new Apps Icon Appears, if you click on it you will see Timelion. 


![timelion](/kb/images/2016-02-28-using-timelion-with-laas.md/timelion.png)


#2 Configuring Timelion for PaaS Logs


By default, Timelion use the index \_all to query on your indexes and the field "@timestamp" as the date field. To allow it to use the correct settings, do the following : 
 - In your Kibana Installation, Edit the file located at "installedPlugins/timelion/timelion.json". 
 - Replace timefield with: "timestamp", replace default\_index with the alias you want to use. 
 - Restart Kibana
Note that if you have several aliases, you can of course query them in Timelion using the following syntax .es(index="my\_other\_alias").


#3 Where do I go from here ?

Timelion has a built in help and tutorial to help get you started. To access it, use the tiny "?" icon at the far-right of the interface (just under the main search bar). If you don't see it, use the toggle menu button at the right of the search bar to display it. 

the Elasticsearch commands start by ".es", you can change the resolution of the chart by using the drop down menu at the right of the search bar.  

 - To display all your data at the selected timerange (top right), use:

```
.es(*)
```

 - To display only the data that have a certain field use

```
.es(field:value)
```

 - To display the average on a numeric value present in your logs use : 

```
.es(metric='avg:my_field_num')
```

 - You can display only the variation (derivative) on this value by using the following formula : 

```
.es(metric='avg:my_field_num').derivative()
```

 - To display different data on different yaxis, use the yaxis() functions.

```
.es(metric='avg:my_field_num').derivative(), es(*).yaxis(2)
```

In the following screenshot, you can easily see if there is a correlation between different metrics we have in your softwares (here we tried to find one in HA Proxy between the variation of the bytes\_read and the duration of requests). 


![timelion2](/kb/images/2016-02-28-using-timelion-with-laas.md/timelion-2.png)


  - Every visualization you create through Timelion can be embedded in a Kibana Dashboard so you can further query and refine your datas. 

![dashboard](/kb/images/2016-02-28-using-timelion-with-laas.md/dash.png)


We have only scratched the surface of what you can do with timelion. Head to these resources to learn even more cool tricks. 

 - [Timelion Elastic blog post](https://www.elastic.co/blog/timelion-timeline)
 - [Experiments with Timelion](http://rmoff.net/2016/03/29/experiments-with-kibana-timelion-2/)
 - [45 minutes of Timelion with its creator](https://www.youtube.com/watch?v=L5LvP_Cj0A0)

If you have any trouble to use it or if you want to share your dashboards, feel free to mail us at [paas.logs@ml.ovh.net](mailto:paas.logs@ml.ovh.net) (Subscribe [here](mailto:paas.logs-subscribe@ml.ovh.net) first). 



#Getting Help

- Getting Started : [Quick Start](/kb/en/logs/quick-start.html)
- Documentation : [Guides](/kb/en/logs)
- Mailing List : [paas.logs-subscribe@ml.ovh.net](mailto:paas.logs-subscribe@ml.ovh.net)
- Visit our community: [community.runabove.com](https://community.runabove.com)
- Create an account: [PaaS Logs Beta](https://cloud.runabove.com/signup/?launch=paas-logs)

