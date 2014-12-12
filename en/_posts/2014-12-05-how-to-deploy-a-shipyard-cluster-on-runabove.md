---
layout: post
title: "How to deploy a Shipyard cluster on RunAbove"
categories: Instances
author: DrOfAwesomeness
lang: en
---
**[Shipyard](http://shipyard-project.com/)** is a [Docker](https://docker.com) cluster administration tool. It provides a Web UI to simplify managing Docker containers across multiple nodes and a simple orchestration system to help control where a container will land when you create it. In this tutorial, you'll learn how to set up a Shipyard controller and a single Docker node, or "engine" in Shipyard terminology, linked over an internal network.

## Prerequisites
* An understanding of the linux command-line
* A basic grasp of how to use the Expert Mode control panel (this tutorial will assume you're using it)
* A basic grasp of what Docker does and how to use it
* A security rule allowing ingress traffic from everywhere on port 8080

## Private Network
In this tutorial, we'll be using a private network for the traffic between the controller and the engine. Go ahead and create a private network from the Expert Mode control panel with the settings below.

* Name: (Whatever you want, I used "Int-Net")
* Create Subnet: Yes
* Subnet Name: (Whatever you want, I used "Shipyard")
* Network Address: 10.8.0.0/24
* IP Version: IPv4
* Gateway IP:  [blank]
* Disable Gateway: Yes
* Enable DHCP: No

## Setting up the controller
Create a new instance with Ext-Net as NIC 1 and Int-Net (or whatever you named the private network) as NIC 2. After it has been created, SSH into it. The first thing we are going to do is update the system and install Docker:

```bash
sudo apt update
sudo apt upgrade
curl -sSL https://get.docker.com/ubuntu/ | sudo bash
```

Using your favorite command-line editor, such as nano or vim, open /etc/network/interfaces as root and put the following at the end of the file:

```
auto eth1
iface eth1 inet static
    address <controller internal IP as shown on your dashboard>
```
Then bring up the eth1 interface with `sudo ifup eth1.`
After you've configured the network, you'll need to set up the database. Shipyard uses RethinkDB, which you can deploy with the following commands:

```bash
sudo docker run -d --name rethinkdb -v /var/lib/rethinkdb:/data shipyard/rethinkdb
```
Once you've deployed RethinkDB, you can deploy the Shipyard controller with the following command:

```bash
sudo docker run -d --name shipyard --link rethinkdb:rethinkdb -p 8080:8080 shipyard/shipyard
```
Now browse to `http://your-controller-ip:8080` in your web browser, replacing `your-instance-ip` as necessary. If everything worked, you should see something like this:
 ![Shipyard 
 Login](/kb/images/2014-12-05-how-to-deploy-a-shipyard-cluster-on-runabove/shipyard-login.png)

The default username is **admin** and the default password is **shipyard**. To change the admin password, you'll need to start a Shipyard CLI container and use the Shipyard command-line client to login and update your password as shown below:

 ```
 sudo docker run -ti --rm --link shipyard:shipyard shipyard/shipyard-cli
 shipyard cli> shipyard login
 URL: http://shipyard:8080
 Username: admin
 Password: [type the current password, 'shipyard' in this case]
 shipyard cli> shipyard change-password
 Password: [type your new password]
 Confirm: [retype your new password]
 shipyard cli> [CTRL-D]
 ```
 
## Setting up the engine
Now that you've configured the Shipyard controller, it's time to set up the engine node. An engine is simply a Docker daemon that the controller connects to and manages containers on. Go ahead and create a new instance with Ext-Net as NIC 1 and the internal network as NIC 2. As with the controller, the first thing we're going to do is update the system and install Docker.

```
sudo apt update
sudo apt upgrade
curl -sSL https://get.docker.com/ubuntu/ | sudo bash
```
Next, as with the controller, we need to set up the internal network on this instance. Open /etc/network/interfaces as root in your favorite editor and append the following lines:

```
auto eth1
iface eth1 inet static
    address <engine internal IP as shown on your dashboard>
```
Once you've added these lines to the end of /etc/network/interfaces, run `sudo ifup eth1`. Now that the internal network is configured on the instance, open /etc/default/docker as root in your favorite editor and append the following line:

```
DOCKER_OPTS="-H tcp://<engine internal IP as shown on your dashboard>:8888"
```
This will tell Docker to listen on the instance's internal IP address so that the controller can connect to it. Once you've made this change, you'll need to restart Docker by running `sudo service docker restart`

## Adding the engine to the controller
Now that you've configued the engine, it's time to add it to the controller. To do so, visit `http://your-controller-ip:8080` and log in with the password you set earlier. Once signed in, switch to the Engines tab and click the Add button. Fill in the from that appears with the appropriate information, using `http://your-engine-internal-ip:8888` as the Address. You can leave the SSL-related fields, such as "CA Certificate", blank.

Congratulations, you now have your very own single-engine Shipyard cluster! You can deploy containers via the Containers tab in the Shipyard web interface. If you want to add more engines, simply repeat the "Setting up the engine" and the "Adding the engine to the controller" steps. If you want to learn about Shipyard, take a peek at the [Shipyard Documentation](http://shipyard-project.com/docs/). Enjoy your small (but scalable) cluster!
