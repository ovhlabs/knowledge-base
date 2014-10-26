---
layout: post
title: "How to setup a LAMP on Debian 7"
categories: Instances
author: Leo Pizzolante
lang: en
---
[Vesta Control Panel](http://vestacp.com/) is an open source hosting control panel. It provides a Web Server, DNS server
,Database Server, Mail Server and an FTP Server.

1. Installing VestaCP
================
Installing VestaCP is a very simple process and takes less than 5 minutes to complete. To setup VestaCP, you'll need to be superuser:

```bash
sudo su
```

After this, you have to download the VestaCP install script on your own instace:

```bash
wget http://vestacp.com/pub/vst-install.sh
```

And finally, you can start the installation process with: 

```bash
bash vst-install.sh --force
```
* `--force` is required, because you already have an admin user.

Ok! Now you have installed the VestaCP, and can see something like:

```bash
 _|      _|  _|_|_|_|    _|_|_|  _|_|_|_|_|    _|_|   
 _|      _|  _|        _|            _|      _|    _| 
 _|      _|  _|_|_|      _|_|        _|      _|_|_|_| 
   _|  _|    _|              _|      _|      _|    _| 
     _|      _|_|_|_|  _|_|_|        _|      _|    _| 


-------------------------------
  https://youristanceip:8083
  username: admin
  password: yourpassword
-------------------------------

```


2. Firewall rules
================
Now you have to go back on Runabove panel and edit the Security Group of your istance.
To do this, you have to go in Expert Mode, Access & Security and click Edit Rules over the group associated.
Now, you have to Add Rule with the 8083 port (web interface)
![Add Rule](/kb/images/2014-20-26-how-to-setup-a-lamp-on-debian-7/rule_port_ingress.png)
If you need ftp, etc. have to do the same with other ports.

Congratulations, now you can see your Vesta Control Panel at https://youristanceip:8083

You can find more information: http://vestacp.com/docs/