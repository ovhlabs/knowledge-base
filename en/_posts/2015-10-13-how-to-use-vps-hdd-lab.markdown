---
layout: post
title:  "How to subscribe to and use the VPS-HDD lab"
categories: Labs 
author: xXraphXx
lang: en
---

VPS-HDD: 1 physical disk dedicated to your virtual machine, 1T, 2T and 4T volumes. 

# Subscribe

Go to [Runabove](https://www.runabove.com) > Labs > Discover Vps-HDD > Start Now

![Lab](/kb/images/2015-10-13-how-to-use-vps-hdd-lab/step1.png)

To activate the vps-hdd lab you will have to provide a payment mean

![Activate](/kb/images/2015-10-13-how-to-use-vps-hdd-lab/step2.png)

# Spawn your instance(s)

Take care of choosing the correct parameters

 * Region where VPS-HDD is available: **`HZ-1`**

 * Images: Ubuntu 14.04, Debian 7, Fedora 20, CentOS 7

 * Flavors: vps-hdd-1000, vps-hdd-2000, vps-hdd-4000

![Region](/kb/images/2015-10-13-how-to-use-vps-hdd-lab/step3.png)

# Notes

 * When subscribing to the lab, if you go to the openstack dashboard you will also be presented some images related to the armcloud lab (ubuntu-14.04-aarch64), they are not intended (and cannot) be used for vps-hdd. If you still want to use them, subscribe to the arm lab first

 * When spawning your vps-hdd you have two disks attached to the virtual machines: one small 10G one containing the rootfs (vda), and the big volume (vdb), with a capacity matching to the flavor you chose (1T, 2T or 4T). By default we have formatted it in ext4 and mounted it on /home. Nothing prevents you from changing this if you want to.

 * When you rebuild your instance (nova rebuild, or  through the openstack dahsboard), only the primary disk content is restored. The secondary disk content will be preserved. Only if you terminate/destroy the instance will it be erased

![Disks](/kb/images/2015-10-13-how-to-use-vps-hdd-lab/step4.png)

