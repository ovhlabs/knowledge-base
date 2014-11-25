---
layout: post
title: "Getting started with Sailabove Docker Hosting"
categories: docker
tags: guide, overview
lang: en
author: yadutaf
---

Sailabove elegantly hosts and runs Docker(tm) based applications in a RunAbove(tm) cloud. If you've never heard of Docker (yet), it's the buzzing solution that not only promises but actually makes it possible to say:

    "If it works on dev, it works on production"

Overview
========

Docker
------

[Docker](https://www.docker.com/) is a buzzing *container* solution. Just like shipping containers are standard "boxes" to send anything anywhere, Dockers are standard application containers based on Linux to build and run code anywhere.

It can be seen as a VM running a single service while being much faster and lighter than an actual Virtual Machine.

Additionally, Docker introduces the notion of *links*. Docker links mechanism is used to logically attach related containers together. For example, to link a blog like wordpress to its database.

Want to learn more about Docker ? [Visit Docker's official presentation page.](https://docker.com/whatisdocker/)

Sailabove
---------

Sailabove can host and scale any Docker application. It is:

- **Flexible as a dedicated server**: You can use any lib or software you want, as long as it runs on 64bit Linux. Be it written in Java (OpenTsdb), Python (Django), Ruby (Gitlab), Go (InfluxDB), C (HaProxy, Redis, MariaDB), ... That's pretty much any server side software!
- **Powerful as a cluster**: Easily scale any individual application component and feel as if it was all on a single server.
- **Simple as shared hosting**: We do the hard work of keeping the servers up, monitoring and scaling your application, ...


Anatomy of a Docker@Sailabove application
-----------------------------------------

Docker applications are built using 2 core concepts:
- containers: smallest application component.
- links: logical connexion between containers.

Additionally, Sailabove introduces 1 more concept:
- services: scalable group of 1 to N identical containers.

Individual containers can be scaled to N identical instances forming a service. Services (hence containers) can be linked together to form a full N-Tier application. For instance, a Wordpress container would be linked to a MariaDB database and maybe a HaProxy caching front end.

Getting Started
===============

1. Claim your account
---------------------

Visit https://labs.runabove.com/sail/ and sign-up using your *Free* [Runabove Account](https://www.runabove.com/index.xml).

Once authenticated, choose your docker's username and password. You'll need them to push and run your docker images. You'll then be directed to the welcome page. You should also receive a confirmation email.

When coming back, use the same method to authenticate, you'll be automatically directed to the welcome page.

2. Setup your Docker
--------------------

If needed, install the official Docker client. An exhaustive documentation for a variety of Operating Systems including Ubuntu, Windows and MacOS X is available on Docker official website: https://docs.docker.com/installation/#installation

Fire up a terminal, (Application > Utilities > Terminal on Mac OS X; Usually <Ctrl>+<Alt>+T on Linux). Windows is not officially supported (yet).

Then login, using the credentials you just created (email address is not required):
```bash
docker login sailabove.io
```

You only need to this once, Docker will remember your credentials.

3. Get sailabove's official client
----------------------------------

``sail`` client is a lightweight Python application hosted on ``PyPi``. depending on your Operating System, you may need to install ``pip`` first to get it using a command like:

- Mac OS X: available by default
- Debian/Ubuntu: ``sudo apt-get install python-pip``
- Fedora/RedHat/CentOS: ``sudo yum install python-pip``

You can then install ``sail`` with

```bash
sudo pip install sail
```

Note: Advanced users may want to run this command as user in a ``virtualenv``

4. Enjoy!
---------

You may now want to

- [Push your Python application](hello-python.html)
- [Push your Node.js application](hello-node.html)
- [Push your Ruby application](hello-ruby.html)
- [Push your Go application](hello-go.html)
