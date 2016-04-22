---
layout: post
title:  "Quick start with Marathon"
categories: Docker
author: devatoria
lang: en
---

Welcome to the quick start tutorial of the PaaS Docker lab. This document will guide you to launch your first application and play with it.

#Access to your interface

After requesting your stack deployment through RunAbove labs section, you can access your Marathon web access using the given URL.


![Main interface](/kb/images/2016-04-20-quick-start-with-marathon/marathon.png)
 
Here you can see a lot of things you can do. Let's look around:

- in the **Applications** tab, you can find all your applications with:
  - a summary about the consumed resources
  - the application state
  - a lot of sorting options
  - a search form
- in the the **Deployments** tab, you have a summary of the current deployments with the associated state and affected applications

#Run your first container
## General settings
Now, let's run your first container through the interface. First, let's click the **Create** button. Now, fill the required general fields:

- **ID** identifies your application and must be unique
- **resources fields** allow you to tune your container as you want
  - *be careful: if you ask too many resources, your container will not be able to start because no valid host will be found*

Let's ask for a little nginx application.

![Create interface - General](/kb/images/2016-04-20-quick-start-with-marathon/create_container_1.png)

## Docker container settings

The docker container settings allow you to select multiple docker settings you could find in the `docker run` command:

- **Image**: the name of the docker image, can be prefixed with the URL of the registry to use
- **Network**: the network to use *(actually, whatever you choose, the network will be defaulted to Bridged)*
- **Force Pull Image**: enable if you want the image to be repulled everytime you launch the container, so you ensure it will be up-to-date
- **Privileges**: enable this to launch your container in privileged mode *(actually automatically disabled)*

![Create interface - Docker settings](/kb/images/2016-04-20-quick-start-with-marathon/create_container_2.png)

## Docker network settings

Now let's talk about the container network configuration, the one that will allow you to access your container from the outside. From here, four fields are available to you:

- **Container Port**: represents the port exposed in the container
- **Host Port**: represents the port on the host that will be bound to the container port
- **Service Port**: represents the service port that will be used on the load balancer *(if not provided, this port will be set automatically by marathon)*

So, let's admit you want your nginx to be accessible from the outside on the port `10080`. You have to set your container port to `80` (the exposed port in the officiel nginx image) and your service port to `10080`. Next, when you will connect to your load balancer address on this port, it will access this container on the port `80`.

![Create interface - Docker network settings](/kb/images/2016-04-20-quick-start-with-marathon/create_container_3.png)

# Let's run

Now, your container is going to be deployed on a valid host which is able to handle your request. This could take a while if docker has to download the needed image.

![Create interface - Docker network settings](/kb/images/2016-04-20-quick-start-with-marathon/create_container_4.png)

You can access your application via [your load balancer address](http://username.lb.sbg-1.containers.ovh.net:10080/).
