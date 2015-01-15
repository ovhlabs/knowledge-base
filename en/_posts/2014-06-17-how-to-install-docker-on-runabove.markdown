---
layout: post
title:  "How to install Docker on RunAbove?"
categories: Instances
author: KDevroede
lang: en
---

Docker is a great tool to simplify the deployment of applications. It separates development from deployment, allowing you to run your application inside containers with complete resource isolation.

As RunAbove supports cloud-init post-installation, we can take advantage of this to easily install docker when spawning an instance.

# Launch host instance:

From [OpenStack Horizon](https://cloud.runabove.com/horizon/), click on _Instances_ panel and then on _Launch instance_ button. This guide is tested on Ubuntu, Debian and CoreOS, but you can test other operating system.

![Control panel screenshot](http://community.runabove.com/public/files/LzBsy2lfpeVYuJv03ii5.png)

Don't forget to add a network interface into _Networking_ tab!

# Add post-installation script to deploy docker:

Next, go to the _Post-Creation_ tab and add the command below into _Customization script_ field.

```bash
#include https://get.docker.io
```

![Control panel screenshot](http://community.runabove.com/public/files/7MPJC8i8FL2bXpFd3ax0.png)

Click on _Launch_ button to create your Docker platform.

# Use Docker

Once your instance is spawned, you can ssh into it and start using Docker.

```bash
admin@docker:~$ sudo docker version
Client version: 1.0.0
Client API version: 1.12
Go version (client): go1.2.1
Git commit (client): 63fe64c
Server version: 1.0.0
Server API version: 1.12
Go version (server): go1.2.1
Git commit (server): 63fe64c
```

If you want to learn more about Docker and how to use it, you can follow this guide:
[http://www.docker.com/tryit/](http://www.docker.com/tryit)

You can see also [how to install CoreOS on RunAbove](/kb/en/instances/how-to-deploy-core-os-on-runabove.html) to deploy a very small operating system below Docker containers.
