---
layout: post
title: "Running your Python application on Sailabove"
categories: docker
tags: guide, getting-started, python
lang: en
author: yadutaf
---

[Python](https://www.python.org/) is a very popular and well established interpreted language. It emphases on code read readability and brings all the features one would expect from a modern language like dynamic typing, object programming, automatic memory management, ...

Python comes with a [huge library of packages](https://pypi.python.org/pypi) installable using ``pip install``.

Very popular full featured web frameworks like [Django](https://www.djangoproject.com/) and [Pyramid](http://www.pylonsproject.org/) as well as [Bottle](http://bottlepy.org/docs/dev/index.html) and [Flask](http://flask.pocoo.org/) micro-frameworks all have in common to be powered by Python.

Before diving in, make sure to read the [Getting Started](getting-started-with-sailabove-docker.html) guide.

1. Write an awesome application
===============================

Let's do something unique. Like, say, an "Hello Docker" application. In a hurry? You can already see the result on Sailabove: http://hello-python.demo.app.sailabove.io/hello/Docker-Fan

For this example, we'll use the excellent [Bottle](http://bottlepy.org/docs/dev/index.html) micro-framework.

Here is the full ``server.py`` source code:

```python
{% raw %}
# -*- coding: utf-8 -*-
from bottle import route, run, template

@route('/hello/<name>')
def index(name='World'):
    return template('Hello <b>{{name}}</b>!', name=name)

run(host='0.0.0.0', port=80)
{% endraw %}
```

We now need to declare our dependencies using a ``requirements.txt`` file. In this case, only ``bottle``:

```
bottle==0.12.7
```

2. Dockerize it
===============

Python is a Docker first class citizen. It has its [own dedicated official image](https://registry.hub.docker.com/u/library/python/) supporting Python 2.7, 3.3 and 3.4. For this example, we'll stick with Python 2.

Here is our ``Dockerfile``:

```
FROM python:2-onbuild
EXPOSE 80
CMD [ "python", "./server.py" ]
```

It first instructs Docker to get Python ``2`` base image with automatic build support (``-onbuild``). To use Python 3.3 base image instead, you may choose to use ``FROM python:3.3-onbuild`` for instance.

We then declare the ``PORT`` our application will listen on. In our case, standard HTTP port.

Lastly, it instructs Docker the ``CMD`` to launch our application.

OK, let's build and test it locally:


```bash
docker build -t hello-python .
docker run -it --publish 8080:80 --rm -t hello-python
```

Check if all works fine, visit http://localhost:8080/hello/Docker-Fan. You should see something like "Hello Docker-Fan!".

It works on your dev machine. It will work on production.

3. Go live!
===========

Let's go: ``tag`` our application so that Docker knows where to prod it:

```bash
# docker tag <local app name>  sailabove.io/<user name>/<app name>
docker tag hello-python sailabove.io/demo/hello-python
```

Push your application on Sailabove's *private* Docker registry:

```bash
# docker push <previously created tag>
docker push sailabove.io/demo/hello-python
```

Launch it using previously installed ``sail`` command line and instruct Sailabove to run it with unprivileged user ``nobody`` for increased security. Please note that, even when running as regular unprivileged user, your application can freely listen on *any* port, ``80`` in this case.

```bash
# sail services add <user name>/<app name> <service name>
sail services add demo/hello-python hello-python
```

Eager to see the result? Wait a few seconds. It is now running live on http://hello-python.demo.app.sailabove.io/hello/Docker-Fan. This is ``http://<service name>.<user name>.app.sailabove.io``.

Enjoy!

Getting help
============

- Get started: [Getting started quide][8]
- Documentation: [Reference documentation][9], [Guides][10]
- Join OVH Docker mailing list: [docker-subscribe@ml.ovh.net][5]
- Visit our Community: [https://community.runabove.com/][6]
- Drop us an e-mail: [sailabove@ovh.net][1]
- Create your account: [Sailabove.com][7]

  [1]: mailto:sailabove@ovh.net
  [5]: mailto:docker-subscribe@ml.ovh.net
  [6]: https://community.runabove.com/
  [7]: https://sailabove.com/
  [8]: /kb/en/docker/getting-started-with-sailabove-docker.html
  [9]: /kb/en/docker/documentation
  [10]: /kb/en/docker/
