---
layout: post
title:  "Linux distributions on skylake dedicated servers"
categories: Hardware
author: xXraphXx
lang: en
---


Dedicated servers embedding the 6th x86 generation of Intel's processors (Skylake) have been available on SYS then Runabove for a few month now.

To use the processor in an optimized manner with a linux operating system, you should make sure that you use a kernel recent enough. 

### **The minimal version would be a 4.3 kernel**

Check yours: `uname -r`

If it meets the requirements, you're done :)

If you have an older kernel, Skylake's backward compatibility with older Intel's processor should allow you to make it work without much trouble but it's not going to offer you the best performances you'd want. 

Besides, related cpu info tools (`lscpu`) may not report the correct information. For instance, overclocked processor maximum frequency may still be reported to 4GHz instead of 4.7GHz.

In the installation assistant: if you install a recent enough distibution (like for example Ubuntu 16.04) and make sure you install the ditribution kernel (see screenshot below for this: tick the case 'Install original kernel' in graphic assistant).

![install](/kb/images/2016-06-23-linux-and-skylake/distrib_kernel.png)

If you do not want to follow such a distribution constraint, or did not tick the case during the installation process, no worries, you can still install a kernel meeting the requirements afterward. Besides, your needs may force you to install a kernel compiled with different options than the installed one anyway (for example if you are interested into gaming, you might prefer a lowlatency kernel configuration, instead of the generic one).

We describe how you can upgrade your kernel below. No worries, if you ever entcounter some issue you can always revert, go to the revert section below for more details.



## Method 1: packaged kernels

Easy and lucky way, the package manager of your distribution (apt for the Debian family, yum/dnf for the RedHat one) can find a repository in your list with compiled kernels embedded into packages.


### Example

Ubuntu 14.04, comes by default with an old 3.13 kernel but, if you use the default ubuntu apt repositories (check your /etc/apt/sources/list if not) you can just run:

```
# apt-get update 
# mv /etc/grub.d/06_OVHkernel ~/06_OVHkernel.bak 
# apt-cache search xenial | grep linux-image
linux-image-extra-virtual-lts-xenial - Transitional package.
linux-image-generic-lts-xenial - Generic Linux kernel image
linux-image-lowlatency-lts-xenial - lowlatency Linux kernel image
linux-image-virtual-lts-xenial - This package will always depend on the latest minimal generic kernel image.
# apt-get install linux-image-generic-lts-xenial
[...]
# shutdown -r now
```

Then once rebooted verify that you booted on your new kernel and not the previous one. You can check your kernel version by typing

```
# uname -r
```

If not check your bootloader file (most likely grub: /boot/grub/grub.cfg) and make sure the default selected menuentry is the good one


## Method 2: use a precompiled bzImage proposed by ovh

You can try out our kernels and see if they suit your needs.

