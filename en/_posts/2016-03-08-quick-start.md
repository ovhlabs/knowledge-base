---
layout: post
title:  "Quick start"
categories: Logs
author: Babacar Diassé
lang: en
---

Welcome to the quick start tutorial of the PaaS Logs. This Quick start guide will help you to understand the core concepts behind the PaaS Logs and how to send your first logs to the engine. 


#1 Welcome to PaaS Logs. 

If you have already setup a lab, this procedure should be easy for you. 

 - Log into runabove.com and on the console click on the `PaaS Logs` button.   
 - the main interface of PaaS Logs will then appear. 
 - On this page, you have only one action available : `Create user`. You will then have a username in the following form : ra-logs-XXXXX. this username will be the one you will have to use on Graylog and with Kibana later (you will know soon enough how to do it). 

![Create User](/kb/images/2016-03-08-quick-start/start.png)

 - Once you have created your credentials, the main interface will appear. 

![Main interface](/kb/images/2016-03-08-quick-start/manager_start.png)
 

On this interface you can see 4 items :

1. The Streams are the recipient of your logs. When you send a log with the right stream token, it arrives automatically to your stream in a awesome software named Graylog. When you access your stream in Graylog you will be able to search your logs and immediately analyze them. 

2. The Dashboard is the global view of your logs, A Dashboard is an efficient way to exploit your logs and to view global information like metrics and trends about your datas without being overwhelmed by the logs details. 

3. The Roles will give you the control over who can read and access your streams or dashboard.

4. The Aliases will allow you to access directly your datas from your Kibana or using an Elasticsearch query. 


#2 Let's send some logs  ! 

 - The first step to do in order to use the PaaS Logs is to create a stream and to get your token. 
To create a stream it is really simple : click on the blue "+" button in the stream panel.  It will ask you for a name and a description for your stream : 

![new Stream](/kb/images/2016-03-08-quick-start/newStream.png)

 - Once filled, click on the blue "floppy disk" button and that's it ! You have created your first stream. 
By expanding your stream infromation, you will see your X-OVH-TOKEN. This key is the only one you will need to address your stream. Under this token, you will have a direct link to your stream in Graylog. 
![stream Created](/kb/images/2016-03-08-quick-start/newStream_2.png)

PaaS Logs supports several logs formats, each one of them has its own advantages and incovenients. Here are the differents ports you have to use on `laas.runabove.com` for the differents formats available


