---
layout: post
title: "Upload your first object inside Openstack Swift"
categories: Object-Storage
lang: en
author: VincentCasse
---

You have got a new Runabove account and you want to use object storage but you don't know how! Take five minutes to learn it!

# Some prerequisites:

Before all, you need to have a RunAbove account with valid credentials, a web browser, python and pip (python packager) installed on your computer... Yes, that's all!

# Installation:

To communicate with OpenStack APIs proposed by RunAbove, you need to install official OpenStack clients:

```
pip install python-swiftclient python-keystoneclient
```

Now you can begin to store your data!

# How to authenticate?

To be authenticated inside your Object Storage, you need to define some environment variables with your account credentials.

The simpliest way is to download a script to do it. You can find it in your control panel, in OpenStack Horizon.
Then go into _Access & Security_ panel, then into _API Access_ tab. Finally, click on _Download OpenStack RC File_.

![](http://community.runabove.com/public/files/JvEL9P7dJKRRpPDFEPRK.png)

Launch this script and enter your RunAbove password:

```
source 13370042-openrc.sh
```

To verify if you are authenticated, you can launch the next request and you will get some account metadata.

```
swift stat
```

# Upload your first object:

To upload _the_object.txt_ file into your Object Storage, you can use this command:

```
swift upload container_name path_to_the_object.txt
```

You can verify that your file is in container_name with:

```
swift list container
```

# Interact with your object:

You can download content of your object with:

```
swift download container_name path_to_the_object.txt
```

When you need to delete your object, you can use this request:

```
swift delete container_name path_to_the_object.txt
```

# How to continue to discover Object Storage?

To begin, you can continue to discover features of your Object Storage with documentation of the client:

```
swift help
```

Now you can think about direct integration of Object Storage in your applications and use officials SDKs or directly with HTTP requests to OpenStack APIs.
