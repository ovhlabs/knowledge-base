---
layout: post
title:  "How to setup an API / worker queue infrastructure with Marathon"
categories: Docker
author: brouberol
lang: en
---

This tutorial assumes you already have a RunAbove account and have subscribed to the [Docker PaaS](https://www.runabove.com/docker-with-mesos-marathon.xml).

# First and foremost

If you haven't already read our [introduction to Docker with Mesos and Marathon](/kb/en/docker/introduction-to-docker-with-mesos-marathon.html), you should probably read it before diving in.

# About the API / worker queue infrastructure

This architecture combines two well known patterns: [HTTP REST APIs](https://en.wikipedia.org/wiki/REST_API) and [worker queues](https://en.wikipedia.org/wiki/Thread_pool). It allows you to schedule asynchronous tasks, and fetch their status and associated results using HTTP requests. The tasks will be sent to workers through a broker, and their execution metadata (result, status, etc) will be stored in a backend.

![API / worker queue design](/kb/images/2016-06-17-marathon-api-worker-queue/design.png)

In our case, we'll use the following tools and frameworks to deploy this architecture on the [Docker PaaS](https://www.runabove.com/docker-with-mesos-marathon.xml):

* [Flask](http://flask.readthedocs.org/) for the HTTP REST API
* [Redis](http://redis.io/) for the message broker
* [Celery](http://celery.readthedocs.org/) for the asynchronous workers
* [Redis](http://redis.io/) for the result backend

The application code is available on [Github](https://github.com/brouberol/ovh-dockeraas-demo), and the Docker image is available on the [Docker Hub](https://hub.docker.com/r/brouberol/ovh-containers-demo/). Note that the API and worker code is shared, packaged in the same [Docker image](https://github.com/brouberol/ovh-dockeraas-demo/blob/master/Dockerfile), and exposed through different [entrypoint commands](https://github.com/brouberol/ovh-dockeraas-demo/blob/master/entrypoint.sh).

# Deploy the broker / result backend

We've chosen (for simplicity's sake) to use redis for both the broker and result backend, and deploying it as a single instance. As it turns out, deploying it is quite simple!

You need to create a Marathon application using the `redis` official [Docker image](https://hub.docker.com/_/redis/). We'll use the custom command `redis-server --appendonly yes --protected-mode no --requirepass SECRETPASSWORD` to make sure the redis server is password protected, as it will be exposed on a public IP. The container must expose its TCP port 6379 to the load balancer: to do this, either set a service port (here set to 10000), or leave it empty and marathon will take care of it for you.

Then, mount `/data` as a read-write docker volume. This will ensure data persistence, even after the container is redeployed.

![redis configuration 1/2](/kb/images/2016-06-17-marathon-api-worker-queue/redis.png)

Then, you can add your [PaaS Logs](https://www.runabove.com/paas-logs.xml) token and [PaaS Timeseries](https://www.runabove.com/iot-paas-timeseries.xml) token to the app labels, to [redirect your logs](https://community.runabove.com/kb/en/docker/marathon-container-logs.html) [and container metrics](https://community.runabove.com/kb/en/docker/marathon-container-metrics.html) to these infrastructures.

Finally, configure a TCP health check on container port 6379. By doing so, marathon will check if a TCP connection can be established with redis, and will restart the container if that's not the case.

![redis configuration 2/2](/kb/images/2016-06-17-marathon-api-worker-queue/redis2.png)

You can now connect to your redis instance by connecting to the port 10000 (or whatever service port Marathon assigned to your redis application), at the address `<username>.lb.<cluster>.containers.ovh.net`.


```bash
$ telnet <username>.lb.<cluster>.containers.ovh.net 10000
Trying 167.114.235.114...
Connected to <username>.lb.<cluster>.containers.ovh.net.
Escape character is '^]'.
AUTH SECRETPASSWORD
+OK
PING
+PONG
```

**Note**: you can derive the value of both `username` and `cluster` from the address of your marathon web ui. For example, if your UI URL is `http://lb.sbg-1.containers.ovh.net/marathon/docker-abcdef-1/`, the value of `cluster` and `username` are respectively `sbg-1` and `docker-abcdef-1`.

The only thing left to do is to make sure the redis instance is alway restarted on the same host, as for now, we only support **local** storage of Docker volumes. To do this, we'll use Marathon constraints. Inspect your application, and copy the name of the slave it has been deployed on, then add the followinf Marathon constraint:
 `hostname:LIKE:<hostname>`.

![constraint](/kb/images/2016-06-17-marathon-api-worker-queue/redis3.png)

# Deploy the HTTP REST API

We'll now deploy several instances of the HTTP REST API, as it's a purely stateless application. To do so, deploy 3 instances of the [`brouberol/ovh-containers-demo`](https://hub.docker.com/r/brouberol/ovh-containers-demo/) image, exposing the container TCP port 5000 to the load balancer.

We also need to add the command ``/usr/src/app/entrypoint.sh api``, in order to make sure the launch the HTTP API. We could have done without this command, as the ``api`` command is defined as the default one in the [Dockerfile](https://github.com/brouberol/ovh-dockeraas-demo/blob/master/Dockerfile), but we set it to be fully explicit.

![api configuration 1/2](/kb/images/2016-06-17-marathon-api-worker-queue/api.png)

As explained in the [Docker image README](https://hub.docker.com/r/brouberol/ovh-containers-demo/), we need to define the broker and result backend URIs as environment variables.

We define these environment variables:

* ``CELERY_BROKER_URI``: ``redis://:SECRETPASSWORD@<username>.lb.<cluster>.containers.ovh.net:10000/0``
* ``CELERY_RESULT_BACKEND``: ``redis://:SECRETPASSWORD@<username>.lb.<cluster>.containers.ovh.net:10000/1``

To make sure the load balancer configures the api HAProxy frontend in http mode, we must add the following Marathon labels to the application:

* ``HAPROXY_0_MODE``: ``http``. This will make sure that the backend exposed behind the first configured service port (ie: the API) is configured in http mode.
* ``HAPROXY_0_VHOST``: ``api.<username>.lb.<cluster>.containers.ovh.net``. This will make sure that the backend exposed behind the first configured service port (ie: the API) has an associated vhost. This will allow you to directly connect to the application vhost, instead of connecting to a the API service port on the load balancer.

Finally, as we did before, we add our PaaS Logs token and an HTTP health check.

![api configuration 1/2](/kb/images/2016-06-17-marathon-api-worker-queue/api2.png)

You can now connect to your API using two different addresses (given than the API is exposed behind the service port 10001):

* ``http://lb.<username>.lb.<cluster>.containers.ovh.net:10001``
* ``api.<username>.lb.<cluster>.containers.ovh.net``

```bash
$ curl api.<username>.lb.<cluster>.containers.ovh.net/
Hello world!
$ curl <username>.lb.<cluster>.containers.ovh.net:10001/
Hello world!
```

# Deploy the workers

The final part of the infrastructure left to deploy is the workers. We'll deploy 3 of them using the same docker image, with a different command: ``/usr/src/app/entrypoint.sh celery_worker``

We define these environment variables:

* ``CELERY_BROKER_URI``: ``redis://:SECRETPASSWORD@<username>.lb.<cluster>.containers.ovh.net:10000/0``
* ``CELERY_RESULT_BACKEND``: ``redis://:SECRETPASSWORD@<username>.lb.<cluster>.containers.ovh.net:10000/1``

![worker configuration](/kb/images/2016-06-17-marathon-api-worker-queue/worker.png)

We don't define any health check, as the worker does not expose any TCP nor HTTP port. As for the other applications, we can add our PaaS Logs and Timeseries tokens as labels.

# Testing

We can now use our API to schedule tasks and fetch their result:

```bash
$ curl -X POST api.<username>.lb.<cluster>.containers.ovh.net/tasks
{
  "task_id": "6ed2c18e-5b03-4308-a316-8e034a9d69e0"
}
$ curl -X GET api.<username>.lb.<cluster>.containers.ovh.net/tasks/6ed2c18e-5b03-4308-a316-8e034a9d69e0
{
  "children": [],
  "result": 2,
  "status": "SUCCESS",
  "traceback": null
}
$ curl -X POST api.<username>.lb.<cluster>.containers.ovh.net/tasks
{
  "task_id": "b8c96395-0cc5-41ed-901c-0ba81306c796"
}
$ curl -X GET api.<username>.lb.<cluster>.containers.ovh.net/tasks/b8c96395-0cc5-41ed-901c-0ba81306c796
{
  "children": [],
  "result": 93,
  "status": "SUCCESS",
  "traceback": null
}
```

That's it!