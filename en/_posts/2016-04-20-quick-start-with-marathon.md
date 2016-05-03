---
layout: post
title:  "Quick start with Marathon"
categories: Docker
author: devatoria
lang: en
---

Welcome to the quick start tutorial of the Docker PaaS lab. This document will help you launch your first application using the Marathon Web UI.

# First and foremost

If you haven't already read our [introduction to Docker with Mesos and Marathon](/kb/en/introduction-to-docker-with-mesos-marathon.html), you should probably read it before diving in.

#Access to your Marathon Web UI

Once your Mesos slave has been installed, you'll receive an email containing the URL and credentials of your marathon.


![Main interface](/kb/images/2016-04-20-quick-start-with-marathon/marathon.png)

This screenshot gives a first taste of what can be done with Marathon:

- in the **Applications** tab, you can find all your applications with:
  - a summary about the consumed resources
  - the application state
  - a lot of sorting options
  - a search form
- in the the **Deployments** tab, you have a summary of the current deployments with the associated state and affected applications

#Run your first container
## General settings
Now, let's run your first container using the Web UI. First, let's click on the **Create** button. Now, fill the required general fields:

- **ID** identifies your application and must be unique. Ex: nginx
- **resources fields** allow you to tune your container as you want
  - *be careful: if you ask for more resources than available in your cluster, your container will not be able to start because no valid host will be found*

Let's now run an nginx server!

![Create interface - General](/kb/images/2016-04-20-quick-start-with-marathon/create_container_1.png)

## Docker container settings

The docker container settings allow you to use multiple docker options defined in the `docker run` command:

- **Image**: the name of the docker image, can be prefixed with the URL of the registry to use
- **Network**: the network to use *(actually, whatever you choose, the network will be defaulted to Bridged)*
- **Force Pull Image**: enable it if you want the image to be pulled everytime you launch the container, to make sure your app is always based on the ``latest`` tag.
- **Privileges**: enable this to launch your container in privileged mode *(actually automatically disabled)*

![Create interface - Docker settings](/kb/images/2016-04-20-quick-start-with-marathon/create_container_2.png)

## Docker network settings

Now let's talk about the container network configuration, the one that will allow you to access your container from the outside. From here, four fields are available to you:

- **Container Port**: represents the port exposed in the container. Example: 80 and 443 for our nginx server.
- **Host Port**: represents the port on the host that will be bound to the container port
- **Service Port**: represents the service port that will be used on the load balancer *(if not provided, this port will be set automatically by marathon)*. **Important**: a service port cannot be less than 10000.

So, let's say you want your nginx to be accessible from the outside on the port `10080`. You have to set your container port to `80` (the exposed port in the officiel nginx image) and your service port to `10080`. Next, when you will connect to your load balancer address on this port, it will access this container on the port `80`.

![Create interface - Docker network settings](/kb/images/2016-04-20-quick-start-with-marathon/create_container_3.png)

# Let's run

Now, your container is going to be deployed on a valid host which is able to handle your request. This could take a while if docker has to download the needed image.

![Create interface - Docker network settings](/kb/images/2016-04-20-quick-start-with-marathon/create_container_4.png)

# Accessing your app

You now have access to your nginx server via the URL https://<username>.lb.sbg-1.containers.ovh.net:10080, where <username> is the login you received by email.

However, if you think that this URL is not elegant enough, fear not and read our [next tutorial](/kb/en/docker/marathon-load-balancer.html)!
