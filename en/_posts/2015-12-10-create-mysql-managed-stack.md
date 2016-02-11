---
layout: post
title:  "How to create a MySQL Managed Stack"
categories: ManagedStacks
author: popawu
lang: en
---

Deploy your database stack, we take care of it !

In this guide you will learn how to subscribe to the Managed Stacks lab and create your MySQL cluster.

Now available with your cluster :

- MySQL High availability : 2 MySQL nodes with SSL master/master replication
- Real-time resources visualization : Monitoring probes to check MySQL status, server load and disk space on each node
- Managed stack : 24/7 hardware/software monitoring and system security management

New features will be added soon and this guide will be updated accordingly.
Enjoy !


Requirements
============

 * Any [MySQL client][programs-client]

Activate Managed Stacks lab
===========================

Go to [Runabove][runabove] > Labs > Discover Managed Stacks > Start Now

![Start Lab][]

Either sign up (create new account) or sign in (use existing account)

![Sign up][]

To activate Managed Stacks Lab, click on 'More labs...' and 'Activate'

![Activate][]

Create MySQL Managed Stack
============================

To create a new stack, click on 'Managed stacks' in the left menu, and then on '+ New stack'.

![Managed Stacks][]

![New Stack][]

You will receive an email confirming the creation of your new stack.

Start using your Create MySQL Managed Stack
===========================================

Wait for your to stack to be in active status. The stack delivery last about 10 minutes.

![status_active][]

Once your stack is active, you will receive a second email containing all information about it :
* IP/Hostname of the first node of your cluster
* IP/Hostname of the second node of your cluster
* root and user account of your cluster

You can test your access to the nodes with this command :
```bash
user@desk:~$ mysql -u{username} -p{password} -h{node IP or hostname}
```

You can get the details of your stack by clicking on the application name :

![stack_details][]

You will see details of your cluster and 3 monitoring probes for each node.

![cluster_status][]

Delete your Managed Stacks MySQL cluster
========================================

Click on 'Managed stacks' in the left menu, and then on the garbage in the action column :

![delete_stack1][]

Confirm your action :

![delete_stack2][]

[programs-client]: http://dev.mysql.com/doc/refman/5.7/en/programs-client.html
[runabove]:https://www.runabove.com/index.xml
[Start Lab]: https://cdn.rawgit.com/runabove/knowledge-base/master/images/2015-12-10-create-mysql-managed-stack/start.png
[Sign up]: https://cdn.rawgit.com/runabove/knowledge-base/master/images/2015-12-10-create-mysql-managed-stack/signup.png
[Activate]: https://cdn.rawgit.com/runabove/knowledge-base/master/images/2015-12-10-create-mysql-managed-stack/activate.png
[Managed Stacks]: https://cdn.rawgit.com/runabove/knowledge-base/master/images/2015-12-10-create-mysql-managed-stack/menu_managed.png
[New Stack]: https://cdn.rawgit.com/runabove/knowledge-base/master/images/2015-12-10-create-mysql-managed-stack/new_stack.png
[status_active]: https://cdn.rawgit.com/runabove/knowledge-base/master/images/2015-12-10-create-mysql-managed-stack/status_active.png
[stack_details]: https://cdn.rawgit.com/runabove/knowledge-base/master/images/2015-12-10-create-mysql-managed-stack/stack_details.png
[cluster_status]: https://cdn.rawgit.com/runabove/knowledge-base/master/images/2015-12-10-create-mysql-managed-stack/cluster_status.png
[delete_stack1]: https://cdn.rawgit.com/runabove/knowledge-base/master/images/2015-12-10-create-mysql-managed-stack/delete_stack1.png
[delete_stack2]: https://cdn.rawgit.com/runabove/knowledge-base/master/images/2015-12-10-create-mysql-managed-stack/delete_stack2.png
