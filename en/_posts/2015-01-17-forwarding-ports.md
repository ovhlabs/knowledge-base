---
layout: post
title:  "Forwarding ports to your instance"
categories: Instances
author: Tobiqas
lang: en
---
This guide will show you how to open up ports to your instance.

1. Creating a new security group
===

Open up OpenStack Horizon. On the left, click *Access & Security*. Select the tab *Security Groups*, and click *Create Security Group*. Give it a name (the name of your instance for example), and a description. As soon as the group pops up in the list, click Edit Rules. You'll see something like this:

![](http://i.imgur.com/DSNXSMX.png)

These rules allow all sorts of outgoing (Egress) IPv6 and IPv4 traffic to any remote address. What you'll want to do next, is click the *Add Rule* button. Now you can configure a new rule.

This picture shows how to set up a rule that opens port 8080.

![](http://i.imgur.com/bDtWLye.png)

Do you require a port range to be opened?
Select *Port Range* in the *Open Port* dropdown menu.

Want to forward UDP traffic? Select *Custom UDP Rule* as rule template.

You many also select one of the other rule templates if the desired protocol is in that list.

Ultimately, click *Add* to create the new rule.

2. Applying new settings
===

Click *Instances* on the left. You'll see a list of your instances. Find the instance you want to apply the new set of rules to, and click More -> Edit Security Groups.

![](http://i.imgur.com/Hd5Ev6U.png)

Go to the tab *Security Groups* in the window that pops up. It will probably look like this:

![](http://i.imgur.com/em1uUJq.png)

Since we're only adding rules, we can just add our newly created group to the instance's *Security Groups*. Do this by clicking the + button of the group (the one on the left).

If you're not interested in the default rules (port 80, 443 and 22 are forwarded by default), you can remove the *default* *Security Group* from the list on the right by clicking the - button.

----------

If you wish to change these rules for all of your instances, and save yourself the hassle of creating a new *Security Group*, just add your rules to the *default* group and they'll be applied to all instances (unless you've removed the *default* group an instance).

3. Forwarding ports on the server
===

## Linux ##
In Linux, ports don't always have to be forwarded in the OS. But if they do, you can use the following command to open up a port:
```
iptables -A INPUT -p <protocol> --dport <port> -j ACCEPT
```

<protocol> can be tcp, udp or icmp. <port> can be a number within range 1-65535.

## Windows ##
Go to the following component of the *Control Panel*:

![](http://i.imgur.com/eUAD2no.png)

Click *Advanced Settings* on the left. A window will pop up.

On the left of that window, select Inbound Rules. On the right, you will see some actions to choose from. Click *New Rule...*.

Set up the new rule in accordance to these values:

Rule Type: Port
Action: Allow the connection
Profile: make sure *Public* is checked