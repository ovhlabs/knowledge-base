---
layout: post
title:  "How to deploy LAMP(Linux Apache MySQL PHP) in 3 easy steps."
categories: Instances
author: vladreinis
lang: en
---

# Getting Started
In this guide you'll learn on how to start up a LAMP server in under 5 minutes.
You'll first need to get a instance running on mostly any flavour of Linux, and assuming you've SSH'ed in the Linux instance.

For this guide I'll be using Debian 7.

# Step 1: Updating Packages and Repositories.

You'll first need to run the following commands:

##### Debian & Ubuntu
<pre><code>apt-get update</code></pre>

##### CentOS
<pre><code>yum update</code></pre>.
# Step 2: Installing Apache, MySQL, and PHP.
Install line for apache 2:
<pre><code>sudo apt-get install apache2</code></pre>


