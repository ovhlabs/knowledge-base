---
layout: post
title:  "How to Install an Orchestration Tool? Juju with Openstack"
categories: Instances
author: NicolasLM
lang: en
---

[Juju](https://juju.ubuntu.com/) is an incredible orchestration tool, that allows you to quickly deploy services and scale them out. It works by adding _charms_ to an infrastructure. Charms are packages designed for the cloud. You can browse the [list of charms](https://jujucharms.com/) to see if your favorite programs are ready to be deployed by Juju.

Thanks to the __OpenStack API__, RunAbove, is fully compatible with Juju. This guide will explain how to launch Juju on RunAbove in a few minutes.

# Requirements:

Juju client, the program that allows to setup and manage a Juju infrastructure is available on __Ubuntu__, __Mac OS X__ and __Windows__. Check the [Juju installation](https://juju.ubuntu.com/install/) page for more details. This guide assumes that you are using the Ubuntu version, however steps should be very similar for all versions. If you don't want to install the Juju client on your computer you can install it on a Ubuntu instance in RunAbove.

# Installation of Juju client:
Juju client is available for all Ubuntu versions starting from 12.04. On 12.04 however you need to enable the management of ppa with:

```
sudo apt-get install python-software-properties
```

Installing Juju client is as simple as:

```
sudo add-apt-repository ppa:juju/stable
sudo apt-get update && sudo apt-get install juju-core
```

# Juju configuration with Openstack credentials:

Now you need to tell Juju how to launch instances on your RunAbove account using the OpenStack API. To do so, retrieve your OpenStack credentials. They can be found in RunAbove expert manager under the "__Access & Security__"/"__API Access__" tab, download the RC file.

![](https://community.runabove.com/public/files/7eZ83Lg6GnPPP0ccKIUM.png)

Once the RC file is downloaded, you can execute it. It will prompt you for your RunAbove password. This will add the credentials and API information needed by Juju into your environment:

```
source openrc.sh
```

Then configure the basic behavior of Juju by running:

```
juju generate-config
```

A default configuration file will be written to ~/.juju/environments.yaml.Replace the content of it with this custom script.

```yaml
default: runabove

environments:
    runabove:
        type: openstack
        use-floating-ip: false
        use-default-secgroup: true
        network: "Ext-Net"
        region: "BHS-1"
        auth-mode: userpass
        default-series: precise

```

# Importing Ubuntu Cloud to your RunAbove account:
Now that your configuration is set, you are almost ready. You just need to upload to RunAbove the _Ubuntu Cloud Image_ that will be the base of all instances running your infrastructure. You should choose between Ubuntu 12.04 LTS (_precise_) and Ubuntu 14.04 LTS (_trusty_). As many charms are still written and tested for Ubuntu 12.04 it is the version you should use until Ubuntu 14.04 gets more supported charms.

To upload the image, go to RunAbove expert manager and in the "__Image__" tab click on "__Create Image__". You will be prompted for information about the image you want to upload. Just give it a name, select "__Raw__" as the format and add this URL as Image Location: https://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-amd64-disk1.img
You can leave the other parameters blank. Validate by clicking on "__Create image__" and wait a few seconds.

![](https://community.runabove.com/public/files/N3ZEuPNtiosfVVaUzDnh.png)

Now that you image is uploaded to RunAbove, click on its name to retrieve it's information. Get its ID and copy it.
![](https://community.runabove.com/public/files/XON819vXa9nAFuApt6Eu.png)

Tell Juju that it should use your freshly created image by issuing:

```
juju metadata generate-image -i <id-of-your-image>
```

This command creates two text files in ~/images/streams/v1/. Check that the version specified in these files match the version of Ubuntu that you have uploaded.

Next you have to upload to your RunAbove Object Store the tools needed by Juju for launching instances. Thanks to the OpenStack API, Juju will create a new container in your Object Store and provision it with the Juju tools.

```
juju sync-tools
```

# Deployment of Juju GUI:

__You are ready to rock!__
Launch your first node with:

```
juju bootstrap --metadata-source ~
```

You can setup the awesome Juju web interface by deploying your first charm:

```
juju deploy --to 0 juju-gui
juju expose juju-gui
juju status
grep admin ~/.juju/environments/runabove.jenv
```

This will deploy the charm juju-gui to your first instance, make it accessible from the Internet and display the IP address and the admin password to log in to the interface.
Just go to https://ip-of-instance and log in.

![](https://community.runabove.com/public/files/cfmh9SyjCImN3sm9P33t.png)

# Using charms:

From the web interface you can browse the charm store and drag and drop charms to the main panel. It will launch an instance and setup the charm on it. If you prefer to do it from the command line it is as simple as:

```
juju deploy mysql
```

## Tips:

If you want to destroy all the instances and services spawned by Juju you can execute:

```
juju destroy-environment runabove
```

Just note that the security groups created by Juju are not deleted by the above command, you should do it in the manager. You will be able to quickly recreate your infrastructure starting again the process from the _sync-tools_ command.

Now you are ready to quickly deploy big clusters in the cloud. You can start checking how easy it is to setup a [load balanced infrastructure](/kb/en/instances/deploy-load-balanced-wordpress.html) with Juju.