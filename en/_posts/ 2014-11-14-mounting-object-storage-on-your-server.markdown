---
layout: post
title:  "Mounting Object Storage on Your Server"
categories: Object-Storage
author: Ammar Bandukwala
lang: en
---
##### Technologies We'll be using
+ CentOS 7 - A stable  and fun linux distribution
+ Cloudfuse - An application that allows you to mount object-storage as a file-system

*I recommend using a RunAbove instances for our server. Outsourcing may result in increased latency and less consistency.*
# 1. Create our object container
> 1. Click Add
> 2. Click "a storage container"
> 3. Enter container's name
> 4. Hit add (this tutorial will assume you've selected BHS-1) for your region

![Gif of Process](https://sk.gy/raw/PosterEel)
*Whether your container is private or public won't affect how you use this tutorial*
# 2. Setup Cloudfuse
*I'm assumining you have shell access to a CentOS 7 server as well as admin privelleges on your user beyond this point*

Before installing Cloudfuse, we'll need some prerequisite software and libraries.
```
sudo yum -y install git gcc fuse libxml2-devel libcurl-devel fuse-devel  openssl-devel
```

Next we'll download, compile, and install Cloudfuse.
```
cd /tmp
git clone https://github.com/redbo/cloudfuse
cd cloudfuse
./configure
make
sudo make install
cd ~
sudo ln -s /usr/local/bin/cloudfuse /usr/bin/cloudfuse
```
We'll need to use cloudfuse as root
```
sudo su
```

You will need your tenant ID/project ID for the next part of the tutorial. You can get your tenant ID by switching to expert mode and locating the 8 digit number within the top left corner.
![Image Help](https://sk.gy/raw/ReloadSaluki)

Cloudfuse's configuration file is located at "~/.cloudfuse." The following is a layout for your configuration file.
```
username=<RunAbove Email>
tenant=<RunAbove Tenant ID>
password=<RunAbove Password>
authurl=https://auth.runabove.io/v2.0
region=BHS-1
# security vs. performance
verify_ssl=True
```

Now we're ready to mount our object storage.

```
mkdir /mnt/cloud
cloudfuse /mnt/cloud
```

You may now browse your objects at /mnt/cloud/

