---
layout: redirected
title:  "Sending Apache Access Logs in PaaS Logs"
categories: Logs
author: Babacar Diassé
lang: en
sitemap: false
redirect_to: https://docs.ovh.com/gb/en/mobile-hosting/logs-data-platform/apache-logs/
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
