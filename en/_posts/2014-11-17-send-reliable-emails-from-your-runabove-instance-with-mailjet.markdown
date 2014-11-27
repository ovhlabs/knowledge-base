---
layout: post
title: "Send reliable emails from your RunAbove instances using Mailjet"
categories: Instances
author: gierschv
---

During the usage of your RunAbove instances, you'll need to send some emails
for different purposes (i.e. monitoring, notifications, web application, etc).
However if sending emails is not your job and you've never heard of *SPF*,
*DKIM*, *IP Reputation* or *PTR*, you may just want a reliable way to send
your emails without without wasting time in configuration and monitoring.

<div style="float:left; margin-right: 15px;">
    <img src="/kb/images/2014-11-17-send-reliable-emails-from-your-runabove-instance-with-mailjet/mailjet.png" alt="Mailjet" />
</div>

In this guide, you'll discover how to configure a postfix service in your
instance to use [Mailjet](https://mailjet.com) as a reliable email relay.
Mailjet allows you to send emails without taking care of the email
infrastructure, assuring you a great deliverability in your mailings. This
service
[is recommended by OVH.com](http://blog.mailjet.com/post/47188898598/partnership-ovh-com-recommends-mailjet-for-email), the creator of RunAbove.

If you don't have a Mailjet account, create one in few seconds on the
[Mailjet website](https://mailjet.com).
For your information, Mailjet provides a **free tier up to 12 000 emails per
months**.

## Postfix as a local relay

In this guide, we'll use [Postfix](http://www.postfix.org/) as a local email
relay to the
[Mailjet SMTP](https://www.mailjet.com/support/how-can-i-configure-my-smtp-parameters,2.htm)
service. This simple configuration will allow you to send emails using your
usual configuration (i.e. ```127.0.0.1:25``` or the ```sendmail``` command).

If you are using a debian or ubuntu image, install the necessary packages:

    $ sudo apt-get install postfix libsasl2-2 libsasl2-modules

Postfix configuration wizard will ask you some questions. Just select
**Internet Site** and for FQDN, something like **your_domain.com**.

Then, grab the SMTP credentials provided in the Mailjet dashboard, and edit your
Postfix config file, ```/etc/postfix/main.cf``` configuring the following
parameters:

    relayhost = [in-v3.mailjet.com]:587
    smtp_sasl_auth_enable = yes
    smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
    smtp_sasl_security_options = noanonymous
    smtp_tls_security_level = encrypt

In ```/etc/postfix/sasl_passwd```, add your Mailjet SMTP credentials:

    [in-v3.mailjet.com]:587 user:password

Rebuild the map and chown these it to ensure only *root* is able to read it:

    $ sudo postmap /etc/postfix/sasl_passwd
    $ sudo chown root:root /etc/postfix/sasl_passwd*
    $ sudo chmod 600 /etc/postfix/sasl_passwd*

Finally, reload your Postfix service:

    $ sudo /etc/init.d/postfix reload

You can now send your first mail using your local Mail Transfer Agent and the
Mailjet service:

    $ echo 'Hello world' | sendmail -f from@your.domain -t to@your.domain

And monitor your outgoing emails reading your mail log:

    $ tail -f /var/log/mail.log
    Nov 17 15:09:32 my-instance.runabove.com postfix/smtp[1234]: DA4E220008A: to=<to@your.domain>, relay=in-v3.mailjet.com[5.196.43.129]:587, delay=0.18, delays=0.03/0/0.13/0.02, dsn=2.0.0, status=sent (250 2.0.0 Ok: queued as 0C0151AC06F9)
