---
layout: post
title:  "How to deploy CoreOs on RunAbove?"
categories: Instances
author: Germain Masse
lang: en
---
RunAbove natively supports OpenStack CoreOS image and Cloud-init post-installation.

# Create the CoreOS image

![](https://storage.bhs-1.runabove.io/v1/AUTH_3eca649cc7f44d91b67131374db4afb3/public/coreos_screenshot1.jpg)
Compressed image sources are not yet supported. You can use this URL (uncompressed version): https://storage.bhs-1.runabove.io/v1/AUTH_3eca649cc7f44d91b67131374db4afb3/public/coreos_production_openstack_image.img (HASH: e45b99b5ddd10a17faa7b20277999253)

# Launch a new instance

![](https://storage.bhs-1.runabove.io/v1/AUTH_3eca649cc7f44d91b67131374db4afb3/public/coreos_screenshot3.jpg)

The code for the cloud-init configuration is availabe [here](https://storage.bhs-1.runabove.io/v1/AUTH_3eca649cc7f44d91b67131374db4afb3/public/coreos_cloud-config.html). Copy-paste the code into the post-creation text-area. You'll have to generate an etcd token.

# And voilà !

![](https://storage.bhs-1.runabove.io/v1/AUTH_3eca649cc7f44d91b67131374db4afb3/public/coreos_nodes.jpg)

You can find more information: https://coreos.com/docs/running-coreos/platforms/openstack/