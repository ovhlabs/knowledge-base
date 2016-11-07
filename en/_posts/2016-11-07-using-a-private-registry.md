---
layout: post
title:  "Using a private Docker registry"
categories: docker
author: brouberol
lang: en
---

In this tutorial, we'll see how to link your Marathon to a private Docker registry, and enable authenticated docker pulls.

# Adding private Docker registry credentials to your stack

The only required step to be able to pull docker images from a private registry is linking the registry credentials to your stack. You can perform this operation using the [Manager](https://www.ovh.com/manager/sunrise/containers/index.html#/containers) or the [API](https://api.ovh.com/console/#/caas/containers/%7BserviceName%7D/registry/credentials#POST).

For example, we can link your private Docker Hub account to your stack:

![Adding private registry credentials](/kb/images/2016-11-07-using-a-private-registry/private-registry.png)

*Note*: If you're looking for the registry URL, you can have a look in the `~/.docker/config.json` configuration file, on a machine where you've already performed the `docker login` operation.

Once you've added your credentials, we'll automatically deploy them onto all your slaves, and they will automatically be used when pulling the docker image. Contrary to what the official [Marathon documentation](https://mesosphere.github.io/marathon/docs/native-docker-private-registry.html) states, you don't have to include a link to your credentials when deploying application to Marathon. We're taking care of this for you.

That's it, nothing else!

*Note*: you can link credentials to any number of different private registries to your stack. Furthermore, OVH will soon provide you with an in-house authenticated Docker registry.