![inputs-ports](/kb/images/2016-03-08-quick-start/inputs-ports.png)

 - Gelf : This is the native format of logs used by Graylog. This JSON format will allow you to send logs really easily. See: http://docs.graylog.org/en/latest/pages/gelf.html. Use the port `12202` for this format. The Gelf input only accept a nul ('\0') delimiter. 
 - LTSV: this simple format is very efficient and is still human readable. you can learn more about it [here](ltsv.org). Use the port `12200` with a nul ('\0') delimiter or the port `12201` for the line delimiter
 - RFC 5424: This format is one of the most commonly used by logs utility like syslog. It is extensible enough to allow you to send all your datas. More information about it can be found at this link : [RFC 5424](https://tools.ietf.org/html/rfc5424). Use the port `6514` to use this format. 
 - Capn'Proto : The most efficient log format. this is a binary format that will allows you to maintain a low footprint and high speed performance. If you want to know more about it, check the official website : [Cap'n'Proto](https://capnproto.org/). Use the port `12204` to use this format. 

To send your logs to PaaS Logs we can, for example, use echo and openssl. Here is 3 examples, choose the format you like the most with your preffered terminal : 

_Gelf_ : 

 ```bash
echo -e '{"version":"1.1", "host": "example.org", "short_message": "A short message that helps you identify what is going on", "full_message": "Backtrace here\n\nmore stuff", "timestamp": 1385053862.3072, "level": 1, "_user_id": 9001, "_some_info": "foo", "some_metric_num": 42.0, "_X-OVH-TOKEN":"d93eee2a-697f-4bac-a452-705416b98a04"}\0' | openssl s_client -connect laas.runabove.com:12202
```

 
_LTSV_:

 ```bash
echo -e 'X-OVH-TOKEN:d93eee2a-697f-4bac-a452-705416b98a04\thost:example.org\ttime:2016-03-08T14:44:01+01:00\tmessage:A short message that helps you identify what is going on\tfull_message:Backtrace here\n\nmore stuff\tlevel:1\tuser_id:9001\tsome_info:foo\tsome_metric_num:42.0\0'|openssl s_client -connect laas.runabove.com:12200
```

_RFC 5424_:

 ```bash
echo -e '<6>1 2016-03-08T14:44:01+01:00 149.202.165.20 example.org -- [exampleSDID@8485 user_id="9001"  some_info="foo" some_metric_num="42.0" X-OVH-TOKEN="d93eee2a-697f-4bac-a452-705416b98a04"] A short message that helps you identify what is going on'\n | openssl s_client -connect laas.runabove.com:6514
```

 - Click on the Graylog access link in the console to display your logs. You will be redirected to this page : 
![Graylog Stream](/kb/images/2016-03-08-quick-start/graylog-stream.png)
 
Send different logs with differents value for user\_id for example. At the left of the page you will see the fields present in your stream, you can click on the user\_id checkbox to display all the values for this field along the logs.

#3 Lets create a Dashboard. 

Let's go back to the console of PaaS Logs, we will now create a Dashboard that will allow you to exploit your datas in a graphical manner. It is even simpler to create a Dashboard, just click on the "+" button and again fill a description and a title for your Dashboard. Once created, you can use the link displayed to access it immediately. 
At first, your dashboard is sad and empty but we will fill it really soon with some awesome widgets ;-). 
To do that get back to your stream : you can use the link on graylog (under the Stream tab) or the link on your console as you wish.
Let's say you want all the user Id for which the value some\_metric is above 30, first. you search for this data : 
  
 - in the search bar, enter this :
 `some_metric_num:>30`
 
 - select above the search bar, the relative range of time you want to use in your widgets. If you want your widget to display the value on the last hour, select "Search in the last Hour".  
 - On the left panel, unroll the user\_id menu (by clicking on the blue triangle at the left) and select Quick Values. It will then display a nice widget with the distribution of the most frequent user\_ids. 
![Quick Values](/kb/images/2016-03-08-quick-start/quick-values.png)

This widget gives you the most frequent user\_id in the logs of the last hour that have a some\_metric\_num value above 30. 

- To add this really critical information to your dashboard, click on the "add to Dashboard" menu button and select your freshly created Dashboard. Fill a title for your widget and select the representation of your datas. 

Head to the Dashboard by clicking on the Dashboard menu in the Dashboard tab. Head to your Dashboard and contemplate your widget in the Dashboard.  
![critical Dashboard](/kb/images/2016-03-08-quick-start/critical-dashboard.png)

You can also mix different widgets representing differents informations, In this screenshot, you can see that we added a widget that represent the mean values for some\_metric\_num (by using generate chart instead of quick values for the field some\_metric in the stream tab). we also updated the title of the first widget using the little "pen" button at the bottom right of the widget and finally we also changed the disposition of the widgets (using the Unlock button at the top right) and moved everything around.
![critical Dashboard 2](/kb/images/2016-03-08-quick-start/critical-dashboard-2.png)


#4 if you want to go deeper. 

We have only scratched the surface of what PaaS Logs can do for you. you will find soon enough how to : 

  - [Send correctly formatted logs to use custom types as numbers, booleans and other stuffs](/kb/en/logs/field-naming-conventions.html)
  - [Configure your syslog-ng to send your Linux logs to PaaS Logs](kb/en/logs/how-to-log-your-linux.html)
  - Using roles to allow other users of the lab to let them see yours beautiful Dashboards or let them digg in your Streams instead of doing it for them.  
  - Using Alerts to be woken up at 3 AM by an e-mail when your world collapse. 
  - [Using Kibana and aliases to unleash the power of elasticsearch](/kb/en/logs/using-kibana-with-laas.html)
  - If you want to master Graylog, this is the place to go : [Graylog documentation](http://docs.graylog.org/en/1.3/pages/queries.html)


#Getting Help

- Getting Started : [Quick Start](/kb/en/logs/quick-start.html)
- Documentation : [Guides](/kb/en/logs)
- Mailing List : [paas.logs-subscribe@ml.ovh.net](mailto:paas.logs-subscribe@ml.ovh.net)
- Visit our community: [community.runabove.com](https://community.runabove.com)
- Create an account: [PaaS Logs Beta](https://cloud.runabove.com/signup/?launch=paas-logs)

