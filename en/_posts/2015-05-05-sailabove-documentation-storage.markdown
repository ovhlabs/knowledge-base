---
layout: post
title: "Working with persistent Data Volumes"
categories: docker/documentation
tags: sailabove, reference
lang: en
author: yadutaf
---

[Sailabove][7] is the scalable, HA Cloud Docker Hosting platform by Runabove. It comes with out of the box load balancing, HA persistent volumes and seemless private networks.

This documentation is about Sailabove persistent storage. To get started, [Create your account][7] and see our [Getting Started guide][8] first.

When a Docker container starts a temporary overlay layer is created for it. This temporary layer will serve as a scratchpad or a sandbox for the container. Any changes made in this area is discarded when the container is stopped. In other words, none of the changes made to the container at runtime is persistent. This is great for security: If a container suddenly starts behaving strangely, rebooting it will most probably help to solve or at least work around the issue. Technically, we use [overlayfs][1] to build the overlays.

If containers are the "logic" layer of your application, volumes are its "data" layer. Keeping them clearly separated is the key building block for High Availability.

# Data Volumes

Some data are special and must persist across reboots. For example, if we consider a MySQL or MariaDB container, we need to preserve ``/var/lib/mysql`` during the full container lifecycle since there is hardly a use case for a MySQL database that resets itself on each boot. This is what Data ``Volumes`` are for.

A data volume or simply "Volume" is a special location in the container declared as persistent. Technically, any data in this location will bypass the temporary layer and be written to or read from a persistent, replicated, HA volume.

Using HA volumes on the backend allows us to immediately restart any container on any host in the event of Host failure. As there is no data to move, this guarantees the container will be back online in a matter of seconds.

Volumes are specific to each container. When a service is scaled up, new volumes are automatically provisioned for the new containers. When a service is scaled down, the volumes are automatically destroyed.

# Use Volumes

The first way to declare a container is to use the [``VOLUME``][2] instruction in your image's Dockerfile. See Docker's official documentation for [detailed ``VOLUME`` syntax][2]. This instruction will store a special volume metadata in the container image. When creating a service, Sailabove will detect this instruction and automatically provision a 10GB Volume at this location for your containers.

Alternatively, if you need control over the volume size or want to create a container on any arbitrary location, you may use the ``--volume`` option of the ``sail services add`` command line. This option may be specified multiple times and expects an argument of the form ``/persistent/path`` or ``/persistent/path:<GB>``. See sail command line reference for detailed help.

## Example

### Using Dockerfile
```
 Create a 10GB (default size) Volume on /var/lib/mysql
VOLUME ["/var/lib/mysql"]
```
See https://github.com/docker-library/mariadb/blob/master/Dockerfile.template for full Dockerfile.

### Using the command line

```
 Create a 50GB Volume on /var/lib/mysql
sail services add library/mysql-template exampleuser/mysql-instance --volume /var/lib/mysql:50
```

See the command line reference for detailed informations.

# Getting help

- Get started: [Getting started quide][8]
- Documentation: [Reference documentation][9], [Guides][10]
- Join OVH Docker mailing list: [docker-subscribe@ml.ovh.net][3]
- Visit our Community: [https://community.runabove.com/][4]
- Drop us an e-mail: [sailabove@ovh.net][5]
- Create your account: [Sailabove.com][7]


  [1]: https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt
  [2]: https://docs.docker.com/reference/builder/#volume
  [3]: mailto:docker-subscribe@ml.ovh.net
  [4]: https://community.runabove.com/
  [5]: mailto:sailabove@ovh.net
  [7]: https://sailabove.com/
  [8]: /kb/en/docker/getting-started-with-sailabove-docker.html
  [9]: /kb/en/docker/documentation
  [10]: /kb/en/docker/
