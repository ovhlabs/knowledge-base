---
layout: post
title:  "How to install the Codebox IDE on Ubuntu 14.04"
categories: Instances
author: DrOfAwesomeness
lang: en
---

The [Codebox IDE](https://github.com/CodeboxIDE/codebox) is the open-source 
component of the [Codebox](https://www.codebox.io/) Cloud IDE service. It 
provides developers with a cloud-based development code editor, terminal, and 
file manager. This tutorial will show you how to set up the Codebox IDE on 
Ubuntu 14.04.

##1. Set up Node.js
The Codebox IDE is written in Node.js, so we'll need to install the Node.js 
runtime. The version of Node.js in the Ubuntu repositories is outdated, so 
we'll be using the Nodesource repository to install Node.js. Note that we're 
also installing the `build-essential` and `git` packages, as they are Codebox 
IDE dependencies.

```bash
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install -y nodejs build-essential git
```

## 2. Install and run the Codebox IDE
Now that we have Node.js, it's time to install and run the Codebox IDE. First, 
we need to install the `codebox` package with npm:

```bash
sudo npm install -g codebox
```

Next, since it's not a good idea to run the IDE as the `admin` or `root` user 
(IDE users have terminal access), we'll add a user for it:

```bash
sudo adduser --disabled-password --gecos "Codebox IDE" codebox
```

Finally, we'll set up our workspace and run the Codebox IDE:

```bash
sudo -u codebox -i
mkdir -p Workspace/your_project_name # or git clone <url> Workspace/your_project_name
git init Workspace/your_project_name # skip this if you cloned from a git repository in the last command
codebox run Workspace/your_project_name
```

Your IDE is now available at `http://your-instance-ip:8000`. If you are using 
the default RunAbove firewall settings, you'll need to allow traffic on port 
8000.

From OpenStack Horizon, click on "Access & Security", and add a rule to the 
default security group allowing ingress traffic to port 8000. Note that your 
instance is currently open to the public. If you want to password-protect your 
IDE, you can specify usernames and passwords as shown below.

```bash
# Run this as the codebox user
codebox run Workspace/your_project_name -u user1:passwd1,user2:passwd2
```

**SECURITY NOTE:** The Codebox IDE currently does not provide a way to hash 
passwords or hide them from the output of `ps ux`. Because of this, you should 
use a unique, secure password to access the IDE. Additionally, if you are using 
the Codebox IDE in a multi-user environment, you may want to avoid the internal 
user system altogether and set up an authenticating reverse proxy.

If you don't want to leave your SSH window open the whole time the Codebox IDE 
is running, you can run it in the background using `nohup`:

```bash
# Run this as the codebox user
nohup codebox run Workspace/your_project_name -u user1:passwd1,user2:passwd2 &
```

Congratulations! You have now installed and configured the Codebox IDE. If you 
want to learn more about configuring and using the Codebox IDE, be sure to 
check out the articles under the "Codebox IDE" section of the [Codebox Help 
Site](http://help.codebox.io/).

