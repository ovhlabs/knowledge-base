---
layout: post
title:  "Sending Apache Access Logs in PaaS Logs"
categories: Logs
author: Babacar Diassé
lang: en
---

<div class="notice--warning" style="border: 1px #CE6D00 solid;padding: 10px;">
  <h4 style="margin-top:0;">DISCLAIMER</h4>
  <p>The following procedure have the advantage to be setup very quickly but is NOT recommended at all in production as it can block the Apache process in case of heavy traffic.</p>
  <p>
        In production, please use a non blocking solution as this one: <a href="https://community.runabove.com/kb/en/logs/filebeat-logs.html">Shipping logs to PaaS Logs with Filebeat</a>
  </p>
</div>

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
  - [Activate the PaaS Logs lab and create an account.](/kb/en/logs/quick-start.html#account)
  - [To create at least one Stream and get its token.](/kb/en/logs/quick-start.html#streams)
  - Have enough will to copy and paste 3 lines and change 32 characters (your token ;-).

# 2.1 Global Apache configuration
We will configure one virtual Host to send all of its logs to your stream, you will have to repeat this configuration to every stream in order to make it work. 

We use CustomLog format directive to transform Apache logs in LTSV format and ship it to LaaS with the proper OVH token. Note that 3 fields are mandatory with the LTSV format : `host`, `message` and `time` (in the RFC 3339 format). Refer to the examples below to learn how to fill these fields.
Please create the file /etc/httpd/conf.d/laas.conf or /etc/apache2/conf.d/laas.conf (it depends of your distribution) and insert the following :

```apache
 LogFormat "X-OVH-TOKEN:0d50bffc-xxxx-xxxx-xxxx-a3413f96762b\tdomain:%V\thost:%h\tserver:%A\tident:%l\tuser:%u\ttime:%{{"{%"}}d/%b/%Y:%H:%M:%S%z}t\tmethod:%m\tpath:%U%q\tprotocol:%H\tstatus_int:%>s\tsize_int:%b\treferer:%{Referer}i\tagent:%{User-Agent}i\tresponse_time_int:%D\tcookie:%{cookie}i\tset_cookie:%{Set-Cookie}o\tmessage:%h %l %u %t \"%r\" %>s %b\n" combined_ltsv 
 CustomLog "|/usr/bin/openssl s_client -connect laas.runabove.com:12201" combined_ltsv
  ErrorLog syslog:local1
```

Ensure that the full path of openssl is correct for your system or it won't work.
Ensure also that your X-OVH-TOKEN is properly written.
This tutorial covers only how to send your access logs to PaaS Logs. to send your Error logs, [you should configure your syslog template to send logs to PaaS Logs](/kb/en/logs/how-to-log-your-linux.html).

## 2.2 VirtualHost configuration
If you want to only send logs from a specific VirtualHost, or send specific information about one VirtualHost, use this configuration to send logs to PaaS Logs:

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

This is what you got on Graylog when you send your logs. The logs are already nicely parsed and you can immediately launch specifics searches on them: 

![apache Logs](/kb/images/2016-02-25-apache-logs/apache-logs.png)

#3 Apache logs format

If you want to use your own log format and include some useful information here is a cheat sheet for you:

![Cheat Sheet](/kb/images/2016-02-25-apache-logs/cheatsheet.png)


The full list of logs formats that can be used in Apache are described here [http://httpd.apache.org/docs/current/en/mod/mod\_log\_config.html](http://httpd.apache.org/docs/current/en/mod/mod_log_config.html)


#Getting Help

- Getting Started : [Quick Start](/kb/en/logs/quick-start.html)
- Documentation : [Guides](/kb/en/logs)
- Mailing List : [paas.logs-subscribe@ml.ovh.net](mailto:paas.logs-subscribe@ml.ovh.net)
- Visit our community: [community.runabove.com](https://community.runabove.com)
- Create an account: [PaaS Logs Beta](https://cloud.runabove.com/signup/?launch=paas-logs)
