---
layout: post
title:  "How to create a MySQL Managed Stack"
categories: Labs
author: popawu
lang: en
---

In this guide you will learn how to subscribe to the Managed Stacks lab and create your MySQL cluster.

Requirements
============

 * MySQL client ([http://dev.mysql.com/doc/refman/5.7/en/programs-client.html](http://dev.mysql.com/doc/refman/5.7/en/programs-client.html)

Activate Managed Stacks lab
===========================

Go to [Runabove](https://www.runabove.com) > Labs > Discover Managed Stacks > Start Now

![Start Lab](/kb/images/2015-12-10-create-mysql-managed-stack/start.png)

Either sign up (create new account) or sign in (use existing account)

![Sign up](/kb/images/2015-12-10-create-mysql-managed-stack/signup.png)

To activate Managed Stacks Lab, click on 'More labs...' and 'Activate'

![Activate](/kb/images/2015-12-10-create-mysql-managed-stack/activate.png)

Create MySQL Managed Stack
============================

To create a new stack, click on 'Managed stacks' in the left menu, and then on '+ New stack'.

![Managed Stacks](/kb/images/2015-12-10-create-mysql-managed-stack/menu_managed.png)

![New Stack](/kb/images/2015-12-10-create-mysql-managed-stack/new_stack.png)

You will receive an email confirming the creation of your new stack.

Start using your Create MySQL Managed Stack
===========================================

Wait for your to stack to be in active status. The stack delivery last about 10 minutes.

![status_active](/kb/images/2015-12-10-create-mysql-managed-stack/status_active.png)

Once your stack is active, you will receive a second email containing all information about it :
* IP/Hostname of the first node of your cluster
* IP/Hostname of the second node of your cluster
* root and user account of your cluster

You can test your access to the nodes with this command :
```bash
user@desk:~$ mysql -u{username} -p{password} -h{node IP or hostname}
```

You can get the details of your stack by clicking on the application name :

![stack_details](/kb/images/2015-12-10-create-mysql-managed-stack/stack_details.png)

You will see details of your cluster and 3 monitoring probes for each node.

![cluster_status](/kb/images/2015-12-10-create-mysql-managed-stack/cluster_status.png)

Delete your Managed Stacks MySQL cluster
========================================

Click on 'Managed stacks' in the left menu, and then on the garbage in the action column :

![delete_stack1](/kb/images/2015-12-10-create-mysql-managed-stack/delete_stack1.png)

Confirm your action :

![delete_stack2](/kb/images/2015-12-10-create-mysql-managed-stack/delete_stack2.png)
