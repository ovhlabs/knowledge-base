---
layout: post
title:  "How to Mount Runabove Object Storage in Linux using cloud fuse"
categories: Instances
author: neoark
---

Installing Dependencies
======================

**Debian or Ubuntu install:**

    $ apt-get install build-essential libcurl4-openssl-dev libxml2-dev libssl-dev libfuse-dev git

**For CentOS or similar**

    $ yum install gcc make fuse-devel curl-devel libxml2-devel openssl-devel git

Compiling and installing CloudFuse
==================================

**Step 1:**

    $ cd ~
    $ git clone https://github.com/redbo/cloudfuse.git

**Step 2:**

    $ cd ~/cloudfuse
    $ ./configure
    $ make
    $ sudo make install

Mounting Cloud Files
====================
Create a configuration file for CloudFuse in your home directory and put your **[Runabove Cloud Files](https://cloud.runabove.com/horizon/project/access_and_security/api_access/openrc/)** username and API key in it, as shown below:

    $ vi  ~/.cloudfuse 

Add following information to .cloudfuse file:

    username=
    api_key=
    tenant=
    password=
    authurl=https://auth.runabove.io/v2.0
    region=

Set .cloudfuse file permissions

    $ chmod 600 ~/.cloudfuse

***Note:*** **api_key** is same as **OS_TENANT_ID**. Please refer to **[How to use OpenStack command line tools?](https://community.runabove.com/kb/en/instances/use-openstack-command-line-tools.html)**

After creating the above configuration file, run the cloudfuse command to mount the Runabove Storage Object.

    cloudfuse [mount point]

See Example below:

    $ mkdir ~/cloudfiles
    $ cloudfuse ~/cloudfiles

To make the mount point permanent during reboots use fstab

    cloudfuse /mnt/cloudfiles fuse username=<username>,api_key=<key>,tenant=<tenant>,password=<password>,authurl=<URL>,region=<url>,<user eg. root admin etc.> 0 0

***Note:*** Using this method allow other users to see your password in fstab file.

***Note:*** If you are not logged in as the user root on the system, then your username will need to be part of the "fuse" group. This can be accomplished with the following command:

    $ sudo usermod -a -G fuse [username]

BUGS/SHORTCOMINGS:
==================
 - rename() doesn't work on directories (and probably never will).
 - When reading and writing files, it buffers them in a local temp file.
 - It keeps an in-memory cache of the directory structure, so it may not be usable for large file systems.  Also, files added by other applications will not show up until the cache expires.
 - The root directory can only contain directories, as these are mapped to containers in cloudfiles.
 - Directory entries are created as empty files with the content-type "application/directory".
 - Cloud Files limits container and object listings to 10,000 items. cloudfuse won't list more than that many files in a single directory.
