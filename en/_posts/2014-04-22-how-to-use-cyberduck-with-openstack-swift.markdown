---
layout: post
title: "How to use Cyberduck with Openstack Swift?"
categories: Object-Storage
lang: en
author: VincentCasse
---

To use RunAbove object storage, you can code integration into your software.  However, you will sometimes need to access your object storage without using your software. Cyberduck (available on Windows and Mac) is an application for accessing and managing your object storage, such as an FTP

# 1. Preparation

## Download Cyberduck

Download the latest version of Cyberduck at [cyberduck.io](http://cyberduck.io) and install it.

Cyberduck is compatible with RunAbove from version 4.4.4. If you have version 4.4.3, you need to change the update channel to beta version. You can change the channel in the __Preferences__ menu, under the __Update__ tab. Change _Release_ to _beta_ and click on __Check for Update Now__

## Get missing information

To connect to your RunAbove object storage, you will need to have your login, password and tenant name. This last information can be found in __expert mode__ manager below __current project__

![](https://lb1049.pcs.ovh.net/v1/AUTH_e17900908d244c4bb80525f0c0d3a227/public/access-to-your-object-storage-with-cyberduck.html/tenant_name.png)

# 2. Connection

![](https://lb1049.pcs.ovh.net/v1/AUTH_e17900908d244c4bb80525f0c0d3a227/public/access-to-your-object-storage-with-cyberduck.html/conf_cyberduck.png)

 * Click on the __Open Connection__ button and select __Openstack Swift (keystone)__.
 * Type _auth.runabove.io_ in the __Server__ field, your username in the __Username__ field and your password in... the __Password__ field!
 * Submit form by clicking on __Connect__
 * Type your tenant name and click on __Login__

![](https://lb1049.pcs.ovh.net/v1/AUTH_e17900908d244c4bb80525f0c0d3a227/public/access-to-your-object-storage-with-cyberduck.html/cyberduck.png)

Congrats! You can now manage your objects, such as dragging and dropping files, or deleting folders.