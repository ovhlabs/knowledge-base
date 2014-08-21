---
layout: post
title: "How to optimize uploads with Openstack Swift"
categories: Object-Storage
lang: en
author: gierschv
---

OpenStack Swift allows you to store objects with a non-limited size by splitting them in [small segments](http://docs.openstack.org/developer/swift/overview_large_objects.html).

When a Swift client processes a request to upload an object (or a segment of an object), the Swift proxy determines the Swift storage node using a hash of the object name. Therefore, there is  a high probability that the segments will be stored in several storage nodes, which allow you to write your object(s) at an incredible speed.

Here is an example using a Run Above instance, uploading a big object (10Gio) using the [official command line client
(python-swiftclient)](https://github.com/openstack/python-swiftclient) on
Ubuntu or Debian:

1 - Install the client
----------------------

    apt-get install python-pip
    pip install python-keystoneclient python-swiftclient

2 - Get your credentials
------------------------

Set your credentials in your environment using the [Open RC
file](https://manager.runabove.com/horizon/project/access_and_security/api_access/openrc/)
that you can download using the horizon dashboard.

    source XXXXXXX-openrc.sh

3 - Example
-----------

Upload into the "backups" container a 10 Gio file in 100 Mio parts using 100
simultaneous connections:

    dd if=/dev/random of=10Gio.dat bs=$(( 2 ** 20 )) count=1024
    swift upload --segment-size $(( 2 ** 20 * 100 )) --segment-threads 100
    backups 10Gio.dat

4 - Measure
-----------

You can measure the upload using iftop, as shown below:
![Upload](https://pbs.twimg.com/media/BmO1wd6CAAAXSr4.png:large)
