---
layout: post
title: "Boot a SailAbove container from a Docker image hosted on the Docker Hub"
categories: docker
tags: guide, getting-started, docker, external, repository, hub, memcached
lang: en
author: gierschv
---

SailAbove provides by default private hosted Docker repositories that allow you
to host your private docker images.

But you might want to boot a new hosted Docker container using an image hosted
on an external registry, for example, the [Docker Hub](https://registry.hub.docker.com).
To simplify the usage of these external repositores, you can add them as a
*bookmark* in your SailAbove application. 

Before diving in, make sure to read the [Getting Started guide](getting-started-with-sailabove-docker.html).

You may need to update your SailAbove CLI since the repositories management is
only avaible from the version 0.2.0:

```bash
pip install -U sail
```

## Example

Here is an example using a [memcached image created by Fedora](https://registry.hub.docker.com/u/fedora/memcached/) and hosted on the [Docker Hub](https://registry.hub.docker.com).

### Create a repository bookmark

Let's add a bookmark named "memcached" to the image we want to boot:

```bash
sail repositories add external <application>/memcached --source registry.hub.docker.com/fedora/memcached
```

The bookmark is now available next to your private hosted repositories:

```bash
sail repositories list
NAME                     TYPE      PRIVACY    SOURCE
<application>/ghost      hosted    private    -
<application>/redis      hosted    private    -
<application>/memcached  external  private    registry.hub.docker.com/fedora/memcached
```

### Start from the repository bookmark

You can now create your SailAbove service from your bookmark like you would do
with any hosted repository:

```bash
sail services add <application>/memcached --user nobody --network private cache
```