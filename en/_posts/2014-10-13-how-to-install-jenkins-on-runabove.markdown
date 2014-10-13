---
layout: post
title: How to install Jenkins on RunAbove?
catagories: instances
tags: guide
author: DrOfAwesomeness
lang: en
---
[Jenkins](http://jenkins-ci.org) is an open-source continuous integration server written in Java. It's a popular solution that is used by [Numerous companies](https://wiki.jenkins-ci.org/pages/viewpage.action?pageId=58001258) including Github and Dell.

1. Installing Jenkins
=====================

Installing Jenkins on RunAbove is a fairly simple process. This tutorial assumes you are using Ubuntu 14.04 on your RunAbove instance.
First, add the key for the Jenkins APT repository to your keychain:

```
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
```

Next, append the Jenkins APT repository to your sources.list file:

```
echo deb http://pkg.jenkins-ci.org/debian binary/ | sudo tee -a /etc/apt/sources.list
```

Then, update your package lists and install the jenkins package:

```
sudo apt-get update -y && sudo apt-get install -y jenkins
```

Finally, you'll need to allow port 8080 through the RunAbove firewall. To do this, go to Expert Mode in the RunAbove control panel, select the region your instace is in under "Managing Region", go to "Acces & Security" and add a rule to the default security group allowing Ingress port 8080.

Congratulations! Your Jenkins server is now avaliable at `http://your-instance-ip:8080` (replace `your-instance-ip` with the IP of your instance). Note that your instance is currently publicly-accessible. For information on configuring security for your Jenkins server, see the [Securing Jenkins](https://wiki.jenkins-ci.org/display/JENKINS/Securing+Jenkins) page on the [Jenkins Wiki](https://wiki.jenkins-ci.org/display/JENKINS/Home).
