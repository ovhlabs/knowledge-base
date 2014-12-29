---
layout: post
title: "Protect your instances with RunAbove firewall"
categories: instances
lang: en
author: NicolasLM
---

RunAbove encourages you to manage the security of your instances by integrating 
an easy to use firewall in front of all your servers. This guide shows the 
possibilities it offers as well as how to manage it.

Security groups
---------------

When you create your RunAbove account we enable for you a security group called 
`default`. All the instances you launch go into this security group by default.

You can add an unlimited numbers of rules to this security group. A rule allows 
one kind of traffic to reach or go out of your instance.

Default rules
-------------

The default security group is populated with four main rules. They allow:

* All outgoing traffic
* To access your instance by SSH on port 22
* To access a web server over HTTP on port 80
* To access a web server over HTTPS on port 443

All other incoming traffic is denied to protect your instance.

Adding a rule
-------------

You can easily add a rule to allow another kind of traffic. Go to [OpenStack 
Horizon](https://cloud.runabove.com/horizon/project/access_and_security/), in 
"Access & Security" you will see your security groups. By clicking on "Edit 
rules" you will be able to list the rules that currently apply.

Click on "Add Rule" and a form will ask you a few information about the traffic 
you want to allow. Some rules for common services like DNS, RDP or IMAP are 
already shipped.

![Add security rule](/kb/images/2014-12-29-security-groups/add-rule.png)

If your service is not in the list select "Custom TCP Rule" and the direction 
"Ingress". Then specify if you only want to open one port or a port range.

The "Remote" field has two properties:

* CIRD, a network form which the traffic will be allowed. `0.0.0.0/0` means 
everywhere in CIDR notation. You can restrict to one IP with for example 
`83.222.45.67/32`.
* Security group, a security group from which all instances in this group will 
be able to access the service.

Going further with security groups
----------------------------------

You can create other security groups for each kind of servers you have. Imagine 
that you have a cluster of web servers and a database server.

You can create two security groups (ie. web and database). They will both have 
different rules:

* Web, allows traffic on port 80 from everywhere
* Database, allows traffic on port 3306 from the security group web

