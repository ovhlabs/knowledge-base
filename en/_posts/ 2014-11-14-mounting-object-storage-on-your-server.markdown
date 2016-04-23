---
layout: post
title:  "Mounting Object Storage on Your Server"
categories: Object Storage, Instances
author: Ammar Bandukwala
lang: en
---
##### Technologies We'll be using
+ CentOS 7 - A stable  and fun linux distribution
+ Cloudfuse - An application that allows you to mount OpenStack Swift's object storage as a filesystem

*I recommend using a RunAbove compute instance for production implementations of this tutorial. The use of external providers may result in higher latency, lower consistency, and lower speeds.*
# 1. Create our object container
> 1. Click Add on the sidebar
> 2. Click "a storage container"
> 3. Enter container's name
> 4. Click add

![Gif of Process](/images/2014-11-14-mounting-object-storage-on-your-server/add_container.gif)
*Whether your container is private or public won't affect how you use this tutorial*
# 2. Setup Cloudfuse
*The tutorial assumes you have shell access to a CentOS 7 server as well as admin privelleges on your user beyond this point*

Before installing Cloudfuse, we'll need some prerequisite software and libraries.
```
sudo yum -y install git gcc fuse libxml2-devel libcurl-devel fuse-devel  openssl-devel
```

Next, we'll download, compile, and install Cloudfuse.
```
cd /tmp
git clone https://github.com/redbo/cloudfuse
cd cloudfuse
./configure
make
sudo make install
cd ~
```

You will need your tenant ID/project ID for the next part of the tutorial. You may view your tenant ID by switching to expert mode in the RunAbove dashboard and locating the 8 digit number at the top left corner.
![Image Help](/images/2014-11-14-mounting-object-storage-on-your-server/project_id.png)

Cloudfuse's configuration file is located at "~/.cloudfuse." The following is a useable layout for your configuration file.
```
username=<RunAbove Email>
tenant=<RunAbove Tenant ID>
password=<RunAbove Password>
authurl=https://auth.runabove.io/v2.0
#You may remove the region line if you wish to use SBG-1
region=BHS-1
# security vs. performance
verify_ssl=True
```

Now we're ready to mount our object filesystem.

```
mkdir ~/cloud
cloudfuse ~/cloud
```

__You may now browse your objects at ~/cloud/__


When finished accessing your object storage, you may safely unmount the filesystem with the following command

```
fusermount -u ~/cloud
```


