---
layout: post
title: "Manage instances from the command line using nova"
categories: Instances
author: rmopl
---

Previously, we have covered [how to install OpenStack command line tools and grant them access to our RunAbove account](/kb/en/instances/use-openstack-command-line-tools.html). Now, let's use them. 

Setting the stage
-----------

The nova tool has a long list of subcommands and flags. You can explore them by just typing

    nova

which will spam your terminal with all the options. 

The important one is `--os-region-name`. This is how you choose whether you want to work in Canada (BHS-1), or Europe (SBG-1). I will use the European data center in this tutorial but you may substitute BHS-1. Choose the region with lower latency (closer to you) and remember that they are independent so they have their own separate ssh keys, instances lists, etc. Make sure you are looking at the right region when something unexpectedly does not show up. 

To avoid explicitly specifying the region every time, pick a default one by setting the environment variable `OS_REGION_NAME`

    export OS_REGION_NAME=SBG-1 

You can add it to the OpenRC file and have it set every time you `source` it. 

### Adding the ssh key

If you already added a key through the panel, you can use it without any further configuration.

    nova keypair-list

I did. 
    
    +--------+-------------------------------------------------+
    | Name   | Fingerprint                                     |
    +--------+-------------------------------------------------+
    | soynet | 30:60:a8:4c:15:cf:3b:c5:c1:9d:a6:98:cf:84:6a:5c |
    +--------+-------------------------------------------------+

If you haven't, this is a good time to do it. Generate the key ([see instructions for non-unix systems](/kb/en/instances/create-ssh-keys.html))

    ssh-keygen -t rsa -b 4096 -f ~/.ssh/runabove -C yourname@runabove

add it to RunAbove

    nova keypair-add --pub-key ~/.ssh/runabove.pub demokey

and make sure it's there

    $ nova keypair-list          
    +---------+-------------------------------------------------+
    | Name    | Fingerprint                                     |
    +---------+-------------------------------------------------+
    | demokey | af:25:62:c1:58:34:d1:57:a7:2d:9f:16:fb:e4:2d:d3 |
    | soynet  | 30:60:a8:4c:15:cf:3b:c5:c1:9d:a6:98:cf:84:6a:5c |
    +---------+-------------------------------------------------+

Done. 

### Choosing the flavor 

Flavor is the type of instance in OpenStack parlance. You can list flavors with the command 

    nova flavor-list                  

which will return available choices
    
    +--------------------------------------+------------------+-----------+------+-----------+------+-------+-------------+-----------+
    | ID                                   | Name             | Memory_MB | Disk | Ephemeral | Swap | VCPUs | RXTX_Factor | Is_Public |
    +--------------------------------------+------------------+-----------+------+-----------+------+-------+-------------+-----------+
    | 04fa268a-119d-4606-9590-4a2a2bb70cdd | ra.p8.s          | 4096      | 10   | 0         |      | 8     | 1.0         | False     |
    | 283d057a-2ef9-4ea0-88ec-f54b78d515ba | ra.intel.ha.l    | 8192      | 80   | 0         |      | 2     | 1.0         | True      |
    | 2daf299a-3f81-4b5f-a08a-de645ac5faa8 | ra.intel.ssd.xl1 | 28672     | 240  | 0         |      | 4     | 1.0         | True      |
    | 551dc104-4174-495a-af34-4aafe75f22ca | ra.intel.sb.l    | 4096      | 30   | 0         |      | 1     | 1.0         | False     |
    | 7b70fb9b-1968-4c30-bf9e-029bc417ac52 | ra.p8.2xl        | 49152     | 480  | 0         |      | 176   | 1.0         | False     |
    | 8f79ef0d-59ad-4792-82cd-829e0bb94f6b | ra.intel.ha.s    | 2048      | 10   | 0         |      | 1     | 1.0         | True      |
    | e17090c4-ebcf-47af-b1f8-988b0e420273 | ra.intel.ssd.xl3 | 16384     | 160  | 0         |      | 4     | 1.0         | True      |
    | eb0aa3b3-f8d1-4dfa-854e-7990b14bc705 | ra.intel.ha.m    | 4096      | 40   | 0         |      | 1     | 1.0         | True      |
    | edc5a4e4-7dd2-40fb-80a8-dbbaa0fb7914 | ra.intel.ssd.xl4 | 24576     | 240  | 0         |      | 6     | 1.0         | True      |
    | faa2002f-9057-4fe1-8401-fed7edb34059 | ra.intel.sb.m    | 2048      | 20   | 0         |      | 1     | 1.0         | False     |
    | fc4c428d-c88b-4027-b35d-2ca176a8bd1a | ra.intel.ssd.xl2 | 16384     | 240  | 0         |      | 6     | 1.0         | True      |
    +--------------------------------------+------------------+-----------+------+-----------+------+-------+-------------+-----------+

The list is a little messy but you can see all the instances. For example, Cloud Sandbox M is a flavor with codename ra.intel.sb.m.

