---
layout: post
title:  "Shipping logs to PaaS Logs with Filebeat"
categories: Logs
author: Pierre de Paepe
lang: en
---

Filebeat is an [open source](https://github.com/elastic/beats/tree/master/filebeat) file harvester, mostly used to fetch logs files and feed them into logstash. Together with Logstash, Filebeat is a really powerful tool that allows you to parse and send your logs to PaaS logs in a elegant and non intrusive way (except installing filebeat of course ;-). 

This guide will describe how to ask OVH to host your own dedicated Logstash on PaaS Logs and how to setup Filebeat on your system to forward your logs to it. It will also present you with some configuration setup you can use on Logstash to further structure your logs. Note that in order to complete this tutorial, you should have at least : 

  - [Activated the Paas Logs lab and created an account.](/kb/en/logs/quick-start.html#account)
  - [created at least one Stream and get its token.](/kb/en/logs/quick-start.html#streams)

Once you have done theses two steps, you can dig into this one. Be prepared. 

----------

#1 Simple Logstash 2.x Configuration on PaaS Logs

This simple configuration is here only to make it easier for you to see your logs, a couple of chapters later, you will find more advanced configurations that will breakdown your code. If you are already familiar with Logstash configuration on PaaS Logs, you can skip this one. Otherwise, it is a good start point to get it up and running. 
On PaaS Logs manager, in Inputs section:

 1. Click on blue + icon
 2. Give a name, a short description, select "Logstash 2.x" as engine, then click on the blue floppy disk icon to save the entry.
 3. Attach your graylog stream to logstash by clicking on `Subscription` then on `Attach this stream`. Please refer to [this guide first](https://community.runabove.com/kb/en/logs/quick-start.html#streams) if you need to create a new one.
 3. Once attached, click on "Networking", then set "5044" as exposed port. If you change it, you will have to also change it in the input section of your Logstash configuration. Click on "Add" to add it.  You might want to also add the IPs where your logs come from, so the hosted input will only trust these IPs.
 4. Now please click on "Configuration", then fill the following snippet. 

On input section, add:

    input {
      beats {
          port => 5044
              ssl => true
                  ssl_certificate => "/etc/ssl/private/server.crt"
                  ssl_key => "/etc/ssl/private/server.key"
       }
    }

On filter section, add:

    filter {
    }

Once configured, You can launch your logstash by clicking on "Start" button. At the end the procedure, a hostname will appear in green meaning your input is started. You will need this hostname for Filebeat configuration. 

#2 Setup Filebeat in your system

Filebeat supports <b>many platforms</b>  as listed here [https://www.elastic.co/downloads/beats/filebeat](https://www.elastic.co/downloads/beats/filebeat)
Following section will give the Debian one as an example.

you can decide to setup Filebeats from package or to compile it from source (you will need the latest [go compiler](https://golang.org/) to compile it) or just download the generic Linux binary to start immediately.

For this part head to [Filebeat download website](https://www.elastic.co/downloads/beats/filebeat) to download the best version for your distribution. Just choose the Linux 64 bit if you don't know which one to choose. 

The following configuration files have been tested on the latest version of Filebeat available at the time of writing (1.1.2). 
The Debian installation package will install the config file in the following directory : /etc/filebeat/filebeat.yml



#3 Configure Filebeat on your system

Filebeat expect a configuration file named **filebeat.yml** . 

Following example will be for Apache logs and syslog files but you can easily prospect anything else. The trick is to attach a type to any file you parse so that in Logstash, you will be able to select the correct Grok for your file. You will see in the next chapter how to parse your logs depending on the type you send. For the configuration to work, the important part is to replace *hosts: ["c002-my-paas-logs-hostname.in.laas.runabove.com:5044"]* with the hostname given by PaaS Logs. You should also put the SSL Certificate authority of the dedicated inputs in a file, (ex : /usr/local/etc/filebeat/laas-ca.crt). The input SSL CA is exposed below.  

####Filebeat configuration:

```
############################# Filebeat ######################################
filebeat:
  # List of prospectors to fetch data.
  prospectors:
  # Each - is a prospector. Below are the prospector specific configurations
  # Paths that should be crawled and fetched. Glob based paths.
  # To fetch all ".log" files from a specific level of subdirectories
  # /var/log/*/*.log can be used.
  # For each file found under this path, a harvester is started.
  # Make sure not file is defined twice as this can lead to unexpected behaviour.
    - 
        paths:
        - /var/log/apache2/access.log
        input_type: log
        document_type: apache
        fields_under_root: true
    -
        paths:
        - /var/log/apache2/error.log
        input_type: log
        document_type: apache-error
        fields_under_root: true
    -
        paths:
        - /var/log/syslog
        input_type: log
        document_type: syslog
        fields_under_root: true
    
  # Name of the registry file. Per default it is put in the current working
  # directory. In case the working directory is changed after when running
  # filebeat again, indexing starts from the beginning again.
  registry_file: /var/lib/filebeat/registry
############################# Output ##########################################                                                                                                      
# Configure what outputs to use when sending the data collected by the beat.
# Multiple outputs may be used.
output:
  ### Logstash as output
  logstash:
    # The Logstash hosts
    hosts: ["c002-my-paas-logs-hostname.in.laas.runabove.com:5044"]
    worker: 1
    tls:
      # List of root certificates for HTTPS server verifications
      certificate_authorities:
      - /usr/local/etc/filebeat/laas-ca.crt
############################# Logging #########################################
# There are three options for the log ouput: syslog, file, stderr.
# Under Windos systems, the log files are per default sent to the file output,
# under all other system per default to syslog.
logging:
  # Send all logging output to syslog. On Windows default is false, otherwise
  # default is true.
  to_syslog: false
  # Write all logging output to files. Beats automatically rotate files if rotateeverybytes
  # limit is reached.
  to_files: true
  # To enable logging to files, to_files option has to be set to true
  files:
  # The directory where the log files will written to.
    path: /var/log/
    # The name of the files where the logs are written to.
    name: filebeat.log
    # Configure log file size limit. If limit is reached, log file will be
    # automatically rotated
    rotateeverybytes: 10485760 # = 10MB
    # Number of rotated log files to keep. Oldest files will be deleted first.
    keepfiles: 7
  # Sets log level. The default log level is error.
  # Available log levels are: critical, error, warning, info, debug
level: info
``` 

####SSL CA Certificate 
```bash
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

###Launch Filebeat

Launch the Filebeat binary or service to test your config file and head to your apache website for exemple to send some logs. 
you will see this kind of logs in Graylog : 

![beat_graylog](/kb/images/2016-02-25-filebeat-logs/beats_graylog.png)


Note the type value (apache or syslog or apache-error) that indicate the source file of the log message. You can easily display only your apache access logs for example by typing in the search bar `type:apache`. 


#4 OK i get it, but i want some magic powers now. 

It's cool we have our logs but we can make them even more useful. By specifying the right configuration in Logstash, we can parse it and enrich the log messages with custom fields. 
For this you have to tweak two items:

  - the filter configuration in Logstash
  - the Grokpatterns configuration in Logstash

The main idea is to define custom fields in Grok patterns  and to use these Groks in the Filter Section of Logstash. Head to the Logstash Configuration interface in the Paas Logs Manager by clicking on `Configuration` in your input panel.  Here are some valid custom Grok you can use for Apache and Syslog : 

####Grok Pattern configuration 

```
OVHCOMMONAPACHELOG %{IPORHOST:clientip} %{USER:ident} %{USER:auth} \[%{HTTPDATE:timestamp}\] "(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion_num:float})?|%{DATA:rawrequest})" %{NUMBER:response_int:int} (?:%{NUMBER:bytes_int:int}|-)
OVHCOMBINEDAPACHELOG %{OVHCOMMONAPACHELOG} %{QS:referrer} %{QS:agent}
```

a Grok pattern is a pattern in the following form %{SYNTAX:SEMANTIC}. This pattern will allow you to specify the fields in a log of line in the order in which they appear. Note that we customize the fields by specifying the actual type of number types and by suffixing them with '\_num' or '\_int' as explained in the [PaaS Logs fields convention tutorial](/kb/en/logs/field-naming-conventions.html). 
Now that the Grok are defined, you can use them freely in your Logstash filter configuration. 

####Logstash Filter Configuration


```
filter {
     if [type] == "apache" {  
       grok {
           match => { "message" => "%{OVHCOMMONAPACHELOG}" }
           patterns_dir => "/opt/logstash/patterns"
       }
       if ("_grokparsefailure" in [tags]) {
           mutate {
              remove_tag => [ "_grokparsefailure" ]
            }
           grok {
              match => [ "message", "%{OVHCOMBINEDAPACHELOG}" ]
              patterns_dir => "/opt/logstash/patterns"
              named_captures_only => true
             }
      }
   }
   if [type] == "syslog" {
      grok {
           match => { "message" => "%{SYSLOGBASE}" }
       }
   }
}
```

In this configuration you can see how Logstash will parse your logs. It will use the type field you defined before in the Filebeat configuration. If it matches "apache" for example, it will try to match the log line with the Grok COMMONAPACHELOG, if the Grok fail, it will add a tag `_grokparsefailure`. We use this tag to relaunch the Grok parsing by using another Grok We use this tag to relaunch the grok parsing by using another Grok. This is how you can specify several Grok for diverse messages that could be in one log file. 

Note also how the syslog part of the filter use the default Grok Pattern SYSLOGBASE provided by Logstash to parse the syslog lines sent by Filebeat. There is a lot of Grok Patterns already available in Logstash, check the links at the end to know how you can effortlessly parse any kind of log source. 

Once the configuration is done, click on 'Update Configuration' at the bottom of the page. You can really easily test your Configuration afterwards by using the button `Test` on the Input Panel. This will launch a task that will check if the Input and Filter part of the configuration are valid. You will see the following output if it is : 
```
Configuration OK
```

Once done, restart the input and wait for it to be active. Don't worry you won't lose any logs in the meantime, Filebeat tracks automatically the offset of the last log sent in the log file. Get to your stream to watch your brand new and shiny parsed logs lines. 
This is what you can have in Graylog when you use these filters : 

![filter_graylog](/kb/images/2016-02-25-filebeat-logs/filter_graylog.png)


As you can see, response code got its own field, as the bytes transmitted that you can already use in a graph to monitor the global traffic going through one particular page or website. you can also see all the traffic requested by a particular IP, and easily find the kind of content or webpage requested.  

#5 Conclusion and useful resources

Filebeat is a really useful tool to send the content of your current log files to PaaS Logs. Combined with the filter in Logstash, it offers a clean and easy way to send your logs without changing the configuration of your software. There is a lot you can do with Logstash and Filebeat. Don't hesitate to check the links below to master these tools. 


 - Configuration's details :  [https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-configuration-details.html](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-configuration-details.html)
 - Getting started :  [https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-getting-started.html](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-getting-started.html)
 - Grok Patterns Documentation : [https://www.elastic.co/guide/en/logstash/current/plugins-filters-grok.html](https://www.elastic.co/guide/en/logstash/current/plugins-filters-grok.html)
 - Current Grok Pattern reference  : [https://github.com/logstash-plugins/logstash-patterns-core/tree/master/patterns](https://github.com/logstash-plugins/logstash-patterns-core/tree/master/patterns)
 - Even a logstash_forwarder to filebeat tutorial : [https://www.elastic.co/guide/en/beats/filebeat/current/migrating-from-logstash-forwarder.html](https://www.elastic.co/guide/en/beats/filebeat/current/migrating-from-logstash-forwarder.html)


#Getting Help

- Getting Started : [Quick Start](/kb/en/logs/quick-start.html)
- Documentation : [Guides](/kb/en/logs)
- Mailing List : [paas.logs-subscribe@ml.ovh.net](mailto:paas.logs-subscribe@ml.ovh.net)
- Visit our community: [community.runabove.com](https://community.runabove.com)
- Create an account: [PaaS Logs Beta](https://cloud.runabove.com/signup/?launch=paas-logs)


