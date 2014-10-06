---
layout: post
title: "Create and use SSH keys"
categories: Instances
author: NicolasLM
---

SSH keys are a safer alternative to passwords when it comes to authenticating 
to a remote server. Sysadmins tend to love them because they allow to 
administrate servers without remembering thousands of passwords. This guide 
will explain how to generate and use them.

What are SSH keys?
-------------------

SSH keys work in pairs, one key can be shared with anyone, the other one must 
be kept secret. To authenticate to a remote server you put your public key on 
the server and gain access to it using your private key.

As the private key shall always remain private it is common to encrypt it using 
a passphrase. It prevents a bad guy from using your private key if your 
computer get stolen.

How to generate them?
---------------------

### Linux and Mac OS X

Before generating a pair of SSH keys, check that you do not have one already.  
Open a terminal and type:

    ls ~/.ssh

If you see two file named `id_rsa` and `id_rsa.pub` you already have SSH keys 
and can skip the generation. The files can also be called `id_dsa` and 
`id_dsa.pub` depending on the encryption algorithm.

To generate a pair of keys use the `ssh-keygen` command:

    ssh-keygen -b 4096 -t rsa

You will be asked where to save the keys, the default value is a good choice, 
and for a passphrase. The later is not mandatory but recommended, it adds a lot 
of security if someone gets access to your machine.

Starting from now you have a pair of SSH keys:

* `~/.ssh/id_rsa` is your private key
* `~/.ssh/id_rsa.pub` is the public key that goes to remote servers

### Windows

On Windows you can generate SSH keys with a program called 
[PuTTYgen](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html).  
Download it and run it. Click on `Generate` and move your mouse on the window 
to generate entropy used to craft a truly random key.

![PuTTYgen SSH key](/kb/images/2014-10-01-create-ssh-keys/puttygen.png)

When the process is finished copy the public key displayed in a file. Save the 
private key on your computer, you will need it to connect to a server.

Adding your SSH key to RunAbove
-------------------------------

Once you have your keys, go to the RunAbove dashboard and add an SSH key. Give 
it a name and copy/paste the public key in the form. This key will be available 
to be integrated in the instances you launch from now on.

Launching an instance
---------------------

When you launch an instance choose the SSH key you have just added. This will 
allow you to remotely connect to the instance without password. Once the 
instance is booted, grab the IP address from the dashboard and connect to it.

### Linux and Mac OS X

On Linux and Mac OS X you have nothing more to do, just open a terminal and:

    ssh admin@<IP of the instance>

### Windows

If you connect from Windows with PuTTY you need to tell PuTTY to use your 
private key. This can be done in `SSH` > `Auth`, select your private key file:

![PuTTY Private SSH key](/kb/images/2014-10-01-create-ssh-keys/putty.png)

Go back to the `Session` tab, paste the IP address of your instance and press 
`Open`. Log in as `admin` and you get a shell without entering any password.

