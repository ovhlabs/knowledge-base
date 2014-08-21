---
layout: post
title:  "How to configure 'Remote Desktop' on your Windows Instance?"
categories: Instances
author: VincentCasse
lang: en
---

You already have a Windows instance, but you want remote desktop access directly within your account. You need to open a port inside the firewall and configure Windows to authorize RDP access. What is RDP? A Windows protocol for sharing desktop screens between machines over the internet. With this protocol, you can control other computers or servers in the same way as with your own personal machine.

If you don't have a Windows instance, you should read "[how to create a Windows instance?](/kb/en/instances/how-to-create-a-windows-instance.html)"

# Open RDP port in firewall

Your instance is protected by an external firewall. By default, only ports 80 (HTTP) and 443 (HTTPS) are open and you need to open port 3389 to authorize the RDP protocol. The firewall rules can be edited in expert mode, using the manager, under the _Access & Security_ tab.

If you haven't replaced your security group since your instance was launched, your security group will be _default_.

 * Click on _Edit Rules_
 * Then on _Add Rules_
 * Choose _RDP_ inside Rule field.

By default, port 3389 will be open to the entire internet and you can limit it to a specific IP. For example, if you want to limit access to the IP 127.0.0.1, simply enter 127.0.0.1/32 in CIDR field.

![Control panel screenshot](https://community.runabove.com/public/files/taBGpST1Y4zvfPEEs66y.png)

# Authorize RDP access inside a Windows instance

Launch your Windows instance and open a console. To configure the RDP access, open the _Server Manager_ and click on _Local Server_ in the left-hand menu. You will see the _Remote Desktop_ status and if it's disabled, click on it to edit the configuration.

Choose _Allow remote connections to this computer_. If your RDP client doesn't use Network Level Authentication, or if this feature is not available on your network, be sure the field _Allow connections only from computers running Remote Desktop with Network Level Authentication_, is not selected.

# Open an RDP client

You can now open your favorite RDP client. On Linux, you could use rdesktop.

```bash
rdesktop 127.0.0.1
```