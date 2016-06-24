---
layout: post
title:  "Using Kibana with PaaS Logs"
categories: Logs
author: Babacar Diassé
lang: en
---

You want to unleash the full power of Kibana and be able to craft some beautiful Dashboards from your logs. Rest assured, you have come to the right place. 
Kibana is a powerful weapon, the knowledge you are about to read needs you to have reached a certain level (but way below 9000) in the understanding of PaaS Logs. This is what you need to know to get you started :  

 - you are already sending logs on a stream you own [see the quick start tutorial](/kb/en/logs/quick-start.html)
 - your web server can reach https://laas.runabove.com:9200. 

After some training you will be able to do this kind of Dashboard : 
![Kibana Dashboard](/kb/images/2016-02-29-using-kibana-with-laas/kibana.png)


#1 Setup your Kibana index
Kibana requires an index where to store your dashboards and other settings. To create it in our Elasticsearch cluster:
 
 1. Sign in on [https://www.runabove.com](https://www.runabove.com)
 2. On PaaS Logs lab section, click on link Enable Kibana indice

![Enable indice](/kb/images/2016-02-29-using-kibana-with-laas/indice.png)

That was easy right ? If you are not too tired, proceed with the next section. 

#2 Select your Stream Alias

To access your logs from Kibana, you will need to setup an Elasticsearch Alias and link them to your Graylog streams, so here we go again : 

 1. Sign in on [https://www.runabove.com](https://www.runabove.com), PaaS Logs lab section (skip this step if you are already in ;-)
 2. On alias zone, click on blue + button
 3. Choose a name, define a description
 4. Save the entry
 5. Once status marked as OK (refresh page if necessary) click on Associate link
 6. Define there the graylog streams you want to associate to your alias
 7. That's it.

![Alias creation](/kb/images/2016-02-29-using-kibana-with-laas/alias.png)

So here you have, now PaaS Logs knows what is the streams you wnat to browse. Now let's configure Kibana and see if it works ! 

#3 Setup your own kibana
Get last Kibana **4.5.X** for **Elasticsearch 2.x** here [https://www.elastic.co/downloads/kibana](https://www.elastic.co/downloads/kibana) (4.5.1 at the time of writing). Here are some direct links for your convenience.

 - [WINDOWS](https://download.elastic.co/kibana/kibana/kibana-4.5.1-windows.zip)
 - [MAC](https://download.elastic.co/kibana/kibana/kibana-4.5.1-darwin-x64.tar.gz)
 - [LINUX 64-BIT](https://download.elastic.co/kibana/kibana/kibana-4.5.1-linux-x64.tar.gz)
 - [LINUX 32-BIT](https://download.elastic.co/kibana/kibana/kibana-4.5.1-linux-x86.tar.gz)


Unzip the archive anywhere on your machine.
To configure the Kibana, edit config/kibana.yml and set the following properties:

    port: 5601
    # The host to bind the server to.
    host: "0.0.0.0"

     
    # The Elasticsearch instance to use for all your queries.
    elasticsearch_url: https://laas.runabove.com:9200
     
    # preserve_elasticsearch_host true will send the hostname specified in `elasticsearch`. If you set it to false,
    # then the host you use to connect to *this* Kibana instance will be sent.
    elasticsearch_preserve_host: true
     
    # Kibana uses an index in Elasticsearch to store saved searches, visualizations
    # and dashboards. It will create a new index if it doesn't already exist.
    kibana_index: kibana-ra-logs-XXXXX
     
    # If your Elasticsearch is protected with basic auth, this is the user credentials
    # used by the Kibana server to perform maintenance on the kibana_index at startup. Your Kibana
    # users will still need to authenticate with Elasticsearch (which is proxyfied through
    # the Kibana server)
    kibana_elasticsearch_username: ra-logs-XXXXX
    kibana_elasticsearch_password: YOUR_PAAS_LOGS_PASSWORD

#4 Launch it ! 

If everything is setup properly, you should be able to start it by calling bin/kibana. Launch your favorite browser, and point it to **http://localhost:5601**
On first page, for Index name or pattern give the name of your alias.
Choose timestamp for Time-field name then click on Discover tab to read your log entries.

If you want to know what you can do with Kibana, you can fly to the [very good Elastic documentation](https://www.elastic.co/guide/en/kibana/4.1/index.html) 


#Getting Help

- Getting Started : [Quick Start](/kb/en/logs/quick-start.html)
- Documentation : [Guides](/kb/en/logs)
- Mailing List : [paas.logs-subscribe@ml.ovh.net](mailto:paas.logs-subscribe@ml.ovh.net)
- Visit our community: [community.runabove.com](https://community.runabove.com)
- Create an account: [PaaS Logs Beta](https://cloud.runabove.com/signup/?launch=paas-logs)

