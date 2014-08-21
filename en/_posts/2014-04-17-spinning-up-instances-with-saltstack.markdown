---
layout: post
title:  "Spinning up instances with saltstack / salt-cloud"
categories: Instances
author: Jean Sébastien Bruneau
lang: en
---

There are quite a few devops tools out there, i like saltstack and thanks to the openstack backend of runabove, you can spin up instances with salt-cloud!

You need to have salt, libcloud and salt-cloud installed, i am running these versions.
```
jsb@dev:/etc/salt$ salt-cloud --versions-report
            Salt: 2014.1.0-4765-gcbe7c7e
            Python: 2.7.3 (default, Feb 27 2014, 19:58:35)
            Jinja2: 2.6[
            M2Crypto: 0.21.1
            msgpack-python: 0.1.10
            msgpack-pure: Not Installed
            pycrypto: 2.4.1
            PyYAML: 3.10
            PyZMQ: 13.0.0
            ZMQ: 3.2.2
            Apache Libcloud: 0.14.1
```

Check the official doc if you need setup instruction for salt and salt-cloud.
Once that's done, you need to setup a provider. I created the following YAML file

```yaml
runabove:
  identity_url: https://auth.runabove.io/v2.0/tokens
  compute_name: nova
  compute_region: #THE-REGION#
  service_type: compute
  tenant: '#THE-TENANT#'
  user: '#your-email@test.tld#'
  password: #S3cr37Pa55w0rd#
  provider: openstack
  networks:
    - fixed:
    - #NETWORK-UUDI#
```

Everything that's wrapped in "#" needs to be configured for your account, here is how to get the information. First, get some command line tools:

```
sudo pip install python-novaclient.
```

Once that's done, go in the manager, in expert mode, under __Access & Security__ and finally under __API Access__. Download the __OpenStack RC file__. Save it on your box, source it and enter your password. It's safe it comes from runabove.

```
source /home/jsb/openstackrc
Please enter your OpenStack Password:
```

Now we are ready to gather the information to complete de provider setup:

 * #THE-REGION#:  run "nova endpoints". In the nova table you will find the region, mine looks like "BHS-1"
 * #THE-TENANT#:  run "nova credentials", at the end of the table, you should see "name": "00000000" where 000000 is a bunch of number. This can also be seen in the manager, under current project. Make sure this is between quotes in your config file or it will not work.
 * #NETWORK-UUDI#: run "nova network-list" and grab what's in the id column, that will be your static network. In my case, there is only one and it's labelled "Ext-Net".

Once that's done, the only thing left is to create vm image profiles. Im using these:

```
cat cloud.profiles.d/runabove.conf
high-cpu:
  provider: runabove
  size: pci2.d.c1
  deploy: False

high-mem:
  provider: runabove
  size: pci2.d.r1
  deploy: False

ubuntu-lts:
  image: Ubuntu 12.04
  extends: high-cpu
```

You can run nova flavor-list to see what size are available and nova image-list for the OS. In both case, the configuration is expecting what's in the Name column.

Once you are all set, spin up a new instance:

```
salt-cloud -p #the-cloud-profile-you-chose# #the-instance-name#
```

Happy automated deployment folks!