---
layout: post
title: "Mod_SPDY with Ubuntu 14.04 x64 and Apache 2.4.7"
categories: Instances
author: neoark
---
Introduction
============

SPDY (pronounced “SPeeDY”) is a new networking protocol introduced by Google and designed to reduce the web latency associated with HTTP. mod_spdy is an Apache 2.2-compatible module that provides SPDY support for Apache HTTP servers. Multiplexing is an important performance feature of SPDY which allows for multiple requests in a single SPDY session to be processed concurrently, and their responses interleaved down the wire. However, due to the serialized nature of the HTTP/1.1 protocol, the Apache HTTP server provides a one-request-per-connection architecture. SPDY holds great potential for mobile devices, for which latency is more of an issue and the market is catching on.

Advantages
----------

 - Compared to HTTPS, SPDY requests consume less resources (CPU and memory) on the server.
 - Compared to HTTP, SPDY requests consume less memory but a bit more CPU. This may be good, bad, or irrelevant depending on which resource (if either) is currently limiting your server.
 - Compared to HTTP/S, SPDY requires fewer Apache worker threads, which increases server capacity. As a result, the server may attract more SPDY traffic.

Browser Supporting SPDY
===============

![SPDY Networking Protocol Support](/kb/images/2014-10-14-mod_spdy-with-ubuntu-14.04-x64-and-apache 2.4.7/image1.png)

Compile and Install mod_spdy
============================

    $ cd /tmp
    $ sudo apt-get -y install git g++ libapr1-dev libaprutil1-dev curl patch binutils make devscripts
    $ git clone -b apache-2.4.7 https://github.com/eousphoros/mod-spdy.git
    $ cd mod-spdy/src
    $ ./build_modssl_with_npn.sh
    $ chmod +x ./build/gyp_chromium
    $ make BUILDTYPE=Release
    $ service apache2 stop
    $ cd /usr/lib/apache2/modules
    $ mv mod_ssl.so mod_ssl.so.bak
    $ cd /tmp/mod-spdy/src
    $ sudo cp mod_ssl.so /usr/lib/apache2/modules
    $ service apache2 start
    $ sudo a2enmod ssl
    $ service apache2 restart
    $ sudo cp out/Release/libmod_spdy.so /usr/lib/apache2/modules/mod_spdy.so
    $ echo "LoadModule spdy_module /usr/lib/apache2/modules/mod_spdy.so" | sudo tee /etc/apache2/mods-available/spdy.load
    $ echo "SpdyEnabled on" | sudo tee /etc/apache2/mods-available/spdy.conf
    $ sudo a2enmod spdy
    $ service apache2 restart

Testing mod_spdy
================

Visit **[http://spdycheck.org/](http://spdycheck.org/)** and enter the hostname for the website you want to check.

Using mod_spdy with PHP
=======================

 1. Enable the **Multiverse** repository in **/etc/apt/sources.list** for libapache2-mod-fastcgi. Then follow:

    $ apt-get install apache2-mpm-worker libapache2-mod-fastcgi php5-fpm php-apc
    $ a2dismod php5 mpm-prefork
    $ a2enmod actions alias fastcgi rewrite mpm-worker

Modify **apache2.conf** file:

    nano /etc/apache2/apache2.conf

Add the following lines to the very bottom of the file.

    <IfModule mod_fastcgi.c>
    FastCgiExternalServer /var/www/php5.external -socket /var/run/php5-fpm.sock
    AddHandler php5-fcgi .php
    Action php5-fcgi /usr/lib/cgi-bin/php5.external
    Alias /usr/lib/cgi-bin/ /var/www/
    </IfModule>

   Restart **Apache** and **PHP-FPM** services:

    service php5-fpm restart
    service apache2 restart

Testing you Install
===================

 1. Create the PHP file:

	    $ echo "<?php phpinfo(); ?>" | sudo tee /var/www/test.php > /dev/null && sudo chgrp www-data /var/www/test.php

 2. Test it in your browser! Visit **http://localhost/test.php** and check the output for ***Server API	FPM/FastCGI***
Additional Notes
==========

 - For apache 2.2 follow this [**guide**](https://developers.google.com/speed/spdy/mod_spdy/).
 - For additional apache performance tuning install  **[Google PageSpeed Module](https://developers.google.com/speed/pagespeed/module/download)**.
