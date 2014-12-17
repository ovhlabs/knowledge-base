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

In this guide you'll discover how to use Docker Machine on RunAbove. This is **an
experiment**: Docker machine uses a [development branch](https://github.com/docker/docker/pull/8265)
of Docker implementing a TLS encryption and a identity-based authentication and
the OpenStack driver is [still in development](https://github.com/docker/machine/pull/73).

This guide will be updated following the evolutions of [Docker Machine](https://github.com/docker/machine)
and its [OpenStack driver](https://github.com/docker/machine/pull/73).

# Install Docker Machine command line

<div style="float:right; margin-left: 15px;">
	<a href="https://github.com/docker/machine">
		<img src="/kb/images/2014-12-12-docker-in-5-minutes-on-runabove-with-docker-machine/docker-logo.png" alt="Docker" />
	</a>
</div>

We provide you built binaries of [Docker Machine](https://github.com/docker/machine)
with the [OpenStack driver](https://github.com/docker/machine/pull/73) at its
current development state:

* [Linux amd64](https://storage.sbg-1.runabove.io/v1/AUTH_d186206b24cd46b1a842bbd76ee11f8e/docker-machine/machine_linux_amd64)
* [Linux i386](https://storage.sbg-1.runabove.io/v1/AUTH_d186206b24cd46b1a842bbd76ee11f8e/docker-machine/machine_linux_386)
* [Linux arm](https://storage.sbg-1.runabove.io/v1/AUTH_d186206b24cd46b1a842bbd76ee11f8e/docker-machine/machine_linux_arm)
* [Windows i386](https://storage.sbg-1.runabove.io/v1/AUTH_d186206b24cd46b1a842bbd76ee11f8e/docker-machine/machine_windows_386.exe)
* [Windows amd64](https://storage.sbg-1.runabove.io/v1/AUTH_d186206b24cd46b1a842bbd76ee11f8e/docker-machine/machine_windows_amd64.exe)
* [Mac OSX i386](https://storage.sbg-1.runabove.io/v1/AUTH_d186206b24cd46b1a842bbd76ee11f8e/docker-machine/machine_darwin_386)
* [Mac OSX amd64](https://storage.sbg-1.runabove.io/v1/AUTH_d186206b24cd46b1a842bbd76ee11f8e/docker-machine/machine_darwin_amd64)

If you want to build Docker Machine with the [OpenStack driver](https://github.com/docker/machine/pull/73)
by yourself, the details are available in the [README of the project](https://github.com/docker/machine/blob/master/README.md).

# Install Docker client with identity authentication support

Your Docker client will use an identity-based authentication to communicate with
the Docker daemon that will be installed on your instance. Builds by
[Ben Firshman](https://github.com/bfirsh) of Docker Inc. are available here:

* [Mac OS X](https://bfirsh.s3.amazonaws.com/docker/darwin/docker-1.3.1-dev-identity-auth) 
* [Linux](https://bfirsh.s3.amazonaws.com/docker/linux/docker-1.3.1-dev-identity-auth)

If you want to build Docker on this branch, the build instructions are available
[here](https://docs.docker.com/contributing/devenvironment/) and the
[pull request #8265 here](https://github.com/docker/docker/pull/8265).

# Getting started with Docker Machine on RunAbove

## Get your OpenStack credentials

Set your credentials in your environment using the [Open RC
file](https://manager.runabove.com/horizon/project/access_and_security/api_access/openrc/)
that you can download using the horizon dashboard.

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
$ machine create \
  -d openstack \
  --openstack-flavor-name="ra.intel.ha.s" \
  --openstack-image-name="Ubuntu 14.04" \
  --openstack-net-name="Ext-Net" \
  --openstack-ssh-user="admin" \
  my-docker-host
```

In the example above, we use [a Steadfast Resources S instance](https://www.runabove.com)
as flavor and an Ubuntu 14.04 as image (For now, Docker Machine only supports
Ubuntu as Host OS). All the flavor and image available are listed in your
[Expert dashboard](https://cloud.runabove.com/horizon/).

Once deployed, you just need to declare to your Docker client that you'll use
your fresh installed Docker daemon on your RunAbove instance:

```bash
$ export DOCKER_HOST=$(machine url) DOCKER_AUTH=identity
```

Your Docker client and the server will establish a TCP connection on port 2276.
Do not forget to add a rule for that on your security group. That's all, you
can now use your Docker Machine with your local Docker client:

```bash
$ docker info
The authenticity of host "1.2.3.4:2376" can't be established.
Remote key ID 6D2O:BGXV:I3AE:WH7W:OIRG:JPVU:EJET:UD7H:TASU:EFAU:CIJG:HEIP
Are you sure you want to continue connecting (yes/no)? yes
Containers: 0
Images: 3
Storage Driver: aufs
 Root Dir: /var/lib/docker/aufs
 Dirs: 3
Execution Driver: native-0.2
Kernel Version: 3.13.0-37-generic
Operating System: Ubuntu 14.04.1 LTS
CPUs: 1
Total Memory: 1.955 GiB
Name: vm
ID: 6D2O:BGXV:I3AE:WH7W:OIRG:JPVU:EJET:UD7H:TASU:EFAU:CIJG:HEIP
WARNING: No swap limit support
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

Feel free to join the discussion about this OpenStack driver on the ongoing
[pull request](https://github.com/docker/machine/pull/73), and to post on [RunAbove
Community](https://community.runabove.com/share/) if you have any question or
comment about using [Docker](http://www.docker.com) on RunAbove.
