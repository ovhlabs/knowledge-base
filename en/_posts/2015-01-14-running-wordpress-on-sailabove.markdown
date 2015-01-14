---
layout: post
title: "Running Wordpress on SailAbove"
categories: docker
tags: guide, getting-started, wordpress
lang: en
author: gierschv
---

[Wordpress](http://wordpress.org) is a free and open source blogging tool and a
content management system (CMS) based on PHP and MySQL. WordPress is used by
more than 22.0% of the top 10 million websites as of August 2013 and is the most
popular blogging system in use on the Web, at more than 60 million websites.

*Requirements for this guide*: the
[SailAbove command line](https://pypi.python.org/pypi/sail/). See the
[SailAbove getting started](/kb/en/docker/getting-started-with-sailabove-docker.html)
for more information.

# 1. Application architecture

The application that we'll deploy here will be structured as two services: the
*Wordpress* application and a *MySQL* database, we'll use the two existing
official images [Wordpress](https://registry.hub.docker.com/_/wordpress/) and
[MySQL](https://registry.hub.docker.com/_/mysql/) provided and maintained by
Docker Inc.

Since both of these images uses the Docker's
[VOLUME](https://docs.docker.com/reference/builder/#volume) metadata, SailAbove
will automatically provide us a persistent block storage and will configure it
for our two containers.

To safely deploy our application, both services will be exposed on a dedicated
private network provided by RunAbove (in blue on the schema below), and only the
Wordpress web application will be available on a public IP. The Wordpress
application will communicate with its database using a class
[Docker link](https://docs.docker.com/userguide/dockerlinks/) within its private
network.

![Application architecture](/kb/images/2015-01-14-running-wordpress-on-sailabove/containers.png)

# 2. Bookmark the two Docker Images

To easily use the two official images from the Docker Hub on RunAbove, we'll
[bookmark them](/kb/en/docker/boot-a-sailabove-container-from-a-docker-image-hosted-on-the-docker-hub.html)
in our SailAbove account (you must replace ```<application>``` with your
application name, e.g. if your application is named "example", you should have
example/mysql in the examples below):

```bash
$ sail repositories add external <application>/mysql -s https://registry.hub.docker.com/_/mysql/
$ sail repositories add external <application>/wordpress -s https://registry.hub.docker.com/_/wordpress/
```

# 3. Deploy the MySQL service

We'll now add a new SailAbove service named "**wordpress-mysql**" that'll boot
the official MySQL Docker image we just bookmarked.

We explicitely specify that this service will only be exposed on the private
network of the application, and add a random root password in its environment,
as [specified in the image documentation](https://registry.hub.docker.com/_/mysql/).

```bash
$ sail services add --network private -e MYSQL_ROOT_PASSWORD=mysecretpassword <application>/mysql wordpress-mysql
Fetching tag mysql:latest
Fetching meta of layer 310c359af360
Service wordpress-mysql changed state to init
[...]
```

# 4. Deploy the Wordpress service

We can now add the Wordpress application linked to our database with the name
"mysql", as [required by the Docker image](https://registry.hub.docker.com/_/wordpress/).

This service will launch on our application private network and SailAbove
reverse proxy network called "predictor" where its HTTP port (80) will be
published.

```bash
$ sail services add -p 80:80 --link wordpress-mysql:mysql --network predictor --network private <application>/wordpress wordpress
Fetching tag wordpress:latest
Fetching meta of layer dd95974be471
Service wordpress changed state to init
[...]
```

# 5. [Optional] Add a domain name

Optionaly, we can easily attach a domain name to our Wordpress. First we need to
register it on the reverse proxy (here is an example if we wanted to register
"www.example.com"):

```bash
$ sail services domain-attach <application>/wordpress www.example.com
```

Now, we just need to add a CNAME in our DNS zone pointing to our wordpress
service:

```bash
www.example.com CNAME wordpress.<application>.app.sailabove.io.
```

# 6. The end

That's all. Your Wordpress is ready, you can now configure its option by
browsing your own domain url or
```http://wordpress.<application>.app.sailabove.io```.



