---
layout: post
title: "How To Install OpenVPN Access Server on Ubuntu 14.04"
categories: Instances
author: neoark
---
----------
Introduction
------------

OpenVPN is a Virtual Private Networking (VPN) solution provided in the Ubuntu Repositories. It is flexible, reliable and secure. It belongs to the family of SSL/TLS VPN stacks (different from IPSec VPNs).

OpenVPN Access Server as described on Official website – is a full featured SSL VPN software solution that integrates OpenVPN server capabilities, enterprise management capabilities, simplified OpenVPN Connect UI, and OpenVPN Client software packages that accommodate Windows, MAC, and Linux OS environments.  OpenVPN Access Server supports  a wide range of configurations, including secure and granular remote access to internal network and/ or private cloud network resources and applications with fine-grained access control.

Step 1: Download and Install Latest Version
-------------------------------------------

**32bit OS**

    $ wget http://swupdate.openvpn.org/as/openvpn-as-2.0.10-Ubuntu14.i386.deb
    $ sudo dpkg -i openvpn-as-2.0.10-Ubuntu14.i386.deb
   
  **64bit OS**

    $ wget http://swupdate.openvpn.org/as/openvpn-as-2.0.10-Ubuntu14.amd_64.deb
    $ sudo dpkg -i openvpn-as-2.0.10-Ubuntu14.amd_64.deb

Step 2: Set OpenVPN AS Admin Password
-------------------------------------

    $ sudo passwd openvpn

Step 3: Log into OpenVPN Access Server Admin Page
-------------------------------------------------

    https://"server ip":943/admin

Note: Make sure to open the correct ports in the instance ***Security Group*** via ***Access & Security***.

 - Enter username and password (See Screenshot Below):

![Login Page](http://i.imgur.com/6Jbt5ce.jpg)

Step 4: Configuring OpenVPN-AS Settings
-------------------------------------------

If you want the OpenVPN Access Server to be reachable from the internet you will need to set the Hostname or IP address to a hostname or IP that is facing the public internet. Please refer to the screenshot below:

![Server Network Settings](http://i.imgur.com/GO30szy.jpg)

**VPN Settings:**
The VPN Settings page allows you to configure options like the Dynamic IP Address Network which is OpenVPN Access Server's internal DHCP system. By default the subnet is set to "5.5.0.0/20" this can be changed to a subnet that might work better for your current network.

The routing section gives the option to push certain routes to networks the OpenVPN Access Server is sitting on to remote clients.
There is also an option that allows client internet traffic the ability to be forwarded through the OpenVPN Access Server.

**User Permissions:**
The User Permissions page allows settings per client to be changed. The auto-login profile can be enabled if desired. When you click "show" next to the username you will see more options that can be configured, this is the area where you would define settings for a gateway client: 

![User Permissions](http://i.imgur.com/fL4Tnc5.jpg)

Step 5: Connect to OpenVPN
---------------------------------
**Access the URL:**

    https://"server ip":943/

Users have the option to either Connect to the VPN or Login to the Connect Client. When connecting the user will be connected to the VPN directly through their web browser. When the user decides to login to the Connect Client they can downoad their user configuration files (client.ovpn) and use them to connect to the VPN with other OpenVPN Clients.

FAQ
---

 1. Pricing
	- All OpenVPN Access Server downloads come with 2 free client connections for testing purposes.
For more information about pricing visit: [Pricing](https://openvpn.net/index.php/access-server/pricing.html)

 2. OpenVPN Community Edition vs OpenVPN Access Server
![OpenVPN Comparison](http://i.imgur.com/THQaYNm.png)

 3. To Install SSL Certificates please see: [CA](https://openvpn.net/index.php/access-server/docs/admin-guides/175-how-to-replace-the-access-server-private-key-and-certificate.html)

----------


**If you require a more in depth explanation of certain features of the overall operations of the OpenVPN Access Server please refer to the OpenVPN Access Server Systems Administrator Guide which can be found on the following page: http://openvpn.net/index.php/access-server/docs.html**
