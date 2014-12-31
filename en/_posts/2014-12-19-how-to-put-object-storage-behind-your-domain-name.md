---
layout: post
title:  "How to put Object Storage behind your domain name?"
categories: Object-Storage
author: ArnaudJost
lang: en
---

In this guide, you will discover how to configure a new DNS record from your DNS provider to serve data from RunAbove Object Storage.

When you have some objects stored in OpenStack Object Storage, you can allow everyone to access your data. This is a good solution to share files on the Internet. The down side is that you have to give your friends a long url that is difficult to remember, you may also want to put some static files used by your website in Object Storage but without having to use another domain than your sites main domain. Thanks to domains names you can set a custom URL to give access to your files over the Web.

Prerequisites
-------------

* A valid container on your RunAbove account
* A domain name, and administrator access to its zone


How it works, the theory
------------------------

When a HTTP request comes to OpenStack Object Storage, the header host variable is checked. If it differs from the current infra hostname, the system considers it as a mapped entry, and makes a DNS request to get the whole DNS entry matching with the given host. If a DNS entry is found, the answer is split to extract container, account and object requested, then the request is rewritten. Be sure that your client correctly sets the host header value, otherwise RunAbove Object Storage will not be able to detect and process your request.

HTTP and HTTPS
--------------

The feature works well using HTTP. However you will have a certificate error if you use HTTPS (as we don't have your private certificate). You can still use HTTPS, but you will get a warning in most browsers and about the certificate.

CNAME or TXT record?
--------------------

You have two choices for the DNS record, please use only one method:

- CNAME: it's the default and historical record. Please use it if you can manage your DNS zone. It will follow our endpoint IPs automatically if they change.
- TXT: use it if you need to configure your subdomain on anything else (for example, behind a CDN like Cloudflare). Please be careful to follow RunAbove endpoint IPs, or use 'virtual' CNAME if your CDN provider offers it.

Configure the CNAME on your DNS provider
----------------------------------------

Choose a subdomain (like 'static.mydomain.com', choose type 'CNAME', then add the target following the rule explained below.

The `CNAME` must match some rules to be understood by RunAbove Object Storage. You must change `{VARIABLE}` to the corresponding value:

    {CONTAINER_NAME}.{ACCOUNT_NAME}.storage.{SBG1|BHS1..}.runabove.io

For example, if I want to set a CNAME for a container named `web` on my account `AUTH_1337` to be used at BHS-1, it will be:

    web.auth-1337.storage.bhs-1.runabove.io

Your DNS provider will now have a new entry for your domain, like:

    static IN CNAME web.auth-1337.storage.bhs-1.runabove.io.

Configure the TXT on your DNS provider
--------------------------------------

Choose type `TXT`, then add the target following the rule explained below.

The `TXT` entry must match some rules to be found by Runabove Object Storage.

    '_swift-remap.' + subdomain

For example, if I want to use 'static.mydomain.com', it will be:

    _swift-remap.static

The TXT content must match some rules to be understood by RunAbove Object Storage. You must change `{VARIABLE}` to the corresponding value:

    {CONTAINER_NAME}.{ACCOUNT_NAME}.storage.{SBG1|BHS1..}.runabove.io

For example, if I want to set a TXT for a container named `web` on my account `AUTH_1337` to be used at BHS-1, it will be:

    web.auth-1337.storage.bhs-1.runabove.io

Your DNS provider will now have a new entry for your domain, like:

    _swift-remap.static IN TXT web.auth-1337.storage.bhs-1.runabove.io.

If you want don't want to use a subdomain it will look like:

    _swift-remap IN TXT web.auth-1337.storage.bhs-1.runabove.io.

Last step to use TXT records it adding a A record that matches RunAbove IP, you 
can get them with:

    dig storage.sbg-1.runabove.io
    dig storage.bhs-1.runabove.io

Note
----

* You cannot use the character dot `.` in the container name
* Depending on your DNS provider, you may have to replace '-' in AUTH-ABCD by a '_'. Both of them are detected by RunAbove Object Storage.

Conclusion
----------

You're done! You can now serve objects from RunAbove infrastructure using your own domain name.

Please note that you still have to give your token. If you want, you can distribute public content and you can also [configure your container as 'static-web'](/kb/en/object-storage/how-to-distribute-static-content-with-object-storage.html) and use your container as a website.
