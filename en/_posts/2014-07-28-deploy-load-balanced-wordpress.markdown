---
layout: post
title: "How to deploy load balanced wordpress application using Juju charms"
categories: Instances
lang: en
author: bartekzurawski
---
WordPress is web software you can use to create a beautiful website or blog.This guide will show how quick and efficiently it is to deploy your WordPress application with an OpenStack cloud, like RunAbove and Juju

Requirements:
-------------

First you need Juju environment. If you don't have it, you can quickly [create it](/kb/en/instances/how-to-install-an-orchestration-tool-juju.html) using guide. Next you need to do is download charms. You can do this by cloning git repo using this: `git clone git@github.com:bartekzurawski/charm.git`

Wordpress instances:
--------------------

Using ssh go to the machine where you have installed juju. Using this command in command line: `juju deploy --repository=charms/ local:precise/wordpress` you can launch instance with WordPress.

![Wordpress charm](/kb/images/2014-07-28-deploy-load-balanced-wordpress/wordpress.png)

MySQL instance:
---------------

WordPress use MySQL to store data about webpages, users, configuration etc.
Just deploy MySQL instance using this: `juju deploy --repository=charms/ local:precise/mysql` . When your database is deployed it's time to make ralation between the application and database. It's simple to do that, you need to click on the charm and "Build Relation".

![Wordpress MySQL relation](/kb/images/2014-07-28-deploy-load-balanced-wordpress/word-mysql-rel.png)


NFS instance:
-------------

If you want to use load balancing on your WordPress application, for sure you need more than one instance with WordPress. But to make it work, each WordPress instace should have the same content in `wp-content/` directory. To do that, you need NFS instance. Just deploy it using this: `juju deploy --repository=charms/ local:precise/nfs` . After NFS is deployed build relation between NFS and WordPress service.


![NFS Wordpress relation](/kb/images/2014-07-28-deploy-load-balanced-wordpress/nfs-word-relation.png)


Load Balancer:
--------------

Last step is to deploy the load balancer. The best option for this cluster is use "haproxy". Deploy it: `juju deploy --repository=charms/ local:precise/haproxy` . Next you need to build relation between WordPress and haproxy. Finally you need to change haproxy configuration by modifying "services" parameter. To do that, you need to click on haproxy charm, switch tab to service settings, find services parameter and change it using this configuration:

     - service_name: haproxy_service
       service_host: "0.0.0.0"
       service_port: 80
       service_options: [balance roundrobin, cookie SRVNAME insert]
       server_options: cookie S{i} check

![Cluster structure](/kb/images/2014-07-28-deploy-load-balanced-wordpress/structure.png)

On the above screenshot you can see whole structure of the infrastructure with HAproxy as load balancer, WordPress as application, MySQL as database and NFS as file server.

Test it!
--------

Now you can test that setup, how it works. Get the IP of your load balancer by clicking on the haproxy charm, then on "running unit" and finally on the name of the instance. Connect to this address using your browser and you will see WordPress instalation page.

You can add more WordPress units if you want. It's very simple, just click on WordPress charm, and change number of units.

As you can see, every WordPress instance have the same content. This is due to the fact that relation between WordWress and MySQL instance are working (eaach WordPress instance use the same database) also relation between WordPress and NFS are working (each WordPress instance is connected to the same NFS instance)
