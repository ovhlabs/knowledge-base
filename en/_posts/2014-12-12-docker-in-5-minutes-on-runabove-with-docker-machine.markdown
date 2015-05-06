---
layout: post
title: "Docker in 5 minutes on RunAbove with Docker Machine"
categories: Instances
author: gierschv
---

[Docker](http://www.docker.com) is a great tool to easily deploy your
applications. Docker Inc. recently introduced a new project,
[Docker Machine](https://github.com/docker/machine),
that allows you to easily setup multiple Docker hosts across multiple cloud providers,
and use them with your local Docker client.

In this guide you'll discover how to get started with Docker Machine and boot
quickly your first Docker Instance on RunAbove ready to host your first
containers.

# Install Docker Machine and Docker client

<div style="float:right; margin-left: 15px;">
	<a href="https://github.com/docker/machine">
		<img src="/kb/images/2014-12-12-docker-in-5-minutes-on-runabove-with-docker-machine/docker-logo.png" alt="Docker" />
	</a>
</div>


You can find the installation details in the
[Docker documentation website](https://docs.docker.com/machine/#osx-and-linux).
You'll need the two following binaries for this tutoral:

* `docker-machine`: The Docker Machine component that includes the provisioning
support of an OpenStack instance with the Docker engine.
* `docker`: The Docker client that will be used to remotely control the Docker
host we'll setup in this guide.

If you are already using Docker Machine in a older version than 0.2, please
upgrade your client since the provisioning of the OpenStack instances was
re-introduced in this version
(added in [12bed9e](https://github.com/docker/machine/commit/12bed9eafcb445df166721ee273dca18b2495a7d)).

# Getting started with Docker Machine on RunAbove

## Get your OpenStack credentials

Set your credentials in your environment using the [Open RC
file](https://manager.runabove.com/horizon/project/access_and_security/api_access/openrc/)
that you can download using the OpenStack Horizon dashboard.

```bash
$ source XXXXXXX-openrc.sh
```
You need to set the availability zone where you want to deploy your new instance
(*SBG-1* or *BHS-1*) using the following environment variable:

```bash
$ export OS_REGION_NAME=SBG-1
```

## Create your first Docker Machine: a RunAbove Instance

Deploying a new instance with a Docker daemon is now as simple as a simple command:

```bash
$ docker-machine create \
  -d openstack \
  --openstack-flavor-name="ra.intel.ha.s" \
  --openstack-image-name="Ubuntu 14.04" \
  --openstack-net-name="Ext-Net" \
  --openstack-ssh-user="admin" \
  my-docker-host
```

In the example above, we use [a Steadfast Resources S instance](https://www.runabove.com)
as flavor and an Ubuntu 14.04 as image (For now, Docker Machine only supports
Ubuntu as Host OS). All the flavors and images available are listed in your
[OpenStack Horizon dashboard](https://cloud.runabove.com/horizon/).

Once deployed, you just need to declare to your Docker client that you'll use
your fresh installed Docker daemon on your RunAbove instance:

```bash
$ eval "$(docker-machine env my-docker-host)"
```

Your Docker client and the server will establish a TCP connection on port 2276.
Do not forget to add a rule for that in
[your security group](https://manager.runabove.com/horizon/project/access_and_security/).
That's all, you can now use your Docker Machine with your local Docker client:

```bash
$ docker info
Containers: 0
Images: 0
Storage Driver: aufs
 Root Dir: /var/lib/docker/aufs
 Backing Filesystem: extfs
 Dirs: 0
 Dirperm1 Supported: false
Execution Driver: native-0.2
Kernel Version: 3.13.0-44-generic
Operating System: Ubuntu 14.04.1 LTS
CPUs: 1
Total Memory: 1.955 GiB
Name: my-docker-host
ID: GIQ3:CKU3:4NDF:UTS3:RIYC:XGKV:CJCV:VPRY:333J:KHT6:T42M:YW43
WARNING: No swap limit support
Labels:
 provider=openstack
```

```bash
$ docker run hello-world
Hello from Docker.
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (Assuming it was not already locally available.)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

For more examples and ideas, visit:
 http://docs.docker.com/userguide/
```

Feel free to post on [RunAbove Community](https://community.runabove.com/share/)
if you have any question or comment about using [Docker](http://www.docker.com)
on RunAbove.