[Go to our bzImages repository](ftp://ftp.ovh.net/made-in-ovh/bzImage/)


For example you may be interested in

[bzImage-4.5.2-mod-std-ipv6-64](ftp://ftp.ovh.net/made-in-ovh/bzImage/4.5.2/bzImage-4.5.2-mod-std-ipv6-64)

Or (similar to the low latency one showed in method 1, except it has got the drawback of not allowing dynamic module load):

[bzImage-4.5.2-xxxx-std-ipv6-64-hz1000](ftp://ftp.ovh.net/made-in-ovh/bzImage/4.5.2/bzImage-4.5.2-xxxx-std-ipv6-64-hz1000)


Please follow the already [existing guide](http://help.ovh.com/KernelInstall) for this, section 'Procedure to up date the kernel on your hard disk'

 
## Method 3: custom compilation and deployment


The most tedious thing is to build the initial kernel configuration when you start from scratch. 
So we attach here some configurations which you can use as a starting point

* [generic](/kb/attachments/2016-06-23-linux-and-skylake/config-4.4.0-generic)

* [lowlatency](/kb/attachments/2016-06-23-linux-and-skylake/config-4.4.0-lowlatency)

Alternatively you can also take the one from your running kernel: 

Depending on its configuration (CONFIG\_PROC\_FS=y, CONFIG\_IKCONFIG=y, CONFIG\_IKCONFIG\_PROC=y):

```
# zcat /proc/config.gz > /tmp/mystartingconfig
```

Or if not enabled:

```
# find /boot -type f -name "config-$(uname -r)"
```

so now you have your config to start from

Go to kernel.org and grab latest sources, for example `KERNEL_VERSION=4.6.2`


```
# apt-get install -y gcc make libncurses5-dev libssl-dev bc
# wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-${KERNEL_VERSION}.tar.xz
# tar xf linux-${KERNEL_VERSION}.tar.xz
# cd linux-${KERNEL_VERSION}
# cp /tmp/mystartingconfig .config
# make olddefconfig
# THREADS=$(lscpu | grep -E '^CPU\(s\):' | awk '{print $2}')
# make -j $THREADS bzImage modules
# make modules_install
# make install
```

`make install` should take care of building your initramfs and updating you bootloader config files

## Enjoy

```
# lscpu
Architecture:          x86_64
CPU op-mode(s):        32-bit, 64-bit
Byte Order:            Little Endian
CPU(s):                8
On-line CPU(s) list:   0-7
Thread(s) per core:    2
Core(s) per socket:    4
Socket(s):             1
NUMA node(s):          1
Vendor ID:             GenuineIntel
CPU family:            6
Model:                 94
Model name:            Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz
Stepping:              3
CPU MHz:               800.000
CPU max MHz:           4700.0000
CPU min MHz:           800.0000
BogoMIPS:              8016.72
Virtualization:        VT-x
L1d cache:             32K
L1i cache:             32K
L2 cache:              256K
L3 cache:              8192K
```

## Reverting your changes in case of failure

If something wrong occured with your new kernel, and your server does not reboot, unfortunately, for the current hardware profiles of servers having skylake processors, there is no direct check possibility for users through a kvm or an ipmi sol. At least you can still reboot on rescue to uninstall the kernel if needed.

![boot_to_rescue1](/kb/images/2016-06-23-linux-and-skylake/rescue1.png)

![boot_to_rescue2](/kb/images/2016-06-23-linux-and-skylake/rescue2.png)

Once you have selected the netboot don't forget to restart your server.

In both ways described below use `lsblk` and `blkid` to guess your rootfs partition (/dev/sda2, /dev/md2...)

Example: with software raid1 on two disks

```
root@rescue:~# lsblk
NAME    MAJ:MIN RM    SIZE RO TYPE  MOUNTPOINT
sda       8:0    0    1.8T  0 disk  
├─sda1    8:1    0 1004.5K  0 part  
├─sda2    8:2    0   19.5G  0 part  
│ └─md2   9:2    0   19.5G  0 raid1 
├─sda3    8:3    0    1.8T  0 part  
│ └─md3   9:3    0    1.8T  0 raid1 
└─sda4    8:4    0    511M  0 part  
sdb       8:16   0    1.8T  0 disk  
├─sdb1    8:17   0 1004.5K  0 part  
├─sdb2    8:18   0   19.5G  0 part  
│ └─md2   9:2    0   19.5G  0 raid1 
├─sdb3    8:19   0    1.8T  0 part  
│ └─md3   9:3    0    1.8T  0 raid1 
└─sdb4    8:20   0    511M  0 part  
root@rescue:~# blkid
/dev/sda1: PARTLABEL="bios_grub-sda" PARTUUID="9b7e23da-9f37-496f-ad2e-0f99542b1d93"
/dev/sda2: UUID="2e91c964-0a7e-3089-a4d2-adc226fd5302" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="ea8c23a8-e52b-453c-b72d-70d45b94add2"
/dev/sda3: UUID="838721c7-7448-6cb0-a4d2-adc226fd5302" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="123af79f-5c86-4900-a271-b4e2982cc7ca"
/dev/sda4: LABEL="swap-sda4" UUID="31877986-cf48-4396-9a35-8b10f38c10e7" TYPE="swap" PARTLABEL="primary" PARTUUID="bfed4246-e98d-46ac-9e2b-522af5655bec"
/dev/sdb1: PARTLABEL="bios_grub-sdb" PARTUUID="a3a0dd9b-328f-4ec2-9269-53c6af319107"
/dev/sdb2: UUID="2e91c964-0a7e-3089-a4d2-adc226fd5302" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="0b820ebf-158d-4261-937a-feedbdceca6a"
/dev/sdb3: UUID="838721c7-7448-6cb0-a4d2-adc226fd5302" TYPE="linux_raid_member" PARTLABEL="primary" PARTUUID="9d36fcda-9141-4203-867e-d6eecaab746a"
/dev/sdb4: LABEL="swap-sdb4" UUID="8237cccb-c6a9-42c9-836e-a26495d89778" TYPE="swap" PARTLABEL="primary" PARTUUID="959f8260-4f3f-4ddf-9444-d14036d56668"
/dev/md3: LABEL="/home" UUID="93cfd475-2d96-415d-aff3-cdf8b56c452b" TYPE="ext4"
/dev/md2: LABEL="/" UUID="093e168d-0535-42e2-b179-83cb81c73aa6" TYPE="ext4"
```

### Method 1:

```
# mount ${ROOTFS_PART} /mnt
# mount -t proc /proc/ /mnt/proc/
# mount -o bind /dev/ /mnt/dev/
# mount -o bind /sys/ /mnt/sys/
# chroot /mnt
# apt-get autoremove linux-image-lowlatency-lts-xenial
```

Unfortunately it does not uninstall the kernel package itself. To do so, you need to find it by yourself

```
# dpkg -l | grep lowlatency
ii  linux-image-4.4.0-24-lowlatency    4.4.0-24.43                     amd64        Linux kernel image for version 4.4.0 on 64 bit x86 SMP
# apt-get purge linux-image-4.4.0-24-lowlatency
# dpkg -l | grep lowlatency
```

### Method 2 and 3: adapt to your kernel version and bootloader if not grub2

```
# KERNEL_VERSION=4.6.2
# mount ${ROOTFS_PART} /mnt
# mount -t proc /proc/ /mnt/proc/
# mount -o bind /dev/ /mnt/dev/
# mount -o bind /sys/ /mnt/sys/
# chroot /mnt
# cd /boot
# rm -f config-${KERNEL_VERSION} vmlinuz-${KERNEL_VERSION} System.map-${KERNEL_VERSION} initrd.img-${KERNEL_VERSION} bzImage-${KERNEL_VERSION}
# cd /lib/modules/
# rm -rf --one-file-system ${KERNEL_VERSION}
# update-grub
```

## Contacts:

* mailing list: **hardware.labs-subscribe@ml.ovh.net**
* irc #runabove on freenode

