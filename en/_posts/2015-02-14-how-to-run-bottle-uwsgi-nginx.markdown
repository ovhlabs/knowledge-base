---
layout: post
title: "Running your Python Bottle application on Nginx using uWSGI"
categories: development
tags: guide, getting-started, python
lang: en
author: thoorium
---

[Bottle](http://bottlepy.org/) is a fast, simple and lightweight WSGI micro web-framework for [Python](https://www.python.org/). Coupled with [uWSGI](https://uwsgi-docs.readthedocs.org/en/latest/) and [NGINX](http://nginx.org/) bottle will reach high performances to serve and distribute your content.

1. Installing Python, Bottle, uWSGI and Nginx
===============================

In this guide we will be using _Debian Wheezy_ as our OS. Getting everything installed is easy thanks to the wondeful package manager.

Everything can be installed in a single ``apt-get`` which is available below:

```bash
sudo apt-get install python2.7 python-pip uwsgi uwsgi-plugin-python nginx
```


2. Hello Runabove
===============

For this exemple we will create a basic _Hello Runabove_ bottle application that goes like this:

```python
FROM python:2-onbuild
EXPOSE 80
CMD [ "python", "./server.py" ]
```

You can clone the full _Hello Runabove_ at the following address: [https://github.com/Thoorium/hello-runabove](https://github.com/Thoorium/hello-runabove)

3. Configure uWSGI
===========

In order to get _uWSGI_ to run your bottle application, you will first need to create a configuration file for you application. The configuration file is stored in _apps-available_ and must be copied over to _apps-enabled_ to work.

First navigate to the _uWSGI_ folder then create your application configuration file. You can use the following commands to do so:

```bash
cd /etc/uwsgi/apps-available
sudo nano hello-runabove.ini
```

The basic structure of the configuration file goes as the following:

```
[uwsgi]
socket = /run/uwsgi/app/hello-runabove/socket
chdir = /usr/share/nginx/www/hello-runabove
master = true
plugins = python
file = app.py
uid = www-data
gid = www-data
vacuum = true
```

In order to get _uWSGI_ to start your application, you need to replicate your configuration file in the _apps-enabled_ folder. We will be using a simple [symlink](http://en.wikipedia.org/wiki/Symbolic_link) to "copy" over the file. This will make maintenance of the configuration easier in the future.

```bash
sudo ln -s /etc/uwsgi/apps-available/hello-runabove.ini /etc/uwsgi/apps-enabled/hello-runabove.ini
```

Finish by starting the _uWSGI_ service.

```bash
sudo service uwsgi start
```

4. Configure Nginx
===========

Now that _uWSGI_ is running and created a socket for us to use, let's configure _Nginx_ to listen to this socket.