---
layout: post
title: "What is Object Storage?"
categories: Object-Storage
lang: en
author: BaQs
---

RunAbove have an Object Storage offer to manage huge quantity of data. Is it good for you?

# Definitions

First of all, the most important: an object storage __IS NOT a file system:__ it has no hierarchy!

Imagine yourself having an huge (unlimited) shelf, with a lot of drawers.
You can [PUT](http://docs.openstack.org/api/openstack-object-storage/1.0/content/PUT_createOrReplaceObject__v1__account___container___object__storage_object_services.html) anything in any drawer, [DELETE](http://docs.openstack.org/api/openstack-object-storage/1.0/content/DELETE_deleteObject__v1__account___container___object__storage_object_services.html) it afterwards, or [GET](http://docs.openstack.org/api/openstack-object-storage/1.0/content/GET_getObject__v1__account___container___object__storage_object_services.html) its content.

You can provide access publicly to your shelf via HTTP links.

Using RunAbove Object Storage, you have many shelves like that. We call them containers. Moreover, anything you store is replicated 3 times, you won't loose it.

# What is it good for ?

Basically, anything you want to store & share. An object storage is a distribution platform. Upload it once and it can be available directly via http. Millions of downloads can occur, we will handle it.

If you actually use a web application to serve file, you do not need it any more. That's what an object storage is for. You can make objects expire after some time, share them for a period, add metadata that web browsers understand.

You want to host a static website ? It's PERFECT!

Privately, you can store any file that need to be accessed by others applications/scripts or users, or as part of a process.

## For instance:
You store a big video, then download it on another server to re-encode it, then push it back to share it with a lot of people.

There are tons of examples like that, and there is no limit !

# Where/how to begin ?

RunAbove runs Openstack Swift, and makes it simple to use:

## Use OpenStack Horizon

Some screenshots to guide you through (from simple mode to Horizon)
![](https://community.runabove.com/public/files/irKoAPPu6y6JZfRoEZc5.png)
![](https://community.runabove.com/public/files/FJksBNU8geDPNs0kRHiy.png)
![](https://community.runabove.com/public/files/MUigXnPlL4xR4sH3SsCy.png)

## Use any language of your choice:

 * [Python](https://github.com/runabove/python-runabove)
 * [Go](https://github.com/ncw/swift)
 * Java with [JOSS](http://joss.javaswift.org)

Long story short, anything that is compatible with OpenStack Swift will work.
Checkout all [openstack available SDKs](https://wiki.openstack.org/wiki/SDKs) _C, Clojure, Erlang, Go, Java, Android, JavaScript, .Net, Node.js, Perl, PHP, Python, Ruby_

You can even use [Owncloud](/kb/en/object-storage/how-to-configure-owncloud-7-with-swift.html), [Duplicity](/kb/en/object-storage/how-to-store-your-backup-with-duplicity-and-openstack-swift.html)or even [CyberDuck](/kb/en/object-storage/how-to-use-cyberduck-with-openstack-swift.html).
Or if you're addicted to Command Line, you can also use [CURL](http://docs.openstack.org/api/openstack-object-storage/1.0/content/examples.html).

As a last link, OpenStack Swift documentation: http://docs.openstack.org/developer/swift/
