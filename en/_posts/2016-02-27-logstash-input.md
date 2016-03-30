---
layout: post
title:  "All you have to know about the Logstash Input on PaaS Logs !"
categories: Logs
author: Babacar Diassé
lang: en
---


"All you have to know about the Logstash Input on PaaS Logs" is your main source of information about deploying a Logstash input on PaaS Logs. Logstash is a software developped by Elastic and allows you to send messages from different inputs to different type of output using differents codec while processing them and transforming them in the process.
You can learn a lot more about it on [the official website](https://www.elastic.co/products/logstash). We believe that it is a powerful tool that you would love to use with PaaS Logs. Yes, on PaaS Logs you can deploy your personal Logstash with your own configuration. That will allow you for exemple to send your datas from many sources to one and only Logstash instead of configuring one on each of your host. You will find which plugins are supported, which ones are not and how to spawn a Logstash input on PaaS Logs. 

This is a rather long document but if you are already familiar with Logstash you can jump to the parts you're interested in :  

 - [What is Logstash](#logstash_101)
 - [How do I configure Logstash on PaaS Logs](#paas_config)
 - [What is special about our hosted Logstash ?](#additional)  

This is "All you have to know about the Logstash Input on PaaS Logs" !


 <a name="logstash_101">&nbsp;</a>
#1 What is Logstash 
Logstash is mainly a processing pipeline of data that allows you to get or receive informations from a lot of sources and trasnform them if necessary before sending them to different type of software. In a configuration file you have 3 main parts to configure it :
 
 - The Input part : This part details where your logs come from. Some inputs wait for logs and some inputs are able to fetch them from a database for example. 
 - The Filter part : This part details how Logstash should parse and transform your logs messages. 
 - The Output part : This part specifies in which format to send logs and where to send them. 

   Here is a small configuration file so you get an idea : 

```
#input
#The input part just launch tcp server that will listen on port 5000
#Each incoming line of log will be tagged as a syslog type. 
input {
     tcp {
        port => 4000
        type => syslog
    }
}

#Filter 
#The filter part applies a grok filter that will parse the message 
#It will also create new fields with informations contained in the message. 
filter {
 grok {
   match => { "message" => "%{SYSLOGBASE}" }
  }

 date {
    match => [ "timestamp", "MMM dd HH:mm:ss" ]
    target => "timestamp"
    timezone => "Europe/Paris"
  }
}

#Output 
#The output part will then encode everything in a gelf format and send it to laas.runabove.com on the UDP GELF Input
#Note that it will also add our token in the process. 
output {
  gelf {
      host => "laas.runabove.com"
      port => 2202
      custom_fields => ['X-OVH-TOKEN', 'da819874-5562-4a5f-b34e-fa8e708e8f16']
  }
}
```

This is one exemple of configuration among others you can use in your own Logstash to send syslog type logs to PaaS Logs.
There is a lot of filter and plugin available in Logstash, and the list is growing !
For example by sending these kind of lines into this Logstash : 

```
Mar 25 13:20:36 bdiasse-wsant docker[7406]: time="2016-03-25T13:20:36.038884464+01:00" level=info msg="IPv6 enabled; Adding default IPv6 external servers : [nameserver 2001:4860:4860::8888 nameserver 2001:4860:4860::8844]"
Mar 25 13:20:36 bdiasse-wsant systemd[1]: Started docker container 5164ae90f489bc4479081c788b69b533a1e7a0be7e456f123cb05bb0542fc71b.
Mar 25 13:20:36 bdiasse-wsant systemd[1]: Starting docker container 5164ae90f489bc4479081c788b69b533a1e7a0be7e456f123cb05bb0542fc71b.
Mar 25 13:20:36 bdiasse-wsant avahi-daemon[743]: Withdrawing workstation service for veth4c25f95.
Mar 25 13:20:36 bdiasse-wsant systemd[1]: Stopping ifup for veth4c25f95...
Mar 25 13:20:36 bdiasse-wsant kernel: [337824.157113] eth0: renamed from veth4c25f95
Mar 25 13:20:36 bdiasse-wsant ifdown[2091]: /sbin/ifdown: interface veth4c25f95 not configured
Mar 25 13:20:36 bdiasse-wsant systemd[1]: Stopped ifup for veth4c25f95.
Mar 25 13:20:36 bdiasse-wsant NetworkManager[777]: <info> devices removed (path: /sys/devices/virtual/net/veth4c25f95, iface: veth4c25f95)
Mar 25 13:20:36 bdiasse-wsant kernel: [337824.172875] IPv6: ADDRCONF(NETDEV_CHANGE): vethd7be492: link becomes ready
Mar 25 13:20:36 bdiasse-wsant kernel: [337824.172973] docker0: port 1(vethd7be492) entered forwarding state
Mar 25 13:20:36 bdiasse-wsant kernel: [337824.172992] docker0: port 1(vethd7be492) entered forwarding state
Mar 25 13:20:36 bdiasse-wsant NetworkManager[777]: <warn> (vethd7be492): enslaved to unknown device 3 docker0
Mar 25 13:20:36 bdiasse-wsant NetworkManager[777]: <info> (vethd7be492): link connected
Mar 25 13:20:36 bdiasse-wsant docker[7406]: time="2016-03-25T13:20:36.478880100+01:00" level=info msg="POST /v1.21/containers/5164ae90f489bc4479081c788b69b533a1e7a0be7e456f123cb05bb0542fc71b/resize?h=57&w=207"
Mar 25 13:20:37 bdiasse-wsant avahi-daemon[743]: Joining mDNS multicast group on interface vethd7be492.IPv6 with address fe80::8808:c4ff:fea6:becc.
Mar 25 13:20:37 bdiasse-wsant avahi-daemon[743]: New relevant interface vethd7be492.IPv6 for mDNS.
Mar 25 13:20:37 bdiasse-wsant avahi-daemon[743]: Registering new address record for fe80::8808:c4ff:fea6:becc on vethd7be492.*.
Mar 25 13:20:51 bdiasse-wsant kernel: [337839.195284] docker0: port 1(vethd7be492) entered forwarding state
Mar 25 13:24:02 bdiasse-wsant puppet-agent[1377]: Skipping run of Puppet configuration client; administratively disabled (Reason: 'Disabled by default on new installations');
Mar 25 13:24:02 bdiasse-wsant puppet-agent[1377]: Use 'puppet agent --enable' to re-enable.
```


you will have the following result in your stream in Graylog :

![local_logstash_graylog](/kb/images/2016-02-27-logstash-input/local_logstash_graylog.png)

So now let's suppose, you have a lot of hosts and you want to send all your syslog outputs to Logstash. One way to do it is to put one Logstash on one of your machine and send all the logs to this hosts. This will work but what happens if your host go down ? or is not fast enough ? Or if it is allergic to Java ? Don't worry the best part about PaaS Logs is that we can host your Logstash for you. We also allow you to configure the input and the filter as you wish and you can even define custom Groks. The next chapter will tell you how to do it !

<a name="paas_config">&nbsp;</a>

# Host a Logstash input on PaaS Logs.   
The Logstash Input comes with many advantages : 

 - The output part of the Logstash is automatically configured by us.
 - You have your own certificate to enable SSL. This certificate can be used for example to trust only the TCP Inputs of your Logstash. 
This certificate and its associated key can be found at the following paths :  `/etc/ssl/private/server.crt` for the cert and  `/etc/ssl/private/server.key` for the key. The CA used to create these inputs is at the following location `/etc/ssl/private/ca.crt`. You will find this SSL CA for reference at the end of this document. 
 - And finally, we ensure that your input is always up and running 24/7.

To host this input in the PaaS Logs, you will need to configure it in the PaaS Logs manager. Check the `Inputs` panel next to the Stream one and click on the '+' button. The Manager will then ask you to select your Engine : Select `Logstash 2.2` and put a elegant name and a wonderful description. Click on the blue floppy disk button and TA-DA, your input is created. 


![logstash_creation](/kb/images/2016-02-27-logstash-input/logstash_creation.png)


The Engine won't allow you to start it if you do not configure it properly. So let's do it !

## Logstash Input configuration
Click on Configuration to display the Logstash Configuration Panel as follows : 


![logstash_creation](/kb/images/2016-02-27-logstash-input/config_logstash_1.png)


There is 3 section in this pop-up :
 
 - The Input section where you put the Input part of your configuration file. 
 - The Filter section where you put the filter part. 
 - The grok patterns sections where you can create your own grok patterns.

If we take the configuration example above and if we enable the SSL encryption, we have that configuration for the Input Section : 

![logstash_creation](/kb/images/2016-02-27-logstash-input/input_section.png)


As you can see, this is roughly the same configuration that before. The SSL configuration needs 4 extra parameters :
 
 - `ssl_enable`: that allows to enable SSL. Must be set to 'true'.  
 - `ssl_cert`: the location of the autogenerated server certificate.
 - `ssl_key`: the location of the associated key. 
 - `ssl_extra_chain_certs` : the array containg the path to the CA certficate. 


And for the filter part, you just have to copy and paste.  

![logstash_creation](/kb/images/2016-02-27-logstash-input/filter_section.png)


The last section of the configuration is dedicated to custom Grok Filters. If you know about Grok, you can use this text area to create your own grok that you can use in the filter section above. It is useful for advanced usage of Logstash. Head to the end of the document to get some links that can help you use this functionality. 

You can then click on `Update Configuration` and your Logstash is configured !
You can always verify that your Logstash configuration is correct by using the `Test` button in the Inputs panel. This will launch a task, that will tell you if your configuration is valid. Check the screenshot below. 

![logstash_creation](/kb/images/2016-02-27-logstash-input/test_success.png)


You really want to click on `Start` but are we there yet ? No, but we are almost there. 

Many inputs like the redis one for exemple, fetch their own data from diverses sources. But in the case of the TCP Input, you need to tell us which port you want to open in your Input. Moreover your input will have a public IP, you don't want anyone to mess up with it. Don't worry you can further secure you input by whitelisting only a few IP. 

## Input Networking Configuration : 

To configure the Network for your input, please click on the Networking Button. 
In the pop up, you will be able to specify which port(s) you open and which IPs or Subnet you allow to join your input. Just add every entry by using the fields and by clicking `Add`. This little window will always remind you which ports are open and which IPs can access it : 


![network_input](/kb/images/2016-02-27-logstash-input/network-input.png)

Click on `Update Configuration` and it's done. That's all for the Network Configuration.

You still want to click on `Start` I bet but are we there yet ? Not yet. Yes there is something that we have to do. We didn't configure our output section so How PaaS Logs will add the token in the output part ? 
It is simple, your Input just have to subscribe to your stream. Read on ! 


##Stream configuration

By clicking on `Subscription` button in the Input panel, you will pop an interface similar to the previous one. In this window you can just select your stream in the list and click on the button `Attach this stream`. Once attached, you can close it. 

![network_input](/kb/images/2016-02-27-logstash-input/stream_sub.png)

The output will be automatically configured to add the right token. You don't have to send it with your logs, you don't even have to know it !
So now you can click on `Start` and deploy your input on PaaS Logs.

![input_start](/kb/images/2016-02-27-logstash-input/input_start.png)

If you head to Graylog, you will find your Logs in the attached Stream as before. 


![logs_graylog](/kb/images/2016-02-27-logstash-input/logstash_ssl.png)



<a name="additional">&nbsp;</a>
# Additional informations 


##Logstash Version 

The version hosted by PaaS Logs is the Logstash 2.2. Of course we will try to follow new versions as soon as they become available. 

## Logstash Plugins

For your information, here is the list of Logstash plugins we support. Of course we will welcome any suggestion on additional plugins. Don't hesitate to contact us at paas.logs@ml.ovh.net (use this list to subscribe : paas.logs-subscribe@ml.ovh.net). 

###input plugins:
```
logstash-input-beats
logstash-input-couchdb_changes
logstash-input-elasticsearch
logstash-input-eventlog
logstash-input-ganglia
logstash-input-gelf => patched to support TCP
logstash-input-generator
logstash-input-graphite
logstash-input-heartbeat
logstash-input-http
logstash-input-http_poller
logstash-input-imap
logstash-input-irc
logstash-input-jdbc
logstash-input-kafka
logstash-input-log4j
logstash-input-lumberjack
logstash-input-rabbitmq
logstash-input-redis
logstash-input-s3
logstash-input-snmptrap
logstash-input-sqs
logstash-input-stdin
logstash-input-syslog
logstash-input-tcp
logstash-input-twitter
logstash-input-udp
logstash-input-xmpp
logstash-input-zeromq
```

####Input gelf plugin

We patched the gelf input to support tcp but TLS is not yet supported. 
exemple of TCP Input configuration : 

```json
input{
  gelf {
    protocol => "tcp"
    port => 12201
  }
}
```


###filter plugins :
```
logstash-filter-anonymize
logstash-filter-checksum
logstash-filter-clone
logstash-filter-csv
logstash-filter-date
logstash-filter-dns
logstash-filter-drop
logstash-filter-fingerprint
logstash-filter-geoip
logstash-filter-grok
logstash-filter-json
logstash-filter-kv
logstash-filter-metrics
logstash-filter-multiline
logstash-filter-mutate
logstash-filter-sleep
logstash-filter-split
logstash-filter-syslog_pri
logstash-filter-throttle
logstash-filter-urldecode
logstash-filter-useragent
logstash-filter-uuid
logstash-filter-xml
```
###codec plugins :
```
logstash-codec-collectd
logstash-codec-dots
logstash-codec-edn
logstash-codec-edn_lines
logstash-codec-es_bulk
logstash-codec-fluent
logstash-codec-gelf
logstash-codec-graphite
logstash-codec-json
logstash-codec-json_lines
logstash-codec-line
logstash-codec-msgpack
logstash-codec-multiline
logstash-codec-netflow
logstash-codec-oldlogstashjson
logstash-codec-plain
logstash-codec-rubydebug
```


The following plugins are disabled for security reasons :

```
logstash-input-exec
logstash-input-file
logstash-input-pipe
logstash-input-unix
logstash-filter-ruby
```

####SSL CA certificate 

Here is the CA certificate you can use to verify the certificate presented by our hosted inputs.

```
-----BEGIN CERTIFICATE-----
MIIDozCCAougAwIBAgIJALxR4fTZlzQMMA0GCSqGSIb3DQEBCwUAMGgxCzAJBgNV
BAYTAkZSMQ8wDQYDVQQIDAZGcmFuY2UxDjAMBgNVBAcMBVBhcmlzMQwwCgYDVQQK
DANPVkgxCzAJBgNVBAYTAkZSMR0wGwYDVQQDDBRpbi5sYWFzLnJ1bmFib3ZlLmNv
bTAeFw0xNjAzMTAxNTEzMDNaFw0xNzAzMTAxNTEzMDNaMGgxCzAJBgNVBAYTAkZS
MQ8wDQYDVQQIDAZGcmFuY2UxDjAMBgNVBAcMBVBhcmlzMQwwCgYDVQQKDANPVkgx
CzAJBgNVBAYTAkZSMR0wGwYDVQQDDBRpbi5sYWFzLnJ1bmFib3ZlLmNvbTCCASIw
DQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAL03NApk8fl82L4cH7XW+c+8k8dX
xDWLaHl5sfxXqUghmbz5+O5GHPRecxZifcyxsgiw8kUh/wxkqu4+ac4HK0Anod9i
h6VpT7zSTgdFfmJcOxkrcJ9cfVScvWN/4fYZGkGXJHiu+GHmZU1906P2q/OOibpg
/FVvRo/+xoo4RI/uGBrezeSzDjq6vjPY0+eSTtBqb0h459Bguvv2gxV+u8PfpZEk
ELU9KxGlgbikkMTV/Q7zfMEG+4e6A7xxoM33Bh0DhsIALLtBSd6jed5YiYQL2ke2
OMIqwWrOnoccSp46TmDOd62NAESd2hif3Cwd/jbM/D/dfGetW99DrpH/7jUCAwEA
AaNQME4wHQYDVR0OBBYEFFaAcbmGh/ObAeMhYQb3Norh0I1yMB8GA1UdIwQYMBaA
FFaAcbmGh/ObAeMhYQb3Norh0I1yMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEL
BQADggEBADts4SsO+01wjv5BF22kUCPoiNzZW00PYXwjKQf/4oaqJgHVAb2NcnlO
/p86eKzkPjTAH4B1PeGaSAGTt63C8h52ec4UgkjtZ5kf7pfmeH2ZDNVSSHYgoeDF
7nXPyUtwDmHHrwoWJPalL/lo6eWXu/1oaioBvctFGwQf1yTIOCsHktu5rQlOAXn8
r4IOeC764Hsupu2IjaLkyp+WBb6mRIS4B3ubDM8Vuc8tc7GC0B+5jXhOQRu9ZNfO
3Xulb5Vk3AYF6s8TQ3ALK4doCupTUPX4XMXbtBH3XA8Rp7/dLo4oMWQrDpGzP5ys
2kv1X/+sZvjaR0Eezj2owsqR3slqSZ0=
-----END CERTIFICATE-----
```


## Useful Resources <a name="resources">&nbsp;</a>

Here are some links to help you go further with Logstash 

 - [Logstash official documentation](https://www.elastic.co/guide/en/logstash/current/index.html)
 - [Grok filters documentation](https://www.elastic.co/guide/en/logstash/current/plugins-filters-grok.html)
 - [Logstash + Groks + Filebeat = Awesome](/kb/en/logs/filebeat-logs.html)


That's all you have to know about the Logstash Input on PaaS Logs. 

#Getting Help

- Getting Started : [Quick Start](/kb/en/logs/quick-start.html)
- Documentation : [Guides](/kb/en/logs)
- Mailing List : [paas.logs-subscribe@ml.ovh.net](mailto:paas.logs-subscribe@ml.ovh.net)
- Visit our community: [community.runabove.com](https://community.runabove.com)
- Create an account: [PaaS Logs Beta](https://cloud.runabove.com/signup/?launch=paas-logs)

