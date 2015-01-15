---
layout: post
title: "How to set up an IPv6 tunnel on Ubuntu 14.04"
categories: Instances
author: DrOfAwesomeness
lang: en
---
In this guide, I'll show you how to set up IPv6 on RunAbove instances using the free [Tunnelbroker](https://www.tunnelbroker.net) service from Hurricane Electric.

1. Preparing the tunnel
===

The first thing you'll need to do is create an account on the [Tunnelbroker Site](https://www.tunnelbroker.net/). After you have registered an account, click the "Create Regular Tunnel" button on the left side of the Tunnelbroker portal. Put the IP address of your RunAbove instance in the IPv4 Endpoint field and select a tunnel server from the list (I used the Toronto, ON, CA tunnel server when writing this tutorial.) Next, from your RunAbove control panel, edit your [Security Groups](https://cloud.runabove.com/horizon/project/access_and_security/?tab=access_security_tabs__security_groups_tab) (in OpenStack Horizon under "Access & Security") and allow all TCP traffic from the Tunnel Server IPv4 address (as displayed on the Tunnelbroker "Tunnel Details" page).

2. Connecting to the tunnel
===

Now that your tunnel has been set up, it's time to connect to it. To do so, SSH in to your RunAbove instance, open the /etc/network/interfaces file (`sudo nano /etc/network/interfaces`) and add the following at the end of the file:

```
auto he-ipv6
iface he-ipv6 inet6 v4tunnel
        address <HE Client IPv6 Address>
        netmask 64
        endpoint <HE Server IPv4 Address>
        local <RunAbove Instance IP>
        ttl 255
        gateway <HE Server IPv6 Address>
```
Be sure to replace `<HE Client IPv6 Address>`, `<HE Server IPv4 Address>`, and `<HE Server IPv6 Address>` with the appropriate information from your Tunnelbroker "Tunnel Details" page and `<RunAbove Instance IP>` with the IPv4 address of your RunAbove instance. Next, to bring the `he-ipv6` interface up, run the following command:

```bash
sudo ifup he-ipv6
```

Your instance now has IPv6 connectivity! Your IPv6 address is the "Client IPv6 Address" shown on the Tunnelbroker "Tunnel Details" page. If you'd like to test your IPv6 connectivity, you can ping Google's IPv6 server with `ping6 ipv6.google.com`. If you don't get any errors, Congrats! If you run into problems or want to learn more about Tunnelbroker, be sure to check out the Tunnelbroker Section of the Hurricane Electric IPv6 [FAQ](https://ipv6.he.net/certification/faq.php).
