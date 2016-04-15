---
layout: post
title:  "Sending Android 4.4 Logs with NXLog to PaaS Logs"
categories: Logs
author: Babacar Diassé
lang: en
---

If you have a device running Android 4.4 Kitkat or less, like a smart TV, or a set-top box or simply a phone that hasn't been updated to Lollipop and that you were always wondering what it was doing all day, this tutorial can give you the answer. [NXlog](https://nxlog.co) has developped an Android app that will allows you to send the logs of your phones to PaaS Logs. Its configuration is fairly simple and you will able to witness your logs in PaaS logs in minutes. So let's get started !


In order to complete this tutorial you will have to have created and activated your account on PaaS Logs and be able to send your logs to a stream.
 
  - [Activate the PaaS Logs lab and created an account.](/kb/en/logs/quick-start.html#account)
  - [Create one Stream and get its token.](/kb/en/logs/quick-start.html#streams)


# Input on PaaS Logs

In order to exploit the NXlogs on PaaS Logs you will need to setup a dedicated input. The current Android Version of NXLog does not allow you to use your token inside your message like we did in the [Windows tutorial](/kb/en/logs/windows-nxlog.html). But don't worry your personal input on PaaS Logs will gently take care of all of this stuff :-). 

To keep this tutorial stupid and simple, we will use [Logstash Input](/kb/en/logs/logstash-input.html) since it provides a syslog input right from the start. In your Runabove Console, add an input with the logstash Engine by clicking on the blue "+" button on the Input Panel. Name it and describe it and then you can click on the floppy disk blue button to save it. 

## Input Configuration

Click on Configuration to open the Configuration panel of the Input. 

- On the Input section, use this ultra simple configuration : 

```
input {
   syslog {
     port => 4000
   }
} 
```

Click on the `Update configuration` button to save it. 

- By clicking on `Networking` in the Input panel, use the Networking panel, to enter the matching port (Here `4000`) and then click on `Add` button. Configure any firewall rule if you want to restrict your Input to specific IPs and click on `Update configuration`.

- Attach your previously created Stream by clicking on `Subscription`, Choose your stream on the List and then click on `Attach This Stream`. Click on Close. Your input will now automatically send the incoming log to this specific stream. 

- Start the input by clicking on `Start` on the Input Panel. At the end of the deployment, you will obtain the address of your input in the following form `c002-570fb9f6d2ee5e00095ce6ab.in.laas.runabove.com`. This is the host to send your logs to. 

# NXLog on Android

Android has a complex ecosystem with a lot of differents devices and OS versions available. This tutorial has been successfully tested on devices with Android 4.4. No root is needed to use the NXLog application but note that some devices under this version are maybe not compatible. To download the application head to link in the Play Store : [NXLog on Play Store](https://play.google.com/store/apps/details?id=com.nxsec.nxlog). If your device is not compatible with the Play Store, head to the official download page of [NXLog](http://nxlog.co/products/nxlog-community-edition/download). 

##NXLog configuration

The default NXLog configuration is fairly simple, you just open the default configuration and you set the host and the port of the Output Module to the host and port you have obtained just before :

```
<Output out>
    Module  om_tcp
    # Change the IP address and port below
    Host    c002-570fb9f6d2ee5e00095ce6ab.in.laas.runabove.com
    Port    4000
    Exec    to_syslog_bsd();
</Output>
```

Keep Everything else in the same form and Hit the button "Start" Below. 

If eveything is alright you will have a log line that tells you the PID of the NXLog process. 

![NXLog phone](/kb/images/2016-02-25-android-nxlog/screen-pid.png)

#Logs on Graylog

Head to your [Graylog stream](https://laas.runabove.com/graylog) to see your logs in your stream. You will know everything your device do as soon as it does it. 


![Graylog Stream](/kb/images/2016-02-25-android-nxlog/graylog.png)


#Getting Help

- Getting Started : [Quick Start](/kb/en/logs/quick-start.html)
- Documentation : [Guides](/kb/en/logs)
- Mailing List : [paas.logs-subscribe@ml.ovh.net](mailto:paas.logs-subscribe@ml.ovh.net)
- Visit our community: [community.runabove.com](https://community.runabove.com)
- Create an account: [PaaS Logs Beta](https://cloud.runabove.com/signup/?launch=paas-logs)


