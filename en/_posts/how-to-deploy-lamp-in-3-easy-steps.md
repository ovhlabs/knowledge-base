---
layout: post
title:  "How to deploy LAMP(Linux Apache MySQL PHP) in 3 easy steps."
categories: Instances
author: vladreinis
lang: en
---

# Introduction #
RunAbove provides powerful resouces, so why not use em'? Start a website with LAMP and begin developing. As simple as three steps.

# Getting Started #
In this guide you'll learn on how to start up a LAMP server in under 5 minutes.
You'll first need to get a instance running on mostly any flavour of Linux, and assuming you've SSH'ed in the Linux instance.

For this guide I'll be using Debian 7.

# Step 1: Updating Packages and Repositories. #

You'll first need to run the following commands:

##### Debian & Ubuntu
`` apt-get update ``

##### CentOS 
`` yum update ``

# Step 2: Installing Apache 2, MySQL, and PHP. #
You'll first needa install the required applications that make up LAMP.

##### Debian & Ubuntu 
`` apt-get install apache2 ``
##### CentOS 
`` yum install apache2 ``
<hr>
Now we have to install MySQL part of this.
##### Debian & Ubuntu 
`` sudo apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql ``
##### CentOS 
`` yum install mysql-server ``
<hr>
Oh yeah, we'll also need the PHP side of things. So you know we can take care of the serverside of things! 
##### Debian & Ubuntu 
`` sudo apt-get install php5 libapache2-mod-php5 php5-mcrypt ``
##### CentOS 
`` sudo yum install php php-mysql ``

# Step 3: Starting up and configuring the platforms. #

Alright, we've got everything installed, now let launch and configure this baby! 

We'll need to start up MySQL if it hasn't already.
`` sudo service mysqld start ``

Alright we'll need to activate it and set up the root password and some other things that you might want to change or not.
`` sudo mysql_install_db ``

`` sudo /usr/bin/mysql_secure_installation ``

That wasn't so hard, was it? I hope not. Because you're now ready to rule the world and have bragging rights that you've now got website setup, now go youngster, develop!

