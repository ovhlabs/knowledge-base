---
layout: post
title: "How to use Sail Above webhooks"
categories: docker
tags: guide
lang: en
author: tgermain

---

A new feature was released in Sailabove [0.6.0](https://github.com/runabove/sail/releases/tag/v0.6.0): web-hooks

This features allows to to get notified for every state change of your container (eg: the container state changed from RUNNING to CRASHED, etc) at a URL of your choice.

#How it works

In Sailabove, a container has a finite set of states, that you can inspect using `sail container list`

The complete state graph look like this :

![container states](/kb/images/2015-11-23-use-sailabove-webhook/container-states.jpg)

If you declare a *webhook*, you will receive a JSON payload each time a container's state changes.

Here is an example of a JSON payload you'll receive:

```
{
    "service": "hello-python",
    "timestamp": 1448015759.061321,
    "application": "toto",
    "id": "b9e7bef7-d571-4ee4-b80e-835a2377040e", <- id of the container
    "state": "STOPPED",
    "prev_state": "STOPPING",
    "type": "Container",
    "data": {
        "last_exit_status": {
            "raw_exit_status": 256,
            "reason": "exited",
            "exit_status": 1
        }
    },
    "event": "state",
    "counters": {
        "start": 12, <- how many times your container has started.
        "post_attempts": 5 <- how many times we've tried to contact this hook url before succeeding.
    }
}
```

The ``last_exit_status`` section describes how your container was terminated :

- Either it was killed with a signal 9 (SIGKILL).

```
"last_exit_status": {
    "raw_exit_status": 256,
    "reason": "signaled",
    "signal": 9
}
```


- It did exit gracefully with a return value of 1

```
"last_exit_status": {
    "raw_exit_status": 256,
    "reason": "exited",
    "exit_status": 1
}
```


- It did exit, neither gracefully nor with a SIGKILL, with a return value different of 0.

```
"last_exit_status": {
    "raw_exit_status": 256,
    "reason": "raw",
}
```

**Note** : Events are not guaranteed to arrive in order. You can sort the events using the `timestamp` field.

**Note 2** : Don't worry if your webhook's endpoint is unavailable sometimes, we retry to send the event up to 10 times ( aka maximum delay between event triggered and last send attempt is 2 hours).

##Webhook url validation

There are a few rules for webhook urls validation :

- Support of http and https only.
- Support of port in url
- Deny localhost url

Recap :

- `http://ovh.com/callback-sink` is fine.
- `https://ovh.com/secure-callback-sink` is fine too.
- `http://kimsufi.ninja:4242/callback-sink` is perfectly ok.
- `https://localhost:8080/my-sink` is *refused* because it is `localhost`.
- `mail://ovh.com/my-mail-sink` is *refused* because of the `mail` protocol.


#How to use it

In the following, we'll assume you already have a working account, named "toto", along with a "hello-python" application. If that's not the case, please follow the instructions of [this tutorial]({% post_url 2014-09-29-hello-python %}) first.

Your application is listed:

```
$  sail container list
APPLICATION         SERVICE             CONTAINER                              STATE               DEPLOYED
toto                hello-python        0e6599f7-8c97-4a77-9265-960eaeae2cc3   RUNNING             2015-11-23T16:12:03.373468
```

You can add a webhook using the followingi command: `sail application webhook add toto http://mydashboard.com/toto`.

You can then list the application webhooks using this command
```
$  totosail application webhook list toto
- url: http://mydashboard.com/toto
```

**Note** : you can specify several webhooks for an application.

#Example of usage : save and show the evolution of the state of your container
In this section, we will write a simple HTTP server, which will receive and store the events sent by Sailabove.

Our app will consist in 2 endpoints :
- `/api/post` to received JSON events.
- `/api/list` to list previously received events.

We will use [go-apish](https://github.com/thbkrkr/go-apish) for the server. It's allow use to write bash script and use them as endpoints.

The sources of this little server are available on github ( [https://github.com/tgermain/wouebouc](https://github.com/tgermain/wouebouc) ). There's also a ready to run docker image as *tgermain/ouebouc*.

To try it :

1- pull the image from docker hub:

```
docker pull tgermain/ouebouc
```


2- tag the image so that Docker knows where to push it:

```
# docker tag <local app name>  sailabove.io/<user name>/<app name>
docker tag tgermain/ouebouc sailabove.io/toto/webhook-endpoint
```

3- push your application to Sailabove's *private* Docker registry :

```
docker push sailabove.io/toto/webhook-endpoint
```


4- deploy it on sailabove :

```
sail service add toto/webhook-endpoint webhook-endpoint
```


Now our app is up and running on [http://webhook-endpoint.toto.app.sailabove.io](http://webhook-endpoint.toto.app.sailabove.io) (This is `http://<service name>.<user name>.app.sailabove.io.`)

We can now register it as our "toto" application webhook :

```
sail application webhook add toto http://webhook-endpoint.toto.app.sailabove.io/api/post
```

Anytime one of your application containers' state changes, a JSON event will be sent to [http://webhook-endpoint.toto.app.sailabove.io/api/post](http://webhook-endpoint.toto.app.sailabove.io/api/post).

You can list all the previous events by calling `http://webhook-endpoint.toto.app.sailabove.io/api/list`.

```
$ curl http://webhook-endpoint.toto.app.sailabove.io/api/list | python -mjson.tool
[
  {
    "application": "toto",
    "counters": {
      "post_attempts": 0,
      "start": 10
    },
    "data": {},
    "event": "state",
    "id": "0e6599f7-8c97-4a77-9265-960eaeae2cc3",
    "prev_state": "RUNNING",
    "service": "hello-python",
    "state": "STOPPING",
    "timestamp": 1448379641.721856,
    "type": "Container"
  }
]
```

##Disclaimer
This is a toy app to demonstrate how you can use webhooks. It does not persist events and should not be used in production.