If your list is shorter than mine, you might want to sign up for [additional experiments in the labs](http://labs.runabove.com/). The experimental flavors are marked with "False" in the "Is_Public" column. 

### Choosing the image

RunAbove provides many images from which you can create your instance. You can even upload your own. 

To see what's in store, issue

    nova image-list

which will return a list of images with their unique IDs

    +--------------------------------------+------------------------+--------+--------+
    | ID                                   | Name                   | Status | Server |
    +--------------------------------------+------------------------+--------+--------+
    | b2995d24-7c0b-437e-a2a6-5171181b2645 | CentOS 6               | ACTIVE |        |
    | 9823f3b2-21b7-4591-8179-cf9be4d0a0a8 | CentOS 7               | ACTIVE |        |
    | 83872985-9101-4051-be83-22c30cc0fe89 | Debian 7               | ACTIVE |        |
    | afa4dd1b-ff18-4214-9c43-44becd9026c6 | Dokku                  | ACTIVE |        |
    | 3c451df3-356f-4f98-90a1-3e92f392f177 | Fedora 19              | ACTIVE |        |
    | c640843e-412e-46bb-9687-94a8bf95ac0e | Fedora 19 Power 8      | ACTIVE |        |
    | 371ff458-bf67-47b3-81ff-6d2a393b243a | Fedora 20              | ACTIVE |        |
    | b2ffb4d6-4e49-4243-b418-410493e165c2 | Ubuntu 12.04           | ACTIVE |        |
    | d0e8d240-0bfa-4415-88d2-9c5ee77c7e9f | Ubuntu 14.04           | ACTIVE |        |
    | bf8927ce-5dda-4739-b09d-5604de5a8e06 | Ubuntu 14.04 Power 8   | ACTIVE |        |
    | 476570e2-ad54-4072-b74f-9391bee1a4a3 | Ubuntu 14.10           | ACTIVE |        |
    | 3f7ade4c-ed24-4128-816c-8727c6c95957 | Windows Server 2012 R2 | ACTIVE |        |
    +--------------------------------------+------------------------+--------+--------+

For example, regular Ubuntu 14.04 is d0e8d240-0bfa-4415-88d2-9c5ee77c7e9f.


Booting a new instance
----------------------

Now that we have configured the ssh keypair, chose a flavor and image, we can boot a new instance. The command is a bit long but straightforward

    nova boot --flavor ra.intel.sb.m --image d0e8d240-0bfa-4415-88d2-9c5ee77c7e9f --key-name demokey --security-groups default demoinstance

The important part is the `boot` subcommand, and the the name of the instance at the end (demoinstance). Not to complicate things, we will run this server in the default security group. 

If successful, it will return a table with basic information about the instance, including adminPass. It will not tell us the IP address. For that we need to wait a minute and issue

    nova list

which gives all the information about running servers

    +--------------------------------------+--------------+--------+------------+-------------+----------------------+
    | ID                                   | Name         | Status | Task State | Power State | Networks             |
    +--------------------------------------+--------------+--------+------------+-------------+----------------------+
    | a6005b76-e4a1-4b00-b0b2-cd877aaff5d8 | demoinstance | ACTIVE | -          | Running     | Ext-Net=92.222.69.64 |
    +--------------------------------------+--------------+--------+------------+-------------+----------------------+

most prominently, the external IP. 

With the ssh key and the IP address, we can now log in

    ssh -i ~/.ssh/runabove admin@92.222.69.64

Username was chosen by the creator of the image. Ubuntu by default does not allow direct root login, `sudo su` for root. 

### cloud-init

Once you're logged in, you may of course configure the server as you wish. It is sometimes useful though to have the server pre-configured. One way to do that would be to create and upload your own image. That is rather labor-intensive. 

The other, easier way is to use cloud-init. This allows you to pass certain instructions when creating the instance. Details are a bit beyond the scope of this howto, and [cloud-init is quite well documented](http://cloudinit.readthedocs.org/), but let's just quickly boot a new instance with a very simple user script passed to it. 

First, create a file with the following contents

    #cloud-config
    write_files:
      - path: /root/reminder  
        content: |
          Learn more about cloud-init some time.

Second, issue a slightly modified boot command 

    nova boot --flavor ra.intel.sb.m --image d0e8d240-0bfa-4415-88d2-9c5ee77c7e9f --key-name demokey --security-groups default --user-data ./cloud-init-reminder reminderinstance

where `./cloud-init-reminder` is the path to the file created in the first step. 

Once the server comes up, you can log in and see that the file was indeed written

    root@reminderinstance:~# cat /root/reminder 
    Learn more about cloud-init some time.

Note, cloud-init is a feature of the particular image (guest operating system), not RunAbove. 

Deleting an instance
--------------------

When you don't need your instance anymore, simply delete it. 

    nova delete demoinstance

It will be removed shortly. 

    Request to delete server demoinstance has been accepted.

That's it. 
