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

Browser Support
===============

![SPDY Networking Protocol Support](Test)

Installation
============

Step 1: Compile and Install mod_spdy
------------------------
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

Testing mod_spdy:
-----------------
Visit **[http://spdycheck.org/](http://spdycheck.org/)** and enter the hostname for the website you want to check.

