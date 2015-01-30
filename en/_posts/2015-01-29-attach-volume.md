---
layout: post
title: "Attach additional storage to an instance"
categories: instances
lang: en
author: NicolasLM
---

Thanks to OpenStack Cinder you can attach additional disk space to your 
instance. This guide will show you how to use this feature.

Create a volume
---------------

On Cinder a drive is called a volume. The first thing you need to do is to 
create a new volume in the region you want. To do that go to OpenStack Horizon 
in the volumes area.

Click on `Create Volume` and a form asking a few parameters will appear. Select 
the type of volume you need, its name, size, `nova` as availability zone and 
select `empty volume`. Finally you can create the volume.

![Create Volume](/kb/images/2015-01-29-attach-volume/create.png)

Attach the volume to an instance
--------------------------------

From the volumes list click on `More` and `Edit Attachments` to attach a volume 
to a running instance.

![Edit attachments](/kb/images/2015-01-29-attach-volume/edit-attachments.png)

Select the instance on which you want extra disk space and click on `Attach 
Volume`.

![Attach](/kb/images/2015-01-29-attach-volume/attach.png)

You will see to which device your volume is attached to. This device will be 
accessible directly into your instance.

Format and mount the volume
---------------------------

Once the volume is attached to your instance you need to format the device and 
mount it. This operations are different if you use GNU/Linux or Windows 
instances.

### GNU/Linux

From a shell issue the `lsblk` command, this will list the block devices you 
can use:

```
admin@mariadb:~$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
vda    253:0    0   160G  0 disk
└─vda1 253:1    0   160G  0 part /
vdb    253:16   0   9.8T  0 disk
```

The device `/dev/vda` is the root disk of your system. It has one partition 
called `/dev/vda1` filling all the space. Then you can see `/dev/vdb` which is 
the volume you just attached.

In order to be able to use it you need to format it and mount it somewhere.  
This is easily done with:

```
admin@mariadb:~$ sudo mkfs.ext4 /dev/vdb
Allocating group tables: done
Writing inode tables: done
Creating journal (32768 blocks): done
Writing superblocks and filesystem accounting information: done

admin@mariadb:~$ sudo mkdir /mnt/database

admin@mariadb:~$ sudo mount /dev/vdb /mnt/database/

admin@mariadb:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda1       158G  1.1G  150G   1% /
/dev/vdb        9.7T   38M  9.3T   1% /mnt/database
```

You can now store your files on the directory `/mnt/database`.

### Microsoft Windows Server

Right click on the Windows button and select `Disk management`.

![Windows](/kb/images/2015-01-29-attach-volume/windows-disk-management.png)

There you can right click on `Disk 1` and select `Online`, then again select 
`New Simple Volume`. Select the options you want, the default selected one are 
fine.

![Windows](/kb/images/2015-01-29-attach-volume/windows-online.png)

![Windows](/kb/images/2015-01-29-attach-volume/windows-new.png)

Once the formatting is done, a new drive will be available on your instance.

![Windows](/kb/images/2015-01-29-attach-volume/windows-drives.png)


