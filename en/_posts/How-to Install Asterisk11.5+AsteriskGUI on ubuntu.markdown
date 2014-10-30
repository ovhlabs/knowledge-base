---
layout: post
title:  "How-to Install Asterisk11.5+AsteriskGUI on ubuntu"
categories: Instances
author: rami84
lang: en
---


#I will show you how to install Asterisk server + AsteriskGUI on Ubuntu 12.04 with very easy steps

--------

##1- First step

After login as Admin I created a root password with this command(or you can add sudo before all commands):
 
admin@asterisk:~$ sudo passwd root

Now login as root

admin@asterisk:~$ su

Enter password you created for root then

root@asterisk:/home/admin# cd

root@asterisk:~# apt-get update && apt-get upgrade

root@asterisk:~# apt-get install build-essential wget libssl-dev libncurses5-dev libnewt-dev libxml2-dev linux-headers-$(uname -r) libsqlite3-dev uuid-dev

--------

##2- install Asterisk 

root@asterisk:~# cd /usr/src/

root@asterisk:/usr/src# wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-1.4.14.tar.gz

root@asterisk:/usr/src# wget http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-11.5.0-rc1.tar.gz

root@asterisk:/usr/src# wget http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-sounds-1.2.1.tar.gz

root@asterisk:/usr/src# wget http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-addons-1.6.2.4.tar.gz



root@asterisk:/usr/src# tar -xzf libpri-1.4.14.tar.gz

root@asterisk:/usr/src# tar -xzf asterisk-11.5.0-rc1.tar.gz

root@asterisk:/usr/src# tar -xzf asterisk-sounds-1.2.1.tar.gz

root@asterisk:/usr/src# tar -xzf asterisk-addons-1.6.2.4.tar.gz

--------

###libpri

root@asterisk:/usr/src# cd libpri-1.4.14

root@asterisk:/usr/src/libpri-1.4.14# make

root@asterisk:/usr/src/libpri-1.4.14# make install

root@asterisk:/usr/src/libpri-1.4.14# cd ..

###asterisk

root@asterisk:/usr/src# cd asterisk-11.5.0-rc1

root@asterisk:/usr/src/asterisk-11.5.0-rc1# ./configure

root@asterisk:/usr/src/asterisk-11.5.0-rc1# make menuconfig

root@asterisk:/usr/src/asterisk-11.5.0-rc1# make

root@asterisk:/usr/src/asterisk-11.5.0-rc1# make install

root@asterisk:/usr/src/asterisk-11.5.0-rc1# make samples

root@asterisk:/usr/src/asterisk-11.5.0-rc1# make config

root@asterisk:/usr/src/asterisk-11.5.0-rc1# cd ..

###asterisk-sounds

root@asterisk:/usr/src# cd asterisk-sounds-1.2.1

root@asterisk:/usr/src/asterisk-sounds-1.2.1# make install

root@asterisk:/usr/src/asterisk-sounds-1.2.1# cd ..

###asterisk-addons

root@asterisk:/usr/src# cd asterisk-addons-1.6.2.4

root@asterisk:/usr/src/asterisk-addons-1.6.2.4# ./configure

root@asterisk:/usr/src/asterisk-addons-1.6.2.4# make

root@asterisk:/usr/src/asterisk-addons-1.6.2.4# make install

root@asterisk:/usr/src/asterisk-addons-1.6.2.4# cd ..


root@asterisk:/usr/src# service asterisk start

--------

##3- Install AsteriskGUI

root@asterisk:/usr/src# wget http://downloads.asterisk.org/pub/telephony/asterisk-gui/asterisk-gui-2.1.0-rc1.tar.gz

root@asterisk:/usr/src# tar -xzf asterisk-gui-2.1.0-rc1.tar.gz

root@asterisk:/usr/src# cd asterisk-gui-2.1.0-rc1

root@asterisk:/usr/src/asterisk-gui-2.1.0-rc1# ./configure

root@asterisk:/usr/src/asterisk-gui-2.1.0-rc1# make

root@asterisk:/usr/src/asterisk-gui-2.1.0-rc1# make install

root@asterisk:/usr/src/asterisk-gui-2.1.0-rc1# nano /etc/asterisk/manager.conf

####*change it to look like this (remove any ";" )*

#####[general]

#####enabled = yes

#####webenabled = yes

#####port = 5038

#####bindaddr = 0.0.0.0

####[admin]

#####secret = (the password that you will use in login)

#####read = system,call,log,verbose,command,agent,user,config

#####write = system,call,log,verbose,command,agent,user,config


root@asterisk:/usr/src/asterisk-gui-2.1.0-rc1# nano /etc/asterisk/http.conf

####*change it to look like this (remove any ";" )*

#####[general]

#####enabled=yes

#####bindaddr=0.0.0.0

#####enablestatic=yes


root@asterisk:/usr/src/asterisk-gui-2.1.0-rc1# make checkconfig

root@asterisk:/usr/src/asterisk-gui-2.1.0-rc1# /etc/init.d/asterisk restart


**Now in Runabove control panel you'll need to switch into Expert Mode and edit your Security 
Group to allow ports TCP 8088, 5060 & 5038, UDP 5060 & 10000:10100**


Paste this in your browser (replace x.x.x.x with your instance IP):

http://x.x.x.x:8088/static/config/cfgbasic.html

user=admin & password= (secret that you choose in manager.conf)

###Now all is done and you can configure your Asterisk server**

##Have Fun

