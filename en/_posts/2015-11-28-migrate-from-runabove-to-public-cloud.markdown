---
layout: post
title:  "Migrate from RunAbove to Public Cloud"
categories: Instances 
author: VincentCasse
lang: en
---
As you can see on the website, [RunAbove](https://www.runabove.com/index.xml) is now the brand representing all of OVH's innovations in various *Lab* forms such as [Desktop as a service](https://www.runabove.com/deskaas.xml) and of course everything to do with [IoT](https://www.runabove.com/iot-paas-timeseries.xml).

Labs such as [Object Storage](https://www.runabove.com/cloud-storage.xml), [instances ](https://www.runabove.com/cloud-instance.xml) and [additionnal volumes](https://www.runabove.com/cloud-disks.xml) are now closed. However, you can still find them on the [OVH Public Cloud](https://www.ovh.com/us/cloud/) in a new and improved version. 

# Migrate to OVH Public Cloud

Since RunAbove is now in its closing phase, it is necessary to migrate your activities based on instances, additional volumes and object storage as soon as possible. Several guides have been created in order to assist you with this migration.

## Requirements

 * [Prepare the environment for using the OpenStack API](https://community.runabove.com/kb/en/instances/use-openstack-command-line-tools.html)

## Modifying the OpenStack environment variables for RunAbove

First, you need to retrieve the RC file containing all the information necessary for the use of the OpenStack APIs:

 * Login to your RunAbove account
 * Click on your name in the upper right corner and select OpenStack Horizon
![](/kb/images/2015-11-28-migrate-from-runabove-to-public-cloud/runabove_menu.jpg)
 * Select the region on the left-hand side;
 * Go to the Access & Security menu and then to the API Access tab; 
![](/kb/images/2015-11-28-migrate-from-runabove-to-public-cloud/horizon_security_panel.jpg)
 * Click on Download OpenStack RC File; 
 * Load the OpenStack environment variables for RunAbove by using the RC file;

```bash
root@serveur:~$ source RunAbove_OpenRC.sh
```

## Migration

There are guides explaining how to transfer instance backups and additional volumes from one datacenter to another.

Since they're compatible with RunAbove, you can use them as a support tool for the migration your project:

 * **Migrating instances:** [Tranfer instance backup from one datacentre to another]()
 * **Migrating additional volumes:** [Transfer volume backup from one datacentre to another]()
 * **Migrating object storage:** When it comes to migrating an Object Storage, it is possible to download and send your data to your new project. It is also possible to synchronize two containers between each other [Synchronise object containers](https://community.runabove.com/kb/en/object-storage/how-to-sync-runabove-object-storage-containers-to-ovh-public-cloud.html)

# Differences between RunAbove and Public Cloud

## Billing

Contrary to RunAbove, there are 2 types of billing:

 * **Hourly billing:** As with the RunAbove's billing system, the invoice will be generated based on your usage during the following month.
 * **Monthly billing:** You can take advantage of a 50% discount when you choose this billing method. The invoice will be generated automatically on a pro rata basis for the current month. 

## Features

Some features are currently unavailable on Public Cloud:

 * Private networks (Private networks will arrive soon and will be compatible with vRack.)
 * Floating IPs

At the same time, other functionalities that weren't present on RunAbove are now available on Public Cloud:

 * Windows licenses are available for EG and SP instances
 * Import of Failover IP addresses
 * Use of IP load balancing


