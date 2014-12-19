---
layout: post
title:  "How to put Object Storage behind your domain name?"
categories: Object-Storage
author: ArnaudJost
lang: en
---

When you have some objects stored on Openstack Object Storage, you can set the ACL to allow everyone to access your data. This is a good solution to share files on the Internet. The down side is that you have to give your friends a long url that is difficult to remember. You may also want to put some static files used by your website on Openstack Object Storage, but without having to use another domain than your sites main domain.

In this guide, you'll discover how to configure a new DNS entry from your DNS provider to use it as an entry point to a container on your Runabove account.

## You have two choices for the dns entry(please only only one method!):
- CNAME: it's the default and historical entry. Please use it if  you can. It will follow our endpoint ips automatically if they change.
- TXT: use TXT if you need to configure your subdomain on anything else (for example, behind a CDN). Please be carefull to follow Runabove endpoint ips, or use 'virtual' CNAME if you CDN provider offers it.

## Warning:

This feature works well using http, but you will have a certificate error if you try to use https (of course, we don't have your private certificate!). You can still use https, but you'll get a warning in most navigators and http clients about the certificate.

Prerequistes:
--------------

* A valid container on your Runabove account
* A domain name, and administrator access on it

How it works:
--------------

When a HTTP request come to Openstack Object Storage, the header host variable is checked. If it differs from the current infra hostname, the system considers it as a mapped entry, and make a DNS request to an external DNS to get the whole dns entry matching with the given host. If a dns entry is found, the answer is split to extract container, account, and object requested, then request is rewritten. Be sure that your client correctly sets the host header value, otherwise Runabove Object Storage will not be able to detect and process your request.

To configure a new DNS entry, you have to use the full DNS entry given by your DNS provider.

Configure the CNAME on your DNS provider:
----------------------------------------------

Choose a subdomain (like 'static.mydomain.com', choose type 'CNAME', then add the target following the rule explained below.

The CNAME must match some rules to be understood by Runabove Object Storage. Format is (you should change {VARIABLE} by the corresponding value):

``` {CONTAINER_NAME}.{ACCOUNT_NAME}.storage.{SBG1|BHS1..}.runabove.io ```

For example, if I want to set a CNAME for a container named "web" on my account AUTH_1337 to be used at BHS, it will be:

``` web.auth-1337.storage.bhs-1.runabove.io ```

Your DNS provider will now have a new entry for your domain, like:

``` static IN CNAME web.auth-1337.storage.bhs-1.runabove.io ```

Configure the TXT on your DNS provider:
----------------------------------------------

Choose type 'TXT', then add the target following the rule explained below.

The TXT entry must match some rules to be found by Runabove Object Storage.
``` '_swift-remap.' + subdomain ````

For example, if I want to use 'static.mydomain.com', it will be:

``` _swift-remap.static ```

The TXT content must match some rules to be understood by Runabove Object Storage. Format is (you should change {VARIABLE} by the corresponding value):

``` {CONTAINER_NAME}.{ACCOUNT_NAME}.storage.{SBG1|BHS1..}.runabove.io ```

For example, if I want to set a CNAME for a container named "web" on my account AUTH_1337 to be used at BHS, it will be:

``` web.auth-1337.storage.bhs-1.runabove.io ```

Your DNS provider will now have a new entry for your domain, like :

``` _swift-remap.static IN TXT web.auth-1337.storage.bhs-1.runabove.io ```


Note:
------
* You cannot use dot in container name
* Depending on your DNS provider, you should have to replace '-' in AUTH-ABCD by a '_'. Both of them are detected by Runabove Object Storage.

Conclusion :
------------

You're done! You can now get object from your container using your own domain name.

Please note that you still have to give your token. If you want, you can to distribute public content and you can also configure your container as 'static-web' and open your container as a website!
