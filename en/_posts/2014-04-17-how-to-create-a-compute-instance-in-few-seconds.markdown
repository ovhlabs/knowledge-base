---
layout: post
title:  "How to create instances in few seconds?"
categories: Instances
author: VincentCasse
lang: en
---

In RunAbove, it is possible to create new instances with dedicated hardware in few seconds! But how you can create new instances?

# Generate an SSH key

The first time you create a instance, you will need to add a new SSH key. This key will be used to administer your server. To create a new SSH key, you can use ssh-keygen. Your public key will be available in _.ssh/id_rsa.pub_

```
ssh-keygen -t rsa -b 4096 -C "firstname.lastname@domain.com"
```

# Open your manager

Open RunAbove [Control panel](https://cloud.runabove.com) with your login details.

![](https://lb1049.pcs.ovh.net/v1/AUTH_e17900908d244c4bb80525f0c0d3a227/public/how-to-create-a-compute-instance-in-two-minutes.html/login_runabove.png)

# Add a new instance

Click on __Add__ in the left-hand menu and choose to add an __Instance__.

Fill in the form with your custom configuration:

 * Image is the distribution you choose
 * Region is the area where the instance is stored
 * Template is the hardware profile you want

If you don't already have registered a SSH key, select __Create an SSH key__ and give it a name, and copy the content of your public key.

![](https://community.runabove.com/public/files/4sSRjnRagduTmpyhCoU7.png)

# Your instance is ready!

When the status of your instance is __active__, you can access your server with SSH

```
ssh admin@ip.of.your.vm
```