---
layout: post
title: "How to use OpenStack command line tools?"
categories: Instances
author: bartekzurawski
---

OpenStack is a cloud computing software built with several modules (Nova,
Swift, Neutron...) interacting with each others. In this guide we will focus on
how to use the command line clients of these modules.

OpenRC file
-----------

To use any command line client, you need to load the `openrc` file. This file
contains special environments variables which are used by command line clients
to authenticate to the server where the service is running.

Let's start! To begin, go to the [expert control
panel](https://cloud.runabove.com/horizon/project/access_and_security/), go to
__Access & Security__ and switch tab to __API Access__. Finally __Download
OpenStack RC File__ will allow you to retrieve the credentials needed to
interact with OpenStack services.

The file that you downloaded, is a shell script. To load it, you can use the
source command of your shell:

    source <openrc_file>

For security reasons your password is not stored in this file, so you will be
prompted to enter your RunAbove password.

You can now check that the environment is correctly loaded, perform:

    env | grep OS_

As you can see your environment has been loaded correctly. Remind to reload
this file each time you start a new shell.

Command line clients
--------------------

### Python pip

To use command line clients, you need to install them first. The most
convenient way to do that is with `pip`, the standard tool for installing
Python packages. On any Debian like operating system you can install `pip`
with:

    sudo apt-get install python-pip

If you are familiar with Python Virtualenv, you can then create a new
virtualenv and install the OpenStack clients in it, but this is not mandatory.

### Installing OpenStack clients

OpenStack provides a [list of
clients](https://wiki.openstack.org/wiki/OpenStackClients) you can install.
Just enter the command bellow with the name of the client, for example:

    sudo pip install python-novaclient

### Using the clients

In RunAbove there are two region, `BHS-1` and `SBG-1`. If you want get data
from only one of them, you need to add the parameter `--os-region <region>` for
example:

    nova --os-region BHS-1 list
    glance --os-region SBG-1 image-list

It is also possible to define the region in an environment variable, just do:

    export OS_REGION=BHS-1

OpenStack clients have a useful help accessible with `help`, for example for
nova:

    nova help

You can get the detailed usage of a subcommand with:

    nova help boot

You can also check the [online
documentation](http://docs.openstack.org/cli-reference/content/) of all
OpenStack clients.
