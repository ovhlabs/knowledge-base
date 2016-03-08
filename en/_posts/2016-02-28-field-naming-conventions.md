---
layout: post
title:  "Field Naming convention"
categories: Logs
author: Babacar Diassé
lang: en
---

Now that you can send logs, you are maybe wondering how to tell PaaS Logs what kind of data you send. It can be dates, or numbers or booleans or just plain strings. At OVH, we love to create fancy Dashboards with all these kind of stuff. If you want to be sure that your logs will be properly parsed, this document is made for you ! 


#1 What is a valid log for PaaS Logs ? 

A well formated log for PaaS Logs is a [GELF](http://docs.graylog.org/en/latest/pages/gelf.html) formatted log. What is GELF ? A standardized JSON way to send logs. 
GELF stands for Graylog Extended Log Format. Using this format gives us two advantages, It is directly compatible with Graylog and it is still extensible enough to enrich your logs as you would like to.   
This format impose a few conventions that if you don't follow can have many consequences : 
 - PaaS Logs will rewrite your field as an incorrect one (with a _fixit suffix). 
 - Your log will be rejected and lost in space (not kidding here).
 - We will send Liam Neeson to your house (not kidding either).

First please check the table below to know which field are reserved and what is their meaning. Note that some of these fields are mandatory and have to be setted by whatever library you use to send logs to PaaS Logs.
Refer to the documentation of the library or to some of our awesome tutorials to know how to send them.   


![Reserved keywords](/kb/images/2016-02-28-field-naming-conventions/reserved_keywords.png)


# 2. Can I go deeper ?

Of course as we said before you can send some additionnal fields as long as you prepend them with the '_' (underscore) character. You can use any JSON valid character for your field, except the '.' (dot) character. But don't worry, if you do so, we will rewrite your '.' in a very cute underscore. So how can you send special type as number, dates and booleans ? Here is the answer :
 

![supported suffixes](/kb/images/2016-02-28-field-naming-conventions/suffixes.png)

As you can see it is fairly straightforward. Suffix your field with the right value and you will be able to send anything you want. For reference here is a full example of a valid gelf message with every type we have : 

    {"version": "1.1","host":"my_host", "_some_num": 87.6, "_some_user_id_float":123, "a_good_date" : "2016-01-01T17:04:25.000", "short_message":"A short message that can save your life","full_message":"all the things you want up to 32768 characters","_line":, "level":1,"_power_level_int":"9001","_some_info":"info","_ovh_is_wonderful_bool" : "true"}


Specifying correct numeric suffixes types is the only way to generate numeric Widgets for Dashboards. Here is an exemple of graph you can generate with a numeric value:


![Numeric widget](/kb/images/2016-02-28-field-naming-conventions/bytes.png)


Note that if you use the LTSV format to send logs to our inputs, these suffixes will tell our engine in what format you intended to send your  datas and thus make the right conversion.   
So this is everything you need to know to send valid messages format  and not shoot yourself in the foot. 
If you have any question you can always reach us by using the mailing list. 

Happy Logging

