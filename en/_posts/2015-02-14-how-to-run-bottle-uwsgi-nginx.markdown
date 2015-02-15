---
layout: post
title: "Running your Python Bottle application on Nginx using uWSGI"
categories: development
tags: guide, getting-started, python
lang: en
author: thoorium
---

[Bottle](http://bottlepy.org/) is a fast, simple and lightweight WSGI micro web-framework for [Python](https://www.python.org/). Coupled with [uWSGI](https://uwsgi-docs.readthedocs.org/en/latest/) and [Nginx](http://nginx.org/) bottle will reach high performances to serve and distribute your content.

1. Installing Python, Bottle, uWSGI and Nginx
===============================

In this guide we will be using _Debian Wheezy_ as our host OS. Getting everything installed is easy thanks to the wondeful package manager.

Everything can be installed in a single ``apt-get`` which is available below:

```bash
sudo apt-get install python2.7 python-bottle uwsgi uwsgi-plugin-python nginx
```

This will install Python, Bottle, uWSGI, the plugin uWSGI need to run Python applications and Nginx. If you plan to run your application using a Python virtual environnement, do not install ``python-bottle``.

2. Hello Runabove
===============

For this exemple we will create a basic _Hello Runabove_ bottle application that goes like this:

```python
import bottle

from bottle import route, template

app = application = bottle.default_app()

@route('/')
def index():
    return template('<h1>{{message}}</h1>', message='Hello Runabove')
```

Name the file ``app.py`` and save it to the following destination

```bash
/usr/share/nginx/www/hello-runabove
```

This application will return a simple "Hello Runabove!" when visited from the web.

You can clone the full _Hello Runabove_ at the following address: [https://github.com/Thoorium/hello-runabove](https://github.com/Thoorium/hello-runabove)

3. Configure uWSGI
===========

In order to get _uWSGI_ to run your bottle application, you will first need to create a configuration file for your application. The configuration file is stored in ``apps-available`` and must be copied over to ``apps-enabled`` to work. Both directories are located under ``/etc/uwsgi/``.

Now let's create the _uWSGI_ configuration file. You can use the following commands to do so:

```bash
cd /etc/uwsgi/apps-available
sudo nano hello-runabove.ini
```

The basic structure of the configuration file looks like the following:

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

In order to get _uWSGI_ to start your application, you need to replicate your configuration file in the ``apps-enabled`` folder. We will be using a simple [symlink](http://en.wikipedia.org/wiki/Symbolic_link) to "copy" over the file. This will make maintenance of the configuration easier in the future as you will only need to edit the file in ``apps-available`` to make the changes in both places.

```bash
sudo ln -s /etc/uwsgi/apps-available/hello-runabove.ini /etc/uwsgi/apps-enabled/hello-runabove.ini
```

Finish by starting the _uWSGI_ service.

```bash
sudo service uwsgi start
```

You can read more about _uWSGI_ configuration at [https://uwsgi-docs.readthedocs.org/en/latest/Configuration.html](https://uwsgi-docs.readthedocs.org/en/latest/Configuration.html)

4. Configure Nginx
===========

Now that _uWSGI_ is running and created a socket for us to use, let's configure _Nginx_ to listen to this socket.

_Nginx_ needs a configuration file for you application in the ``conf.d`` directory. The ``conf.d`` directory is located under ``/etc/nginx/``. Now let's create our configuration file.

```bash
cd /etc/nginx/conf.d
sudo nano hello-runabove.conf
```

Our _Hello Runabove_ _Nginx_ configuration file will look like this:

```
upstream _hello-runabove {
    server unix:/run/uwsgi/app/hello-runabove/socket;
}

server {
    listen 80;
    server_name ServerAddressOrDomainHere;

    location / {
        try_files $uri @uwsgi;
    }

    location @uwsgi {
        include uwsgi_params;
        uwsgi_pass _hello-runabove;
    }
}
```

Now that we have created the configuration file, let's start _Nginx_

```bash
sudo service nginx start
```

5. Test it
===========

Congratulations! Your bottle application is now running live. Navigate to the address you have configured during step 4 and see it by yourself.

Troubleshooting
===========

If you are having trouble installing the packages via ``apt-get``, you might need to update your package list. Do so using the following command:

```bash
apt-get update
```
