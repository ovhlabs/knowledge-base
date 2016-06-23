---
layout: post
title:  "How to deploy a Wordpress with Marathon"
categories: docker
author: brouberol
lang: en
---

In this tutorial, we'll see how to deploy a Wordpress CMS, along with a MySQL database and a PhpMyAdmin management web interface. As the Docker PaaS does not yet support stateful containers, we'll order the database from the [PaaS DB MySQL](https://www.runabove.com/PaaSDBMySQL.xml).

## First and foremost

This tutorial assumes you already have a [PaaS Docker](https://www.runabove.com/docker-with-mesos-marathon.xml) and [PaaS MySQL](https://www.runabove.com/PaaSDBMySQL.xml) account.

If you haven't already read our [introduction to Docker with Mesos and Marathon](/kb/en/docker/introduction-to-docker-with-mesos-marathon.html), you should probably read it before diving in.

## Installing the MySQL database

For your MySQL instance to be fully operational, you need to complete the following steps:

* create a database (eg: wordpress)
* create a user account protected by a password, with read-write rights on the previously created database

You can refer to the [PaaS DB tutorial](https://www.ovh.co.uk/g2216.getting_started_with_the_mysql_and_postgresql_paas_db) for more details.

## Restrict access to the database to your container IPs

In order to make your database accessible from your containers only, you have to specify which IPs are authorised to connect to your instance. You can get your containers IP using our API. For example

```bash
$ curl -u "<username>:<password>" https://lb.<cluster>.containers.ovh.net/api/v1/slaves/ip
{
  "objects": [
    "165.118.227.114",
    "165.118.231.44"
  ]
}
```
**Note**: you can derive the value of both `username` and `cluster` from the address of your marathon web ui. For example, if your UI URL is `http://lb.sbg-1.containers.ovh.net/marathon/docker-abcdef-1/`, the value of `cluster` and `username` are respectively `sbg-1` and `docker-abcdef-1`. The password is the one you use to access the Marathon web UI.

![whitelist](/kb/images/2016-06-21-deploying-wordpress-on-marathon/whitelist.png)

## Deploy the PhpMyAdmin manager

We'll use the [https://hub.docker.com/r/phpmyadmin/phpmyadmin/](phpmyadmin/phpmyadmin) image, hosted on the Docker Hub.

You'll need to configure the PhpMyAdmin so that it exposes the TCP container port 80 to the load balancer.

![pma1](/kb/images/2016-06-21-deploying-wordpress-on-marathon/phpmyadmin.png)

You then need to set environment variables, to define the host and port of your MySQL database:

* `PMA_HOSTS`: the value listed in the [sunrise manager](https://www.ovh.com/manager/sunrise), section "Paas Database", in the project instance details page, under the name "Access URL"
* `PMA_PORT`: the value listed in the [sunrise manager](https://www.ovh.com/manager/sunrise), section "Paas Database", in the project instance details page, under the name "Service port"

Then, add some labels to [redirect your logs to the PaaS logs](/kb/en/docker/marathon-container-logs.html), and [configure the http vhost](/kb/en/docker/marathon-load-balancer.html) of your app.

Finally, configure an [HTTP health-check](/kb/en/docker/marathon-health-checks.html) on the path `/`.

![pma2](/kb/images/2016-06-21-deploying-wordpress-on-marathon/phpmyadmin2.png)

Once your app is displayed as healthy in your marathon web interface, you should be able to access the PhpMyAdmin welcome page by requesting the configured vhost. In the previous screenshot, we set it to `pma.<username>.lb.<cluster>.containers.ovh.net`.

![pma3](/kb/images/2016-06-21-deploying-wordpress-on-marathon/phpmyadmin-welcome.png)

## Deploy the Wordpress container

We'll use the official [wordpress image](https://hub.docker.com/_/wordpress/), hosted on the Docker Hub.

Similarly to PhpMyAdmin, we need to:

* expose the TCP container port 80 on the LB
* configure the container environment to define the DB host, port and credentials
* add the [Paas Logs label](/kb/en/docker/marathon-container-logs.html) to be able to see the container logs in the PaaS Logs Graylog
* configure the container vhost
* configure the container HTTP health checks

![wp1](/kb/images/2016-06-21-deploying-wordpress-on-marathon/wordpress.png)
![wp2](/kb/images/2016-06-21-deploying-wordpress-on-marathon/wordpress2.png)

Once again, you should be able to reach the Wordpress welcome page by requesting the configured vhost.

![wp-welcome](/kb/images/2016-06-21-deploying-wordpress-on-marathon/wordpress-welcome.png)

# Conclusion

You now have 3 stateless Wordpress containers, communicating with a MySQL database, which you can manage from a web interface.

To customize your Wordpress (ie: add themes, plugins, etc), you'll need to add them to the image at build time. When we support stateful containers, you'll be able to tweak your instance and have any changes persisted, even after a container redeploy.