---
layout: post
title: "Configure a private network with NAT"
categories: instances
lang: en
author: NicolasLM
---

A common network layout is to have a gateway handling all the traffic between 
the inside of a network and the outside. This guide will show the simple steps 
on how to reproduce this layout on RunAbove.

![Layout NAT](/kb/images/2014-11-07-private-network-nat/layout.png)

Create a new local network
--------------------------

Go to the Expert dashboard (Horizon) and in the `Network Topology` tab click on 
`Create Network`.

### Network

Give a name to your network (ie. Local) and set the admin state.

![Network](/kb/images/2014-11-07-private-network-nat/network-step1.png)

### Subnet

Create a subnet with a name (ie. Local), select and IP network. Here we use 
`192.168.0.0/24` in IPv4. Finally activate a gateway at `192.168.0.4`.

![Subnet](/kb/images/2014-11-07-private-network-nat/network-step2.png)

### Subnet Detail

Enable DHCP and create the network.

![Sub detail](/kb/images/2014-11-07-private-network-nat/network-step3.png)

Launch and configure the gateway
--------------------------------

Create the gateway as you wish and set the external network as first interface 
and the local one as the second interface.

![NICs](/kb/images/2014-11-07-private-network-nat/network-step4.png)

Connect to your instance:

    ssh admin@<Public IP of your gateway>

Login as root and configure network and NAT routing:

    sudo su -
    ifconfig eth1 192.168.0.4/24
    echo 1 > /proc/sys/net/ipv4/ip_forward
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

Launch your internal instances
------------------------------

Create your internal instances, they should have only one private IP address.  
Once you have an address go to your gateway and add a rule to forward the port 
to be able to connect with SSH. For example if your internal instance has the 
address `192.168.0.7` you can create a rule to contact it from the port 2201 of 
your gateway with:

    iptables -t nat -A PREROUTING -p tcp --dport 2201 -j DNAT --to-destination 
    192.168.0.7:22

Finally open the port 2201 in the security group of your gateway. To do that go 
to `Access & Security` and add a rule to your security group to allow incoming 
TCP traffic to port 2201.

You can now connect to your internal instance with:

    ssh admin@<Public IP of gateway> -p 2201

