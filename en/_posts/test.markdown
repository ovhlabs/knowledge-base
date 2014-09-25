---
layout: post
title: "How To Relay Postfix mails via smtp.gmail.com on Ubuntu 14.04"
categories: Instances
author: neoark
---
**Introduction**:
-------------
--------------------------------------
This guide will help you to use a Gmail account as a free SMTP server on your Ubuntu-Linux server 14.04. Once configured, all emails from your server will be sent via Gmail. This method will be useful if you have many sites on your server and want them all to send emails via Gmail’s SMTP server. Please  Limits [Google's Sending](https://support.google.com/a/answer/166852?hl=en) to see the amount of mail one user can send.
**Steps:**
-------
-------------------------------------------
Install all necessary packages:

    $ sudo apt-get install postfix mailutils libsasl2-2 ca-certificates libsasl2-modules nano

Postfix configuration wizard will ask you some questions. Just select your server as ***Internet Site*** and for FQDN use something like ***mail.your_domain.com***

Then open your postfix config file:

    $ nano /etc/postfix/main.cf

add/modify the following lines:

    relayhost = [smtp.gmail.com]:587
    smtp_sasl_auth_enable = yes
    smtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd
    smtp_sasl_security_options = noanonymous
    smtp_tls_CAfile = /etc/postfix/cacert.pem
    smtp_use_tls = yes

Validate Certificate & Open/Create ***sasl_passwd***:

    $ cat /etc/ssl/certs/Thawte_Premium_Server_CA.pem | sudo tee -a /etc/postfix/cacert.pem 
    $ sudo nano /etc/postfix/sasl/sasl_passwd

And add following line:

    [smtp.gmail.com]:587 USERNAME@gmail.com:PASSWORD

If you want to use your Google App’s domain, replace ***@gmail.com*** with your ***@domain.com***. Also for ***PASSWORD*** use Google [App password](https://support.google.com/accounts/answer/185833?hl=en) if you have enabled 2-Step-Verification. 

Set ***sasl_passwd*** file permission and update postfix config to use ***sasl_passwd*** file:

    $ sudo chmod 400 /etc/postfix/sasl/sasl_passwd
    $ sudo postmap /etc/postfix/sasl/sasl_passwd
Reload postfix config for changes to take effect:

    $ sudo /usr/sbin/postfix reload

Testing:
--------
If you have configured everything correctly, following command should generate a test mail from your server to your mailbox. Replace ***you@example.com*** with your email address.

    $ echo "Test mail from postfix" | mail -s "Test Postfix" you@example.com

