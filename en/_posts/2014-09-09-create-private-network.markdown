---
layout: post
title: "How to create Private Network with Internet access?"
categories: Instances
lang: en
author: bartekzurawski
---

In RunAbove, it is possible to create local networks. This is a good way to
protect your backend infrastructure or if you want to outsource your servers on
RunAbove. In this guide we will create a local network with access to the
Internet. The distribution used in this guide is Ubuntu 12.04.

This schema presents the structure of the network:

![Network schema](/kb/images/2014-09-09-create-local-network/schema.png)

In this example we will use 192.168.0.0/24 as the network, and 192.168.0.2 as the gateway.


1. [Create routing instance](#routing_instance)
2. [Create local network](#local_net)
    1. [Create local network using Horizon](#local_net_hor)<br />
        1.1 [Network name](#create_net)<br />
        1.2 [Subnet](#sub)<br />
        1.3 [Subnet details](#sub_details)
    2. [Create local network using command line and API](#local_net_api)
3. [Configure routing instance](#config_routing_instance)
4. [Adding more virtual machine to local network](#add_vm_net)
5. [Test your network](#test_net)


<h2 id="routing_instance">1. Create routing instance</h2>

To have access to the Internet from the local network you need an instance that
will act as a gateway for this network. This router will be an instance with
public and private IP addresses, connected to both networks. [How to launch an
instance](https://community.runabove.com/kb/en/instances/how-to-create-a-compute-instance-in-few-seconds.html).

<h2 id="local_net">2. Create local network</h2>

To create a local network you have two options:
* Using the expert mode in Horizon (OpenStack dashboard)
* Using the command line tools and the API

<h3 id="local_net_hor">1. Create local network using Horizon</h3>
<h3 id="create_net">1.1 Network name</h3>
To create the local network using Horizon you need to login to your RunAbove
account. In expert mode click on __Networks__ from the menu, there you can see
your networks.

It's time to create your first dedicated network. Click on __Create Network__
button, and specify your __network name__, enter it and click next.

![Net Name](/kb/images/2014-09-09-create-local-network/network_name.png)


<h3 id="sub">1.2 Subnet</h3>
Next you need to specify the subnet for your network. To do that, you need to
specify a few parameters:
-   __Subnet Name__, an optional name for your subnet
-   __Network Address__, contains the size of your network and must be
    specified in CIDR format (e.g 192.168.0.0/24).
-   __IP Version__ must be set to IPv4 because RunAbove does not support IPv6
    yet.
-   For local networks with access to the internet you need to specify a
    __Gateway address__. It is the address that each virtual machine from the
    local network will use to connect to the Internet. For this example we use
    192.168.0.2 as the gateway address.

![Subnet](/kb/images/2014-09-09-create-local-network/subnet.png)

<h3 id="sub_details">1.3 Subnet details</h3>
In the last tab, you need to specify subnet details:

-   Choose if you want a __DHCP server__, by default this option is checked, if
    you uncheck it your local network will not have a DHCP server, so you will
    have to manually configure interfaces on your virtual machine. If there is
    no DHCP there will be no meta-data server, thus the instance can take more
    time to boot.
-   __Allocation Pools__ specifies which IP address from your network will be
    used by virtual machines, if you leave this empty, by default all IP
    addresses will be used.
-   __DNS Name Servers__, a different name server to use for the subnet.
-   __Host Routes__, sets static routing for particular IP addresses.

After providing information about subnet, just click __Create__.

![Subnet
details](/kb/images/2014-09-09-create-local-network/subnet_details.png)

After that your local network is created and you will be able to see your new
local network in Horizon.

![Net list](/kb/images/2014-09-09-create-local-network/net_list.png)


<h3 id="local_net_api">2. Create local network using command line and API</h3>

To start using command line tools and API to create local networks, you need to
[download the openrc file and install neutron
client](/kb/en/instances/use-openstack-services.html). Only two commands are
needed to create a local network:

First you need to create a network. To do that use __neutron net-create__:

    neutron net-create my-local-network

After performing this command you will be able to get information about the
network that you created. Next you need to create a subnet for your network :

    neutron subnet-create my-local-network 192.168.0.0/24 --enable-dhcp --no-gateway

<h2 id="config_routing_instance">3. Configure routing instance</h2>

You have created a virtual machine to be router and local network. Now you must
configure the router to be gateway for the local network. Log into the virtual
machine using ssh. First you must install some packages:

    sudo apt-get update && sudo apt-get install python-pip
    sudo pip install python-novaclient
    sudo pip install python-neutronclient

Before you add an interface, you need to load kernel modules that allow add
network interfaces without switching off the machine:

    sudo modprobe acpiphp
    sudo modprobe pci_hotplug

To use nova and neutron client you need to [load OpenStack RC
File](/kb/en/instances/use-openstack-services.html).

Now you need to attach a new interface to your router. To do that use neutron
and nova client. First list our network list:

```
neutron net-list

+--------------------------------------+-----------+-----------------------------------------------------+
| id                                   | name      | subnets                                             |
+--------------------------------------+-----------+-----------------------------------------------------+
| f5cc56db-db25-4488-8371-c507951b2631 | Ext-Net   | 2c56a226-e78b-4268-b3d4-96e61e4fc0fe 92.222.64.0/19 |
+--------------------------------------+-----------+-----------------------------------------------------+

```

Result of this command is a list of available networks for your tenant. Next we
need to list virtual machines:

```
nova list

+--------------------------------------+---------+--------+------------+-------------+-----------------------+
| ID                                   | Name    | Status | Task State | Power State | Networks              |
+--------------------------------------+---------+--------+------------+-------------+-----------------------+
| 924fa247-fb7d-4697-84ab-59269aa9c869 | gateway | ACTIVE | -          | Running     | Ext-Net=92.222.64.130 |
+--------------------------------------+---------+--------+------------+-------------+-----------------------+
```

This command shows all virtual machines. Now when you have all the information
you need it is time to attach a new interface:

```
nova interface-attach --net-id <your network id> <your machine id>
```

If your local network has a gateway address, you must not use dhclient. Check
if everything is okay with:

```
nova list

+--------------------------------------+---------+--------+------------+-------------+----------------------------------------------+
| ID                                   | Name    | Status | Task State | Power State | Networks                                     |
+--------------------------------------+---------+--------+------------+-------------+----------------------------------------------+
| 924fa247-fb7d-4697-84ab-59269aa9c869 | gateway | ACTIVE | -          | Running     | Ext-Net=92.222.64.130; Local-Net=192.168.0.3 |
+--------------------------------------+---------+--------+------------+-------------+----------------------------------------------+
```

As you can see, the virtual machine that is router for your network now has two
IP address one is public and the other one is private. Now you must configure
the interface on your virtual machine.

Check that your virtual machine has a new interface:

    ip addr list

This command shows two eth interfaces. First eth0 is configured to
use public IP address. Then eth1 is the new interface, it needs to
be configured:

    sudo ip addr add 192.168.0.2/24 dev eth1
    sudo ip link set eth1 up

This virtual machine will be gateway for your network. That iss why eth1 must
be configured using the gateway IP address. When we have configured eth1 it's
time to add NAT rules to iptables:

    sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

That's it. Your network is working, and it has access to the Internet.

<h2 id="add_vm_net">4. Adding more virtual machine to local network</h2>

Local network is working and has access to the Internet, now you can add more
virtual machine to your network. Go to Horizon in expert mode, then go to
instances and click __Launch Instance__. Select your distribution and complete
the configuration like you want. Under the networking tab add a network to your
virtual machine. Add your local network and click  __Launch__.

You can add more virtual machine the same way.

<h2 id="test_net">5. Test your network</h2>

To test your network you need to login to the virtual machine with private
address, but you cannot do it directly from the outside because this virtual
machine does not have a public address.

There are two ways to login to a virtual machine on a private network:

-   First way is to login using SSH to the virtual machine that is gateway for
    the private network and then you can SSH to each virtual machine.
-   Second way is to use the VNC console available from both RunAbove managers.

When you have a shell in an instance connected to the private network, ping an
external IP address. If it pings back to you, that means the virtual machine on
your local network has access to the Internet.
