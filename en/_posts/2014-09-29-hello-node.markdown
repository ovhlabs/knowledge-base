---
layout: post
title: "Running your Node.js application on Sailabove"
categories: docker
tags: guide, getting-started, nodejs
lang: en
author: yadutaf
---

[Node.js](http://nodejs.org/) is modern event-based asynchronous language built on the foundations of the lighting fast ``V8`` javascript engine powering Google Chrome. Its event based approach contributed a lot to its popularity. It helps a lot to built fast, scalable and efficient IO bound applications.

Node.js comes with a [large library of packages](https://www.npmjs.org/) installable using ``npm install``.

Big name companies like Linkedin, Paypal and even Microsoft are all using it internally for latency sensitive applications. DotCloud (now Docker Inc.) used it to power [Hipache](http://blog.dotcloud.com/announcing-hipache-dotclouds-open-source-websocket-supporting-http-proxy), the first large scale load balancer supporting WebSockets.

Before diving in, make sure to read the [Getting Started](getting-started-with-sailabove-docker.html) guide.

1. Write an awesome application
===============================

Let's do something unique. Like, say, an "Hello Docker" application. In a hurry? You can already see the result on Sailabove: http://hello-node.demo.app.sailabove.io/hello/Docker-Fan

For this example, we'll use the excellent [Express](http://expressjs.com/) micro-framework.

Here is the full ``server.js`` source code:

```javascript
var express = require('express');
var app = express();

app.use(express.logger());

app.get('/hello/:name', function(req, res){
    req.params.name = req.params.name.replace(/[\u00A0-\u9999<>\&]/gim, function (i) {
       return '&#' + i.charCodeAt(0) + ';';
    });

    res.send('Hello <b>' + req.params.name + '</b>!');
});

console.log('Express server started on port %s', 80);
app.listen(80);
```

We now need to declare our dependencies using a ``package.json`` file. In this case, only ``express``:

```javascript
{
    "name": "hello-docker",
    "private": true,
    "dependencies": {
        "express": "3.x"
    }
}
```

If the main server file is not ``server.js`` or starting your Node.js application requires some specific steps, you may use ``package.json`` [scripts](https://www.npmjs.org/doc/misc/npm-scripts.html) like:

```javascript
{
    // ...
    "scripts": {
        "start": "nodejs server.js"
    },
    // ...
}
```

2. Dockerize it
===============

Node.js is a Docker first class citizen. It has its [own dedicated official image](https://registry.hub.docker.com/u/library/node/) supporting Node 0.8, 0.10 and 0.11. For this example, we'll use latest stable which 0.10 at the time of writing.

Here is our ``Dockerfile``:

```
FROM node:0.10-onbuild
EXPOSE 80
```

It first instructs Docker to get Node.js ``0.10`` base image with automatic build support (``-onbuild``). To use another Node.js runtime version like the bleeding edge one, you may choose to use ``FROM node:0.11-onbuild`` for instance.

We then declare the ``PORT`` our application will listen on. In our case, standard HTTP port.

OK, let's build and test it locally:


```bash
docker build -t hello-node .
docker run -it --publish 8080:80 --rm -t hello-node
```

Check if all works fine, visit http://localhost:8080/hello/Docker-Fan. You should see something like "Hello Docker-Fan!".

It works on your dev machine. It will work on production.

3. Go live!
===========

Let's go: ``tag`` our application so that Docker knows where to prod it:

```bash
# docker tag <local app name>  sailabove.io/<user name>/<app name>
docker tag hello-node sailabove.io/demo/hello-node
```

Push your application on Sailabove's *private* Docker registry:

```bash
# docker push <previously created tag>
docker push sailabove.io/demo/hello-node
```

Launch it using previously installed ``sail`` command line and instruct Sailabove to run it with unprivileged user ``nobody`` for increased security. Please note that, even when running as regular unprivileged user, your application can freely listen on *any* port, ``80`` in this case.

```bash
# sail services add <user name>/<app name> <service name>
sail services add demo/hello-node hello-node
```

Eager to see the result? Wait a few seconds. It is now running live on http://hello-node.demo.app.sailabove.io/hello/Docker-Fan. This is ``http://<service name>.<user name>.app.sailabove.io``.

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