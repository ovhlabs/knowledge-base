---
layout: post
title: "How to configure Owncloud 7 with Openstack Swift?"
categories: Object-Storage
lang: en
author: ArnaudJost
---

Owncloud is a software application which allows you to host, sync and share files, hosted on your own dedicated or virtual server.

The past few releases of OwnCloud allo users to host files on external storage, using a module. For example, you can use FTP or Openstack swift as a second backend storage.

With Owncloud 7, you can now use Openstack swift as [u]main storage[/u], and benefit with fast and secure storage from RunAbove without local storage problem (drive failure..).


# Prerequistes :

 * Working Owncloud instance, freshly installed on your server (you can donwload and find help about Owncloud here : [https://owncloud.org/install/](https://owncloud.org/install/)
 * Your tenant name is your project number. You can found it inside expert [control panel](https://cloud.runabove.com/horizon/).

# Configure Owncloud 7 to use Runabove storage:

You have to manually configure Openstack storage in Owncloud's config file. You'll find it in Owncloud's http storage directory: config/config.php.

Edit this file, and add this new configuration element in $CONFIG array :

```php
'objectstore' => array(
    'class' => 'OC\\Files\\ObjectStore\\Swift',
    'arguments' => array(
        'username' => 'myusername@mymail.com', // Runabove username
        'password' => 'mypassword', // Runabove password
        'container' => 'owncloud', // Container name. Ownclound store files using it's own metadata,
        // so, keep a container only for Owncloud use.
        'autocreate' => true, // Create the container if it does not exist. default is false
        'region' => 'SBG-1', // Region where you want to store files
        'url' => 'https://auth.Runabove.io/v2.0', // Runabove identity endpoint
        'tenantName' => '1234567', // project name
        'serviceName' => 'swift', // service name, should be 'swift' on Runabove[
    ),
)
```

Then, just reload Owncloud on your favorite browser. Every users now store files on Runabove instead of using local storage. Please note that local storage is not longer used, so, please use a fresh install of Owncloud 7 or backup your files before.
