---
layout: post
title: "Working with the Predictor load balancer"
categories: docker/documentation
tags: sailabove, reference
lang: en
author: yadutaf
---

[Sailabove][7] is the scalable, HA Cloud Docker Hosting platform by Runabove. It comes with out of the box load balancing, HA persistent volumes and seemless private networks.

This documentation is about Sailabove load balancer. To get started, [Create your account][7] and see our [Getting Started guide][8] first.

If you are building or running a web/HTTP based application, you can use the "predictor" to get out-of-the-box load-balancing. The predictor is based on technologies originally built for OVH's shared Hosting. It scales!

When a service is configured to work with the predictor, the containers are automatically registered or unregistered as the service is scaled up or down. If a container stops responding, it will automatically be marked as faulty and further requests will be directed to another container.

Technically, the predictor is built on top of the proven Nginx reverse proxy. It supports websockets and POST requests streaming so that there is no lag due to buggering neither upload limit. Unless you define one in your application, of course.

# Getting started

All services using ``--network predictor`` will automatically use the load balancer. For example, to start a hello world application on the predictor:

```
$ sail services add demo/hello-python <user name>/hello-python --network predictor
```

As saying "hello" is quite popular, our "Hello as a Service" application is now handling thousands of requests per second. We need to scale:

```
$ sail services scale <user name>/hello-python --number 3
```

That's all. All 3 containers are now handling their share of the requests on domain ``http://hello-python.<user name>.app.sailabove.io/``

# Attaching custom domains

Now that you have a scalable, load-balanced application, you will most probably want to publish it with an appealing domain. Let's say ``www.sayhello.com``. All you need to do is:

```
$ sail services domain-attach <user name>/hello-python www.sayhello.com
```

It can be detached at any time with:

```
$ sail services domain-detach <user name>/hello-python www.sayhello.com
```

# Routing specific URLs to dedicated services

URI based routing allows requests matching a specific pattern to be redirected to a dedicated service. For different applications, this allows to share a single domain under multiple prefixes. For micro-service oriented applications, this allows to deploy, monitor and scale each service endpoint independentely.

For example, let's say we have both a blog and a redmine application and that they both should be accessible from a single, trusted domain. One could attached domains like:

```
$ sail services domain-attach <my-app>/wordpress private.example.com --pattern /blog
$ sail services domain-attach <my-app>/redmine   private.example.com --pattern /redmine
$ sail apps domain-list <my-app>
DOMAIN               SERVICE             METHOD  PATTERN
private.example.com  <my-app>/wordpress  *       /blog
private.example.com  <my-app>/redmine    *       /redmine
```

In this case, the predictor will route by prefix. In other words, all URLs starting by '/blog/' will go to wordpress and all requests starting with ''. Method ``*`` means that all HTTP methods (GET, POST, DELETE, ...) will be directed to this backend.

When building a micro-service oriented application, finer grained prefix matching may be needed. For this use case, patterns may be defined as simple regular expressions. ``*`` wildcard will match until the next ``/``. ``$`` at the end of the pattern behaves like its counter part in perl regular expressions meaning that the pattern must match until the end of the URL. Requests may also be routed based on the HTTP verb. For example, one may want to direct all GET requests to a ligntning fast code while POST requests would go to a slower but robust processing service. The default method is ``*``. It matches asny HTTP method if no more specific rul has been defined.

For example, let's build a trivial sms sending application to french cell phones:

```
GET /sms$
GET /sms/+33-6-*
GET /sms/+33-7-*
POST /sms/+33-6-*$
POST /sms/+33-7-*$
```

We'll attach the routes, like the blog+redmine example:

```
$ sail services domain-attach <my-app>/sms-dests api.sms.com --method GET --pattern '/sms$'
$ sail services domain-attach <my-app>/sms-list  api.sms.com --method GET --pattern '/sms/+33-6-*'
$ sail services domain-attach <my-app>/sms-list  api.sms.com --method GET --pattern '/sms/+33-7-*'
$ sail services domain-attach <my-app>/sms-send  api.sms.com --method POST --pattern '/sms/+33-6-*$'
$ sail services domain-attach <my-app>/sms-send  api.sms.com --method POST --pattern '/sms/+33-7-*$'

$ sail apps domain-list <my-app>
DOMAIN       SERVICE             METHOD  PATTERN
api.sms.com  <my-app>/sms-dests  GET     /sms$
api.sms.com  <my-app>/sms-list   GET     /sms/+33-6-*
api.sms.com  <my-app>/sms-list   GET     /sms/+33-7-*
api.sms.com  <my-app>/sms-send   POST    /sms/+33-6-*$
api.sms.com  <my-app>/sms-send   POST    /sms/+33-7-*$
```

 - ``GET /sms`` will match ``/sms$``
 - ``GET /sms/+33-6-02-03-04-05`` will match ``/sms/+33-6-*``
 - ``POST /sms/+33-6-02-03-04-05`` will match ``/sms/+33-6-*/send$``
 - ``DELETE /sms/+33-6-02-03-04-05`` will not match any rule because there is not ``DELETE`` route
 - ``POST /sms/+44-6-02-03-04-05`` will not match any rule because it does not start with the French indicator
 - ``POST /sms/+33-6-02-03-04-05/test`` will not match any rule because of the trailling '$'


> **Note:** Rules behaves as prefixes by default. For example, if we had omitted the trailing ``$`` in rule ``/sms$``, URLs like ``/sms-premium`` or ``/sms/admin`` would have matched too.

# Load balancing policy

The predictor is a stateful load balancer. This means that all requests from a given client will always be directed to the same backend container. This is important if the container needs to keep session specific state in ``/tmp`` for example.

New sessions are balanced to your service following a round-robin policy. Further requests from the same client will then all be directed to the same backend container, unless it has been stopped.

Internally, this relies on a *sticky cookie* named "``__predictor``". This name may change at any time in the future.

# Getting help

- Get started: [Getting started quide][8]
- Documentation: [Reference documentation][9], [Guides][10]
- Join OVH Docker mailing list: [docker-subscribe@ml.ovh.net][1]
- Visit our Community: [https://community.runabove.com/][2]
- Drop us an e-mail: [sailabove@ovh.net][3]
- Create your account: [Sailabove.com][7]


  [1]: mailto:docker-subscribe@ml.ovh.net
  [2]: https://community.runabove.com/
  [3]: mailto:sailabove@ovh.net
  [7]: https://sailabove.com/
  [8]: /kb/en/docker/getting-started-with-sailabove-docker.html
  [9]: /kb/en/docker/documentation
  [10]: /kb/en/docker/
