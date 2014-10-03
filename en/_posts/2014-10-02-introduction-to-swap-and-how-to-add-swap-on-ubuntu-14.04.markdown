---
layout: post
title: "Introduction to Swap and how to add Swap on Ubuntu 14.04"
categories: Instances
author: neoark
---
**Introduction**
------------
Linux divides its physical RAM (random access memory) into chucks of memory called pages. Swapping is the process whereby a page of memory is copied to the preconfigured space on the hard disk, called swap space, to free up that page of physical memory. The combined sizes of the physical memory and the swap space is the amount of virtual memory available.

Swap memory is required when system requires more memory than what is physically available. Swapping pages gives more space for current application in the memory (RAM) and make application run faster. Swap space should ideally be used as a fall back for when your system's RAM is depleted.

**When to use Swapping**

 1. When the system requires more memory than is physically available, the kernel swaps out less used pages and gives memory to the current application (process) that needs the memory immediately. 
 2. When a significant number of the pages used by an application during its startup phase may only be used for initialization and then never used again. The system can swap out those pages and free the memory for other applications or even for the disk cache.

**Downside of Swapping**

Compared to memory, disks are very slow. Memory speeds can be measured in nanoseconds, while disks are measured in milliseconds, so accessing the disk can be tens of thousands times slower than accessing physical memory. The more swapping that occurs, the slower your system will be. Sometimes excessive swapping or thrashing occurs where a page is swapped out and then very soon swapped in and then swapped out again and so on. In such situations the system is struggling to find free memory and keep applications running at the same time. In this case only adding more RAM will help.

**How to create 3 GiB Swap *File***
-----------------------------
To create a swap file, use the [***fallocate***](http://manpages.ubuntu.com/manpages/trusty/en/man1/fallocate.1.html) command to create an empty file. To create a 3GB file, type:

    $ sudo fallocate -l 3G /swapfile

Prepare the swap file using [***mkswap***](http://manpages.ubuntu.com/manpages/trusty/en/man8/mkswap.8.html):

    $ sudo mkswap /swapfile

Mount the swap file using the [***swapon***](http://manpages.ubuntu.com/manpages/trusty/en/man8/swapon.8.html)

    $ sudo swapon /swapfile

Make the Swap File Permanent by adding following like to ***/etc/fstab***:

    /swapfile       none    swap    sw      0       0
**How to check system for Swap**
----------------------------
Linux has two forms of swap space: 

 - ***Swap partition***
 - ***Swap file*** 

The swap partition is an independent section of the hard disk used solely for swapping and no other files can reside there. The swap file is a special file in the file system that resides among other system and data files.

To see what swap space you have, use the command ***swapon -s***. The output will look something like this:

For ***Swap Partition***:

    $ sudo swapon -s
    Filename    Type       Size        Used  Priority
    /dev/sda3   partition  3145728     0     -1

For ***Swap File***:

    $ sudo swapon -s
    Filename    Type       Size       Used  Priority
    /swapfile   file       3145728    0     -1

**Tweaking Swap Settings**
------------------------
The Linux 2.6 kernel added a new kernel parameter called ***swappiness*** to let administrators tweak the way Linux swaps. It is a number from ***0*** to ***100***. ***Swappiness*** number closer to ***100*** leads to more pages being swapped, and number closer to ***0*** leads to more applications being kept in memory, even when application is in idle state.

Check current defualt ***swappiness*** value:

    $ cat /proc/sys/vm/swappiness
    $ 60

To change default ***swappiness*** value:

    $ sudo sysctl vm.swappiness=10
 
 To make the change permanent through reboot add following line to ***/etc/sysctl.conf***

    vm.swappiness=10

Another kernel parameter called ***vfs_cache_pressure*** let administrators controls the tendency of the kernel to reclaim the memory which is used for caching of directory and inode objects. It is a number from ***0*** to ***100***. At the default value of ***vfs_cache_pressure=100*** the kernel will attempt to reclaim dentries and inodes at a "fair" rate with respect to pagecache and swapcache reclaim.  Decreasing ***vfs_cache_pressure*** causes the kernel to prefer to retain dentry and inode caches. When ***vfs_cache_pressure=0***, the kernel will never reclaim dentries and inodes due to memory pressure and this can easily lead to out-of-memory conditions. 

Check current defualt ***vfs_cache_pressure*** value:

    $ cat /proc/sys/vm/vfs_cache_pressure
    $ 100
To change default ***vfs_cache_pressure*** value:

    $ sudo sysctl vm.vfs_cache_pressure=50
 
 To make the change permanent though reboot add following line to ***/etc/sysctl.conf***

    vm.vfs_cache_pressure=50

**Conclusion**
--------------
Managing swap space is an essential aspect of system administration and performance tuning. With good planning and proper use, swapping can provide many benefits. Always monitor your system to ensure you are getting the results you expect.
