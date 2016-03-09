---
layout: post
title:  "Sending Apache Access Logs in PaaS Logs"
categories: Logs
author: Babacar Diassé
lang: en
---


Apache access logs are very valuable. They show the activity of your visitors, the page delivery time, the code results, the user agent that accessed your websites.
The default log line looks like this

```
51.255.160.250 - - [23/Jan/2016:19:33:03 +0100] "GET / HTTP/1.1" 200 14211 "-" "Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.7.12) Gecko/20050915 Firefox/1.0.7"
```

This is already giving a lot of information but it can be troublesome to extract really useful data from plain text logs.
You maybe know that there is a already lot of ways to export your Apache logs: logstash, beats, graylog-collector, syslog-ng, rsyslog, gelf apache module. But as we have still a lot to explore in the PaaS Logs, let's start with something simple :-).
This tutorial will present you the less intrusive way to log to PaaS Logs : ask Apache to pipe log entries directly to PaaS Logs.

#1 Requirements 

In order to achieve this amazing task, we still need to review our check list. For this tutorial you will need:
  
  - The openssl package: as we are using it to send the logs in a secured manner.
  - To create at least one log token (refer to our [quick start guide](/kb/en/logs/quick-start.html) for that).
  - Have enough will to copy and paste 3 lines and change 32 characters.

#2 Apache configuration
We will configure one virtual Host to send all of its logs to your stream, you will have to repeat this configuration to every stream in order to make it work. 

We use CustomLog format directive to transform Apache logs in LTSV format and ship it to LaaS with the proper OVH token.
Please create the file /etc/httpd/conf.d/laas.conf or /etc/apache2/conf.d/laas.conf (it depends of your ditribution) and insert the following

```apache
 LogFormat "X-OVH-TOKEN:0d50bffc-xxxx-xxxx-xxxx-a3413f96762b\tdomain:%V\thost:%h\tserver:%A\tident:%l\tuser:%u\ttime:%{{"{%"}}d/%b/%Y:%H:%M:%S%z}t\tmethod:%m\tpath:%U%q\tprotocol:%H\tstatus_int:%>s\tsize_int:%b\treferer:%{Referer}i\tagent:%{User-Agent}i\tresponse_time_int:%D\tcookie:%{cookie}i\tset_cookie:%{Set-Cookie}o\tmessage:%h %l %u %t \"%r\" %>s %b\n" combined_ltsv 
 CustomLog "|/usr/bin/openssl s_client -connect laas.runabove.com:12201" combined_ltsv
  ErrorLog syslog:local1
```

Ensure that the full path of openssl is correct for your system or it won't work.
Ensure also that your X-OVH-TOKEN is properly written.
This tutorial covers only how to send your access logs to PaaS Logs. to send your Error logs, you should configure your syslog template to send logs to PaaS Logs.

## 2.1 Additional VirtualHost configuration
If you have already a CustomLog definition in your VirtualHost configuration, add a second one to send logs to OVH:

```apache
    <VirtualHost *:80>
      ServerName www.example.com
      ServerAlias example.com
      DocumentRoot /var/www/www.example.com
     
      LogLevel warn
      ErrorLog /var/log/httpd/www.example.com_error.log
      CustomLog /var/log/httpd/www.example.com_access.log combined
      CustomLog "|/usr/bin/openssl s_client -connect laas.runabove.com:12201" "X-OVH-TOKEN:0d50bffc-xxxx-xxxx-xxxx-a3413f96762b\tdomain:%V\thost:%h\tserver:%A\tident:%l\tuser:%u\ttime:%{{"{%"}}d/%b/%Y:%H:%M:%S %z}t\tmethod:%m\tpath:%U%q\tprotocol:%H\tstatus_int:%>s\tsize_int:%b\treferer:%{Referer}i\tagent:%{User-Agent}i\tresponse_time_int:%D\tcookie:%{cookie}i\tset_cookie:%{Set-Cookie}o\tmessage:%h %l %u %t \"%r\" %>s %b\n"
      ErrorLog syslog:local1
     </VirtualHost>
```

This is what you got on Graylog when you send your logs to PaaS Logs. The logs are already nicely parsed and you can immediately do specific search among them: 

![apache Logs](/kb/images/2016-02-25-apache-logs/apache-logs.png)

#3 Apache logs format

If you want to use your own log format and include some useful informations here is a cheat sheet for you: 

![Cheat Sheet](/kb/images/2016-02-25-apache-logs/cheatsheet.png)


The full list of logs formats that can be used in Apache are described here [http://httpd.apache.org/docs/current/en/mod/mod\_log\_config.html](http://httpd.apache.org/docs/current/en/mod/mod_log_config.html)


#Getting Help

- Getting Started : [Quick Start](/kb/en/logs/quick-start.html)
- Documentation : [Guides](/kb/en/logs)
- Mailing List : [paas.logs-subscribe@ml.ovh.net](mailto:paas.logs-subscribe@ml.ovh.net)
- Visit our community: [community.runabove.com](https://community.runabove.com)
- Create an account: [PaaS Logs Beta](https://cloud.runabove.com/signup/?launch=paas-logs)
