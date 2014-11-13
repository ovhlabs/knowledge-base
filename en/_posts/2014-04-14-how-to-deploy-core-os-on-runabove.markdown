---
layout: post
title:  "How to deploy CoreOS on RunAbove?"
categories: Instances
author: yadutaf
lang: en
---
CoreOS is Linux for Massive Server Deployments. It leverages state of the art software like [Docker](https://www.docker.com/) and [systemd](http://fr.wikipedia.org/wiki/Systemd) to become *the* cluster operating system.

It supports painless upgrade, service discovery, overlay networks, Ceph, ... In a word, it's awesome!

And deploying it on Runabove is a breeze.

# 1. Create a custom VM template

Go the [expert mode control panel](https://cloud.runabove.com/horizon/), then go to _Images_ panel and then on the _create image_ button to install the new image.

![](https://storage.bhs-1.runabove.io/v1/AUTH_3eca649cc7f44d91b67131374db4afb3/public/coreos_screenshot1.jpg)

CoreOS distributes official OpenStack compressed images that we'll need to prepare. For example:

```
wget http://alpha.release.core-os.net/amd64-usr/current/coreos_production_openstack_image.img.bz2
bunzip2 coreos_production_openstack_image.img.bz2
```

You can then upload resulting ``coreos_production_openstack_image.img`` file (around 400MB). Alternatively You'll find an already [inflated images of CoreOS 431 here](https://storage.bhs-1.runabove.io/v1/AUTH_721b7c504d1b476691659bfee21308d8/public/CoreOS-431.img).

# 2. Launch an instance from this image

Click the _Launch_ button right next to your new image.

Pick a cool name for your instance. Say ``agent_007``. Make sure to select a network like ``Ext-Net``. Then move on to the _post-creation_ tab.

# 3. Configure your instance

![](https://storage.bhs-1.runabove.io/v1/AUTH_3eca649cc7f44d91b67131374db4afb3/public/coreos_screenshot3.jpg)

If you don't have one already, generate a unique token to identify your new CoreOS cluster. This token will allow cluster members to automatically discover their peers.

```
curl https://discovery.etcd.io/new; echo
```

Paste and customize the following [cloud-config](https://coreos.com/docs/cluster-management/setup/cloudinit-cloud-config/) script. Cloud-config is the standard for VM customization and especially well integrated by CoreOS team.

```yaml
#cloud-config
coreos:
  etcd:
    # <token> as generated above
    discovery: https://discovery.etcd.io/<token>
    addr: $private_ipv4:4001
    peer-addr: $private_ipv4:7001
  units:
    - name: etcd.service
      command: start
    - name: fleet.service
      command: start
```

# Launch... And voilà !

Don't forget to login with the user `core` instead of `admin` or `root`!

![](https://storage.bhs-1.runabove.io/v1/AUTH_3eca649cc7f44d91b67131374db4afb3/public/coreos_nodes.jpg)

You can find more information: https://coreos.com/docs/running-coreos/platforms/openstack/
