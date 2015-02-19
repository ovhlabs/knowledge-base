---
layout: post
title: "Running your Python Bottle application on Nginx using uWSGI"
categories: development
tags: guide, getting-started, python
lang: en
author: thoorium
---

[Bottle](http://bottlepy.org/) is a fast, simple and lightweight WSGI micro web-framework for [Python](https://www.python.org/). Coupled with [uWSGI](https://uwsgi-docs.readthedocs.org/en/latest/) and [Nginx](http://nginx.org/) bottle will reach high performances to serve and distribute your content.

This setup will make use of _uWSGI_ as the application server because the built-in Bottle web server is __very slow__ and should only be used for __development__. _uWSGI_ is capable of spawning new process of you application and will scale your application when needed.

1. Installing Python, Bottle, uWSGI and Nginx
-------

In this guide we will be using _Debian Wheezy_ as our host OS. Getting everything installed is easy thanks to the wonderful package manager.

Everything can be installed in a single ``apt-get`` which is available below:

```bash
sudo apt-get install python2.7 python-pip uwsgi uwsgi-plugin-python nginx
```

This will install Python, pip (Python package manager), uWSGI, the uWSGI Python plugin and Nginx. _uWSGI_ does not know how to handle Python applications by default and requires the Python plugin in order to function for our needs.

2. Hello Runabove
-------

For this example we will create a basic _Hello Runabove_ bottle application that goes like this:

```python
import bottle

from bottle import route, template

@route('/')# Handle HTTP GET for the application root
def index():
    return template('<h1>{{message}}</h1>', message='Hello Runabove')

# Run bottle internal test server when invoked directly ie: non-uxsgi mode
if __name__ == '__main__':
    bottle.run(host='0.0.0.0', port=8080)
# Run bottle in application mode. Required in order to get the application working with uWSGI!
else:
    app = application = bottle.default_app()
```

Name the file ``app.py`` and save it to the following destination

```bash
/usr/share/nginx/www/hello-runabove
```

This application will return a simple "Hello Runabove!" when visited from the web.

You can clone the full _Hello Runabove_ at the following address: [https://github.com/Thoorium/hello-runabove](https://github.com/Thoorium/hello-runabove)

3. Setting up Bottle and the virtual environment
-------

A good practice with Python is to contain all project's dependencies in a "virtualenv". A virtualenv is lightweight space where a project can have its own dependencies without interfering with system wide python packages. As a second benefit, you won't need to be root anymore to install from __pip__.

Thanks to the python package manager, _pip_, installing Bottle in a virtual environment is a very simple task that requires very few commands.

Let's start by installing the [virtualenv](https://virtualenv.pypa.io/) package:

```bash
sudo pip install virtualenv
```

Now with the virtual environment package installed, we can create a virtual environment for our application:

```bash
cd /usr/share/nginx/www/hello-runabove
sudo virtualenv venv-bottle
sudo venv-bottle/bin/pip install bottle
```

This will create a directory will all the dependencies your python application need to run. By doing so you will prevent any sort of conflicts between python applications if different versions of the same package are used!

4. Configure uWSGI
-------

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
virtualenv = venv-bottle
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

5. Configure Nginx
-------

Now that _uWSGI_ is running and created a socket for us to use, let's configure _Nginx_ to listen to this socket.

_Nginx_ needs a configuration file for you application in the ``sites-available`` directory and a copy of it in the ``sites-enabled`` directory. Both directories are located under ``/etc/nginx/``. Now let's create our configuration file.

```bash
cd /etc/nginx/sites-available
sudo nano hello-runabove
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

Finally, we copy the config to ``sites-enabled`` using a symlink:

```bash
sudo ln -s /etc/nginx/sites-available/hello-runabove /etc/nginx/sites-enabled/hello-runabove
```

Now that we have created the configuration file, let's start _Nginx_

```bash
sudo service nginx start
```

6. Test it
-------

Congratulations! Your bottle application is now running live. Navigate to the address you have configured during step 4 and see it by yourself.

Troubleshooting
-------

If you are having trouble installing the packages via ``apt-get``, you might need to update your package list. Do so using the following command:

```bash
sudo apt-get update
```
