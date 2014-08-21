---
layout: post
title:  "How to use vagrant with Openstack?"
categories: Instances
author: Jean Sébastien Bruneau
lang: en
---

Can this be done? Yup!
(you do need a recent fully functioning vagrant installation but if you are here, chances are that you do. If not, head to [http://www.vagrantup.com/](http://www.vagrantup.com).

# Prerequisites:

Get started, practice spining up local machine and get enlightened! Once you are done, keep on reading)

First, setup an ssh key via the runabove control panel. We will need that to connect into the instance once it's setup.

In expert mode, under __Access & Security__, then under __Key Pairs__ and finally clicking the import Key Pair button gives instruction on how to generate and import a key.

![](http://getoutofthecube.com/public/runabove-vagrant/1.PNG)

# Vagrant installation

Next, hit [https://github.com/cloudbau/vagrant-openstack-plugin](https://github.com/cloudbau/vagrant-openstack-plugin). The doc should get you going pretty fast. Only 2 commands are needed:

```
vagrant plugin install vagrant-openstack-plugin
vagrant box add dummy https://github.com/cloudbau/vagrant-openstack plugin/raw/master/dummy.box
```

Once you are done, it's time to build a Vagrantfile, you can use this as a starting point:

```
Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  # Make sure the private key from the key pair is provided
  config.ssh.private_key_path = "/path/to/your/id_rsa"

  config.vm.provider :openstack do |os|
    os.username     = "[your-runabove-username]"
    os.api_key      = "[yourS3cre7pa55w0rd]"
    os.flavor       = /[name-of-the-instance-model]/
    os.image        = /[name-of-the-desired-os]/
    os.endpoint     = "https://auth.runabove.io/v2.0/tokens"
    os.keypair_name = "[name-of-the-key-you-uploaded]"[/

    os.ssh_username = "admin"
    os.network      = "Ext-Net"
  end
end
```

Replace everything between the tags [] with your information (including the square braquets, you don't need them). Don't forget to add your provisioner stuff in there. You probably want to use a shell provisioner to bootstrap your favorite DevOps tool.

# And deploy vagrant inside openstack

Once you are happy with the configuration simply do a:

```
vagrant up --provider=openstack
```

Well that's it! you now have a very powerfull dev box!