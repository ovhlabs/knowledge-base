---
layout: post
title:  "Locally stateful containers and volumes"
categories: docker
author: tgermain
lang: en
---



This tutorial explains how locally stateful containers and volumes work.



# Volumes :

The current version of volumes works exactly as docker host volume : the idea is to share a directory or a file between the host and the container.

Example :

```
host $  mkdir -p ~/data/toto
host $  touch ~/data/toto/hello
host $  docker run -ti -v ~/data/toto:/data/ alpine sh
container $ ls /data
hello
container $ touch /data/fromTheOtherSide
host $ ls ~/data/toto/
fromTheOtherSide  hello
```

Here we create a directory `~/data/toto` on the host, let's call it the **hostPath**. We create a file *hello* in it.

When we run the container, we tell docker to map `~/data/toto` aka the **hostPath** to `/data/`, the **containerPath**, inside the container.

The binding is bidirectionnal : if the container creates a file `/data/fromTheOtherSide`, we are able to see it from the host.



There are some limitations on what you can mount in your container, to achieve that we [chroot](https://en.wikipedia.org/wiki/Chroot) any **containerPath**.


Example:

For a user toto, this volume :

```
"volumes": [
    {
          "containerPath": "/log",
          "hostPath": "/var/log",
    }
]
```

is tranformed into :

```
"volumes": [
    {
          "containerPath": "/log",
          "hostPath": "/containerdata/user-toto/var/log",
    }
]
```


# Problems

## Chrooting issue

This can cause troubles, especially if you try to mount a file from the host and read it from the container :

We want to mount the file `/etc/localtime` from the host to `/etc/localtime` in the container to get the same time settings as the host.

The **hostPath** is modified from `/etc/localtime` to `/containerdata/user-toto/etc/localtime`.


This path does not exist on the host, when the container starts docker creates it as a directory, it's the default behaviour.
If the code inside the container tries to read  `/etc/localtime` (the **containerPath**) as a file, it fails because it's a directory on the host.



If you run into that kind of problem, you can troubleshoot it in the "Debug" tab of your application:

```
Message executor

    failed to run container: docker failed to start container  0cf43b13cbd46912d43df6f760a21d5fb28e759ecd74ed240d156fef96d34347: Error  response from daemon: rpc error: code = 2 desc = "oci runtime error:  could not synchronise with container process: not a directory"
```

The message basically means that a directory was treated as a file and it didn't go well.


## User namespace remap
The local storage feature currently has issues with permissions. Currently, we are only able to deal with data owning if the process inside the container runs as *root*. This is a known limitation and we are working on removing it.


Under the hood, we use ["User namespace"](https://blog.yadutaf.fr/2016/04/14/docker-for-your-users-introducing-user-namespace/). They allow us to provide you with a root user in your container which is not the actual Host's root. While this improves the application security, this also comes with some constraints


Roughly, it maps the user *root* (uid 1) inside the container to an unprivileged user on the host (uid 65536 for example).


If the program which uses data on the volume inside the container runs as *root* we are able to set the right permissions for the volume before the container starts. If the program doesn't run as root, we cannot tell which uid it use, thus we cannot set the right permissions on your local volume.


## Data locality

The data you write from your container in a volume mapped on a directory of the host is local to the host. It means that if your container restart on another host, the data you write before will not be present.

To make sure the container always starts on the same host we can use Marathon constraints. Inspect your application, and copy the name of the slave it has been deployed on, then add the following Marathon constraint: `hostname:LIKE:<hostname>`.

![constraint](/kb/images/2016-06-17-marathon-api-worker-queue/redis3.png)

