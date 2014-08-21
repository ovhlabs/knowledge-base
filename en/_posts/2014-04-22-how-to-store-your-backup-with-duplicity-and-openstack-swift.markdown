---
layout: post
title: "How to store your backup with duplicity and Openstack Swift?"
categories: Object-Storage
lang: en
author: VincentCasse
---

Duplicity is an open source tool for backing up your files. You can find more information on the official [website](http://duplicity.nongnu.org/).

Since version 0.6.22, Swift has been on the list of available back-ends. So you can use Duplicity to send your backup on RunAbove object storage.

# 1. Preparation

## Download Duplicity

Download Duplicity with version 0.6.22 or later. Packaged versions are available for the most widely known distributions.

## Get missing information

To connect to your RunAbove object storage, you will need to have your login, password and tenant name. This information can be found in __expert mode__ manager below __current project__

![](https://lb1049.pcs.ovh.net/v1/AUTH_e17900908d244c4bb80525f0c0d3a227/public/access-to-your-object-storage-with-cyberduck.html/tenant_name.png)

## Create a new container

RunAbove object storage allows you to create distinct areas called __containers__ to store your files. It's good practice to use a specific backup container. You can create it in your [control panel](https://cloud.runabove.com/#/add).

Under __What do you want to add?__, select _A storage_, then define your container name and geographical region.

# 2. Ready to backup?

The last step before starting your backup is to define your account information for Duplicity. You must define these environment variables: 

 * SWIFT_USERNAME: your username
 * SWIFT_PASSWORD: your password
 * SWIFT_AUTHURL: https://auth.runabove.io:443/v2.0
 * SWIFT_AUTHVERSION: 2
 * SWIFT_TENANTNAME: your tenant name
 * SWIFT_REGION: (optional) region where you want to store backup (BHS-1, SBG-1...)

Finally, you can back up the __configuration__ folder in your __backup__ container.

```
duplicity configuration/ swift://backup
```