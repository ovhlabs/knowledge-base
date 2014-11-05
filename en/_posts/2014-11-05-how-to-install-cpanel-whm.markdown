---
layout: post
title:  "How to install cPanel/WHM on an instance?"
categories: Instances
author: XPEric
lang: en
---

cPanel/WHM is a web hosting management interface that simplifies server administration tasks. It provides the end user a graphical interface and automates tasks such as configuring dns and apache virtual hosts. 

**Note: Although cPanel/WHM comes with a free 15-day trial, you must purchase the product after the trial ends.**

1. Create a new instance
======

You're going to first need to create a new instance. Login to RunAbove at https://cloud.runabove.com/ and go to the create instance page. Choose a service plan with at least 512MB of RAM and a 20GB disk, although it's recommended that you have at least 1GB. When prompted to choose an OS, select CentOS 6 or CentOS 7 (the officially supported operating systems are CentOS 6+, RedHat Enterprise Linux, and CloudLinux, although CentOS should suffice for most users). Create your SSH key (there is a help link for users who do not know how to do this). 

2. Configuring the instance for cPanel/WHM
======

**Note: cPanel/WHM requires a minimal OS configuration in order to work correctly, so do not install/remove/configure any services not explicitly specified in this tutorial prior to installing.**

cPanel/WHM requires a fully qualified domain name (FQDN) to be defined prior to install. To do this, first take your domain name (ex: yourdomain.com), decide what you are going to call the server (ex: server1), and run the following command: 'hostname server1.yourdomain.com', substituting it with your values. 

You will need to specify a root password for your instance, as cPanel/WHM uses the root account. Simply run 'passwd root' and type your desired password to set it. 

3. Installing cPanel/WHM
======

Now it is time to run the actual installer. First, make sure you have wget installed by running 'yum install. wget'. Next, change to your home directory by running 'cd /home'. Now, download the official installer by running the command 'wget -N http://httpupdate.cpanel.net/latest'. You can now run the installer with 'sh latest'. The installer itself is mostly automated and requires little user intervention, so you can now just wait for it to finish, which usually takes an average of about 45 minutes to an hour. 

4. Configuring cPanel/WHM
======

Once the installation is finished, you have to run the "setup wizard", which configures cPanel for use. You can access this by opening 'yourip:2086' in your Web browser, replacing 'yourip' with the IP address of your RunAbove instance. Login with your root username and password. The setup wizard is very straight-forward.

5. Final Remarks
======

cPanel/WHM is now fully configured. You can add hosting accounts via the WHM interface, and all configuration will be handled automatically. End users can manage their accounts and upload files by browsing to the port '2082' and logging in with their username and password.