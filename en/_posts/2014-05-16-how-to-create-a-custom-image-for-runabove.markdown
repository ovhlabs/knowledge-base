---
layout: post
title:  "Import a custom image in your RunAbove Account"
categories: Instances
author: NicolasLM
lang: en
---

RunAbove provides the most widely used operating systems, optimized for the cloud. However sometimes you need to run a custom system. As the virtualization technology behind RunAbove is [KVM](http://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine) it can run every operating system, __32__ and __64 bits__.

This guide will help you to setup a system from the installer and make it work with RunAbove. In this example, we will use a distribution that is not yet available in RunAbove: the 32 bits version of Debian Wheezy, but you can choose any other system.

# Requirements:

The first step is to install, on your local machine, the __qemu-kvm__ tools. Check your distribution repository for the proper packets to install. For example, on a Debian host it would be the packages _qemu-system_ and _qemu-utils_:

```
apt-get install qemu-system qemu-utils
```

Once your host is able to run qemu/KVM virtualization you can download the installer of the system you want. Any ISO image will be fine.

# Virtual drive creation:

Now you have to create the virtual drive that will handle your installed system. The __qcow2__ format, allows users to make big virtual disks, while keeping the file size on your host minimal. To build a 3 GB virtual drive issue the following:

```
qemu-img create -f qcow2 debian-7-32.qcow2 3G
```

# Custom system installation:

You can use this shell script that runs qemu with the proper settings to install a system compatible with RunAbove.

```bash
#!/bin/bash

#### Configuration #####
#
QEMU_KVM='qemu-system-x86_64'
CPUs="cores=4,threads=1,socket=1"
RAM=1024
CLOCK_BASE="utc"
#
########################


if [ $# -lt 2 ]; then
cat <<EOF
Usage: $0 drive cdrom

    drive       Virtual drive where the system will be installed
    cdrom       ISO installer of the operating system

EOF
    exit 1
fi

bin_qemu_kvm=`which $QEMU_KVM | wc -l`
if [ "$bin_qemu_kvm" == "0" ]; then
    echo "The program $QEMU_KVM cannot be found"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "The virtual drive file $QEMU_KVM doesn't exist"
    exit 1
fi

if [ ! -f "$2" ]; then
    echo "The ISO installer $QEMU_KVM doesn't exist"
    exit 1
fi

$QEMU_KVM \
        -nodefaults \
        -drive file=$1,if=virtio,id=drive-virtiodisk0,cache=none \
        -cdrom $2 \
        -boot once=d,menu=on \
        -enable-kvm \
        -cpu host \
        -smp $CPUs \
        -m $RAM \
        -rtc base=$CLOCK_BASE,clock=host \
        -netdev user,id=usernet,net=169.254.0.0/16,hostfwd=tcp::2222-:22,hostfwd=tcp::8080-:80 \
        -device virtio-net-pci,netdev=usernet \
        -vga cirrus
```

The first parameter is the __virtual drive__ and the second one is the __ISO CD__ of the installer. Make it executable and run it:

```
chmod +x qemu-install
./qemu-install debian-7-32.qcow2 debian-7.5.0-i386-netinst.iso
```

You will see a qemu window that appears, just boot from the CD ROM and the installer will start.

![](https://community.runabove.com/public/files/pas7T1ySk1kRGCGFUukf.png)

Install the system so it fits your needs and once you are satisfied with the result you can shut down the virtual machine. Next time you boot the VM, it it will be running on extremely performant hardware, because now, it's time to upload it to the cloud!

# Upload your custom image:
Before uploading your image to RunAbove you can use the compression feature of the qcow2 format. Compression allows users upload images faster. By issuing this command you will create a compressed copy of your system. The first parameter is the image you just built and the second is the compressed version that will be created:

```
qemu-img convert -c -f qcow2 -O qcow2 debian-7-32.qcow2 debian-7-32.gz.qcow2
```

Once you have the compressed image it is ready to be uploaded to RunAbove. This guide shows how simple it is to [transfer an image](/kb/en/instances/import-a-custom-image-in-your-runabove-account.html) to the service.

# Some advice on how to build better images:

 * RunAbove uses the powerful __VirtIO__ drivers for block devices and network adapters. Those drivers are available directly in the Linux kernel.
 * Windows needs additional VirtIO drivers, that you can find on the [RedHat project](http://alt.fedoraproject.org/pub/alt/virtio-win/stable/).  You have to add VirtIO drivers as a third disk and load them from the installer when it prompts you.
 * You will have to expand the main drive once your instance is running. You can do it manually or launch tools that will do that for you.
 * All network configuration is done by __DHCP__, no need to worry with that.
 * Root __password__ and your __SSH key__ are directly injected to your instance so no need to worry either.
 * You can set __firewall__ rules from the manager, they will be interpreted before routing packets to your instance so you don't need to bother setting a firewall inside each instance.
 * A __web service__ that gives information about the instance is available from the instance itself at _http://169.254.169.254_. You can install tools like [cloud-init](https://help.ubuntu.com/community/CloudInit) that use this web service to customize the instance at boot time
 * OpenStack provides many [guides](http://docs.openstack.org/image-guide/content/ch_introduction.html) for creating various images.
