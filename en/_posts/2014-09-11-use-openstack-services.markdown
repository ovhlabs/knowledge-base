---
layout: post
title: "How to use openrc and OpenStack command line tools?"
categories: Instances
author: bartekzurawski
---

OpenStack is cloud computing software, built of several operating with each service. In this guide 
we will focus how use command line clients. 

Basics
------

To use any command line client, you need to load openrc file. This file contains special 
environments which is used by command line clients to communicate with server where service is 
running.  

Let's start! To begin, log you inside your expert mode control panel and go to __Access & Security__ and switch tab to __API Access__.  Click on 
__Download OpenStack RC File__ button which is in right top corner.

File that you download, is BASH script. To load it, you can use source command:

```
source <file>
```

```
Important
After source command you need to enter your password to RunAbove account
```

After you load this file, you can check that environment is correctly loaded, perform:

    env | grep OS_

As you can see your environments have been loaded correctly.

    Important!
    If you logout from your virtual machine, you need to load openrc file again

Command line clients
--------------------

To use command line clients, you need to first install it. To install it you need python-pip which 
is useful tool for install python packages. Install it:

    sudo apt-get install python-pip

To install command line client, you need to know it name, because name of python package for that is 
python-_projectname_client, for example:

    sudo pip install python-novaclient

In RunAbove there is two region, thath you can use it's BHS-1 and SBG-1. If you want get data from one of it, you need to add parameter --os-region 
_region name_ , to each client, for example:

    nova --os-region BHS-1 list
    glance --os-region SBG-1 image-list

It's possible to define region in environment variable, just do:

    export OS_REGION=<region name>

    export OS_REGION=BHS-1

Under [this link](https://wiki.openstack.org/wiki/OpenStackClients) you can find list of OpenStack 
clients, that you can install. 

Under [this link](http://docs.openstack.org/cli-reference/content/) there is a list of all command available for all command line clients
