---
layout: post
title:  "Using Grafana with PaaS Logs"
categories: Logs
author: Pierre De Paepe
lang: en
---

Grafana provides a powerful and elegant way to create, explore, and share dashboards and data with your team and the world.
Since release 2.5, Grafana is able to communicate with Elasticsearch and so allow you to mix data from PaaS Logs and other data sources like IoT at the same place.

This is what you need to know to get you started :  

 - you already sending logs on a stream you own [see the quick start tutorial](/kb/en/logs/quick-start.html)
 - your web server can reach https://laas.runabove.com:9200. 

After some training you will be able to do this kind of Dashboard : 
![Grafana Dashboard](/kb/images/2016-02-28-using-grafana-with-laas/grafana.png)

#1 Setup your Stream Alias

To access your logs from Grafana, you will need to setup an Elasticsearch Alias and link them to your Graylog streams, so here we go again : 

 1. Sign in on [https://www.runabove.com](https://www.runabove.com), PaaS Logs lab section (skip this step if you are already in ;-)
 2. On alias zone, click on blue + button
 3. Choose a name, define a description
 4. Save the entry
 5. Once status marked as OK (refresh page if necessary) click on Associate link
 6. Define there the graylog streams you want to associate to your alias
 7. That's it.

![Alias creation](/kb/images/2016-02-28-using-grafana-with-laas/alias.png)

So here you have, now PaaS Logs knows what is the streams you wnat to browse. Now let's configure Grafana and see if it works ! 

#2 Setup your own grafana

Get last Grafana release here: [http://grafana.org/download/](http://grafana.org/download/) (v3.1.0-beta1 2016-06-23 at the time of writing). Here are some direct links for your convenience. 

 - [DEB (Ubuntu / Debian 64 bit)](https://grafanarel.s3.amazonaws.com/builds/grafana_3.1.0-1466666977beta1_amd64.deb)
 - [RPM (Fedora / RHEL 64 bit)](https://grafanarel.s3.amazonaws.com/builds/grafana-3.1.0-1466666977beta1.x86_64.rpm)
 - [Binary TAR (Linux 64 bit)](https://grafanarel.s3.amazonaws.com/builds/grafana-3.1.0-1466666977beta1.linux-x64.tar.gz)
 - [Binary ZIP (Windows 64 bit)](https://grafanarel.s3.amazonaws.com/winbuilds/dist/grafana-3.1.0-beta1.windows-x64.zip)

Then follow the Grafana installation guide according your platform: [http://docs.grafana.org/installation/](http://docs.grafana.org/installation/)

#3 Launch it ! 

If everything is setup properly, launch your favorite browser, and point it to **http://localhost:3000**
Once logged in with your grafana credentials, reach data sources panel to setup your PaaS Logs datasource:

![Data source](/kb/images/2016-02-28-using-grafana-with-laas/datasource.png)

<div class="notice--warning" style="border: 1px #CE6D00 solid;padding: 10px;">
  <h4 style="margin-top:0;">IMPORTANT</h4>
  <p>To make magic happens, please ensure to:</p>
  <ul>
	<li>Set https://laas.runabove.com:9200 as Url value</li>
	<li>Set your PaaS Logs credentials for Basic auth values</li>
	<li>Set your PaaS Logs alias name as Grafana Index name value</li>
	<li>Change default Time field name to timestamp</li>
	<li>Set 2.x as Elasticsearch version</li>
  </ul>
</div>

Register your data source and test it.

#4 Test it !

Now let's add a simple counter of your logs to a new dashboard.

  1. On dashboard page, click on the green left button and select Add panel => Singlestat
  2. On the bottom right, select your datasource.
  3. That's it :)

If you want to know what you can do with Grafana and Elasticsearch, you can fly to the [official documentation](http://docs.grafana.org/datasources/elasticsearch/) or to this very good resource: [How to effectively use the Elasticsearch data source in Grafana and solutions to common pitfalls](https://blog.raintank.io/how-to-effectively-use-the-elasticsearch-data-source-and-solutions-to-common-pitfalls/)

#Getting Help

- Getting Started : [Quick Start](/kb/en/logs/quick-start.html)
- Documentation : [Guides](/kb/en/logs)
- Mailing List : [paas.logs-subscribe@ml.ovh.net](mailto:paas.logs-subscribe@ml.ovh.net)
- Visit our community: [community.runabove.com](https://community.runabove.com)
- Create an account: [PaaS Logs Beta](https://cloud.runabove.com/signup/?launch=paas-logs)

