---
layout: post
title: "How To Install Cozy App on Runabove"
categories: instances
tags: guide, getting-started, nodejs
lang: en
author: ageng
---

[Cozy](http://cozy.io/en/) Cozy a Personal Cloud you can host, customize and fully control. Sync your contacts, calendars and files between your devices and your personal server. Add your own services to leverage your personal data. Cozy coded with JavaScript . You can build your web app with a single language for client and server: JavaScript. You can distribute your app easily to the entire community by sharing the Git URL of your repository. No need to worry about deployment anymore. Some main feature from cozy like Files, Calendar, Contacts and many other.

1. Installation
-----

You need installed [fabric](http://www.fabfile.org/) and [fabtools](https://pypi.python.org/pypi/fabtools/0.19.0) on your server and Install with [pip](https://pypi.python.org/pypi/pip).

```bash
$ sudo apt-get install python python-pip python-dev software-properties-common 
$ sudo pip install fabric fabtools
```

Download Fabric file from Cozy [github repo](https://github.com/cozy/cozy-setup) :

```bash
$ wget https://raw.githubusercontent.com/cozy/cozy-setup/master/fabfile.py
```

Use the Fabric script from your local machine to launch the Cozy installation :

```bash
$ fab -H user@ip install
```

"User" is a sudo user and "ip" your server IP. Enter your settings (such as domain name) when prompted by the installer.

Be patient; some commands or app deployments can take some time. It depends on your network and hardware. Once the installation is done, you can access with ```https://IP``` to create your Cozy main account.

Congratulations! You have installed Cozy on your server.