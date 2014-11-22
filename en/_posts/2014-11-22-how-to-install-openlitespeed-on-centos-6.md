---
layout: post
title: "How to install OpenLiteSpeed on CentOS 6"
categories: Instances
author: Prasetyo
lang: en
---

[OpenLiteSpeed](http://open.litespeedtech.com/) is a high-performance, lightweight, open source HTTP server. It has some awesome feature such as built in page caching, Web GUI for realtime stats, apache mod_rewrite compatibility and many more. 

[Phalcon](http://phalconphp.com/en/) is a web framework implemented as a C extension offering high performance and lower resource consumption.

Installing OpenLiteSpeed
===

In this step, I assume you already launch centOS instance. Log in via ssh to your instance and upgrade centOS package

~~~bash
sudo yum update
~~~

Add OpenLiteSpeed repository and install it

~~~bash
sudo rpm -ivh http://rpms.litespeedtech.com/centos/litespeed-repo-1.1-1.el6.noarch.rpm
sudo yum install openlitespeed
~~~

It will install to latest stable release. Now run OpenLiteSpeed service by following this command

~~~bash
sudo /usr/local/lsws/bin/lswsctrl start
~~~

By default OpenLiteSpeed Web Admin listen on port `7080` and example website listen on `8088`. You have to open those port in RunAbove cloud panel.

Switch to Expert Mode

![](/kb/images/2014-11-22-how-to-install-openlitespeed-on-centos-6/scr-1)

Select `Access & Security` and edit your security rules. If you are new to this just update the `default` one.

Then click `Add Rule` and popup will show up

![](/kb/images/2014-11-22-how-to-install-openlitespeed-on-centos-6/scr-2)

Just fill field exactly same with picture above, it will allow all incoming connection to port `7080`. But if security is your concern You may limit source of incoming connection to certain CIDR. If you are done click add and repeat same process to allow port `8088`. Your rules should look like like this

![](/kb/images/2014-11-22-how-to-install-openlitespeed-on-centos-6/scr-3)

Now open OpenLiteSpeed WebAdmin on `https://YOUR_IP:7080`, you should see this page

![](/kb/images/2014-11-22-how-to-install-openlitespeed-on-centos-6/scr-4)

Use this credential to log in to your WebAdmin

~~~
username : admin
password : 123456
~~~

If you want to test example welcome page you can visit `http://YOUR_IP:8088`, and you should see this page

![](/kb/images/2014-11-22-how-to-install-openlitespeed-on-centos-6/scr-5)

Congratulation you have just installed OpenLiteSpeed successfully