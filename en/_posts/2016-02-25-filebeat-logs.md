---
layout: redirected
title:  "Shipping logs to PaaS Logs with Filebeat"
categories: Logs
author: Pierre de Paepe
lang: en
sitemap: false
redirect_to: https://docs.ovh.com/gb/en/mobile-hosting/logs-data-platform/filebeat-logs/
---

Filebeat is an [open source](https://github.com/elastic/beats/tree/master/filebeat) file harvester, mostly used to fetch logs files and feed them into logstash. Together with Logstash, Filebeat is a really powerful tool that allows you to parse and send your logs to PaaS logs in a elegant and non intrusive way (except installing filebeat of course ;-). 

This guide will describe how to ask OVH to host your own dedicated Logstash on PaaS Logs and how to setup Filebeat on your system to forward your logs to it. It will also present you with some configuration setup you can use on Logstash to further structure your logs. Note that in order to complete this tutorial, you should have at least: 

  - [Activated the PaaS Logs lab and created an account.](/kb/en/logs/quick-start.html#account)
  - [created at least one Stream and get its token.](/kb/en/logs/quick-start.html#streams)

Once you have done theses two steps, you can dig into this one. Be prepared. 

