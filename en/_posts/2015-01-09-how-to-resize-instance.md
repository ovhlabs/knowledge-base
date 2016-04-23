---
layout: post
title: "How to resize instance with ext4 file system?"
categories: Instances
lang: en
author: bartekzurawski
---

With instances you can make many things. One of this thing is resize. Resize
allows you to change instance flavor after it was deployed.

Using the expert mode in Horizon (OpenStack dashboard) we can do resize of
working instance.

Resize working only in one kind of flavors eg. from ra.intel.ha to another ra.intel.ha,
and the same from ra.intel.ssd to another ra.intel.ssd. You can't resize from ra.intel.ha 
to ra.intel.ssd

__Because resize instance requires reboot, service on your instance will be down__

__Every action from this tutorial that you performed on your instance, you do it at your own risk__

<h2>1. Make instance bigger</h2>

To make your instances bigger you need to login to your RunAbove account. In
expert mode click on __Instances__ from the menu, next you need click on
__more__ button and chose __resize instance__. You will see new window where you
can chose new flavor for your instance.

![Resize ip](/kb/images/2015-01-09-how-to-resize-instance/resize_up.png)

After chosing new flavor, just click on __resize__ button. Now your instance
will be resizing, and you must confirm resize action. If you don't do this,
resize have automatically confirmation after 1 minute. 

![Resize confirm](/kb/images/2015-01-09-how-to-resize-instance/resize_confirm.png)

<h2>2. Make instance smaller</h2>

Making your instance smaller is a bit different than make it bigger, because
first you need to prepare your instance to fit into the chosen flavor. In this 
example we will be resizing instance from flavor ra.intel.ha.l to ra.intel.ha.s. 

Prepare your instance means that you need to shrink partition in your instance
to size like in chosen flavor disk (in this case to 10 GB). Because your
partition is ext4 you need to shrink on unmount file system. To do that we need
download Gparted:

```
wget http://downloads.sourceforge.net/gparted/gparted-live-0.20.0-2-i486.iso

```

after that, we need to create place where we will be stored Gparted in boot
directory:

```
sudo mkdir /boot/iso

```

and move gparted to the newly created place:

```
sudo mv gparted-live-0.20.0-2-i486.iso /boot/iso/

```

Next thing that you need to do is add entry to your __grub.cfg__ (/boot/grub/grub.cfg) that allows you
to run Gparted, but to do that, you need change permision to grub.cfg because defaultly this is read 
only file:

```
sudo chmod 744 /boot/grub/grub.cfg

```
add entry to the end of grub.cfg:

```
menuentry 'Gparted' {
        set isofile="/boot/iso/gparted-live-0.20.0-2-i486.iso"
        loopback loop (hd0,1)$isofile
        linux (loop)/live/vmlinuz boot=live config union=aufs noswap noprompt ip=frommedia findiso=$isofile toram=filesystem.squashfs
        initrd (loop)/live/initrd.img
}

```

After that, you need to go to the RunAbove panel. In RunAbove panel switch your
view to expert mode. Go to __Instances__ and click on your instance that you
want to resize. Then switch tab to console. When console will be loaded, you
need to click on button __send CtrlAltDel__ :

![Grub](/kb/images/2015-01-09-how-to-resize-instance/grub.png)

After that, you should see GRUB (your system bootloader), if you don't click on
button __send CtrlAltDel__ again. When you are in GRUB, select Gparted and hit
enter. It may take a moment. While Gparted is booting you need to choose few
option. First you need to chose your keybord configuration. Safe option is to
choose default one __Don't touch keymap__. Next you need to choose language.
After that, you need to choose mode that you prefer 
__(graphic, configured by yourself or text)__, graphic mode is default option, 
in this example we will be using graphic mode. 

![Keymap](/kb/images/2015-01-09-how-to-resize-instance/keymap.png)
![Language](/kb/images/2015-01-09-how-to-resize-instance/language.png)

When Gparted is loaded, you should see window, where you should see information
about your hard drive, partiotion etc. Now we will prepare file system.
Right-click on __/dev/vda1__ partition, and from context menu choose
__Resize/Move__:. 

![Disk](/kb/images/2015-01-09-how-to-resize-instance/disk.png)

From the new window, you need to choose new size of your partition. Because we
try to resize instance from ra.intel.ha.l (80 GB) to ra.intel.ha.s (10 GB) size
of new partition should be 10000 MiB because in Gparted size of partition is
presented in MB. 

![Change partition](/kb/images/2015-01-09-how-to-resize-instance/change_partition_size.png)

When you choose new size of your partition, just click on __Resize/Move__. And in warning box
just click on __Apply__:

![Warning](/kb/images/2015-01-09-how-to-resize-instance/warning.png)

__Remember you do it at your own risk__

When Gparted finish resizing partition, you need to go to the RunAbove panel (in
expert mode view). Go to __Instances__, click on __More__ button and from menu,
chose __Resize instance__ option. Now you need to choose new flavor. After
choosing new flavor, click on __Resize__ button. Your instance will be resized.

After resizing, your instance should normally boot:

![Done](/kb/images/2015-01-09-how-to-resize-instance/done.png)

When your instance is resized, you can check is everything is ok, just log in
to your instance via ssh and do:

```
df -H

Filesystem      Size  Used Avail Use% Mounted on
/dev/vda1        11G  1.5G  8.7G  15% /
none            4.1k     0  4.1k   0% /sys/fs/cgroup
udev            1.1G   13k  1.1G   1% /dev
tmpfs           210M  353k  210M   1% /run
none            5.3M     0  5.3M   0% /run/lock
none            1.1G     0  1.1G   0% /run/shm
none            105M     0  105M   0% /run/user

```

In output you should see your new partition which has a new size.

Sometimes instance is "stuck" becuase grub don't start system and waits 
for  action, in that case you need to go to the __Instances__, click on your
instance, switch to console tab, and in grub menu of your instance choose your 
system and hit enter. It should normally boot up.
