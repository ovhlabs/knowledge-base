---
layout: post
title:  "How to log your Linux with syslog-ng 3.0+"
categories: Logs
author: baaastijn
lang: en
---


You have a server, a raspberry pi, a cloud instance or something else
running on `Linux` and you want to follow your Logs, the easy way ?
You have never installed a log collector and you're new with Graylog ?


This tutorial is for you then !


In this tutorial you will learn from A to Z how to send Logs from your linux instance to PaaS Logs. 
Don't be afraid, it will be easier than you think. 




# 1. Why ?
Playing with logs is fun and could be very instructive.
In a human body for example you have many information, sorted by your
brain. It's too hot, you move your arm, you like this candy, etc..
On linux, logs are generated automatically, for plenty of actions. RAM
full, movie downloaded, wrong password, Network failure, ...  almost
everything.
But reading logs is painful without proper tools. With this Lab, you'll be
able to sort logs and create fancy dashboards.


# 3. What is logs ? (baby don't hurt me, no more)
Here's some logs example from my OVH Public Cloud instance on `Debian 8` :


```
Jan 27 12:21:15 bastiengraphana syslog-ng[29512]: syslog-ng starting up;
version='3.3.5'
Jan 27 12:21:15 bastiengraphana syslog-ng[29512]: Syslog connection
established; fd='10', server='AF_INET(5.196.84.225:6514)',
local='AF_INET(0.0.0.0:0)'
Jan 29 15:32:23 bastiengraphana sshd[9563]: Received disconnect from
211.110.82.180: 11: Bye Bye [preauth]
Jan 29 18:39:24 bastiengraphana sshd[29694]: Failed password for root from
59.45.79.51 port 39827 ssh2
```
Conclusion : lot of info, with a date, a process, a description. but hard
to follow.




# 2. What do you need ?
 - A `Linux` based instance (server, VPS, Cloud instance, Raspberry Pi,
...). Command lines will be for `DEBIAN 8` in this tutorial
 - A root access to this instance
 - [Activate the PaaS Logs Lab on runabove.com and create an account](/kb/en/logs/quick-start.html#account)
 - [Create a Stream and get your token](/kb/en/logs/quick-start.html#streams)




# 3. Configure your Lab
First thing to do is to configure the Runabove PaaS Logs Lab : activate the lab,
create your user, a stream and a dashboard.
Verify that everything works already perfectly. 
We wrote an independent tutorial for this, please read it and come back
here after : [Quick start](/kb/en/logs/quick-start.html)
Good ? let's go to step #4 then !




# 4. Install and configure a log collector
So let's assume you have your linux. This tutorial `DOES NOT` fully cover how to configure other flavors of syslog nor other OSes.
Please refer to their own documentation to know how to setup a template and a external destination for the logs. You can still read this entire document to have a grasp on how the template is built.
However this configuration should work on any syslog-ng version above 3.0.

We will install a log collector. What's this ? It's a tool who collect
logs from any source, process them and deliver them to various
destinations, like the runabove PaaS Logs lab.


In this tutorial we will install Syslog-ng :


 -  Log in your linux
 -  Install syslog-ng
 -  Check that your syslog-ng version is above 3.0 (use `syslog-ng --version`) for that. 
```
sudo apt-get install syslog-ng
```
Once it's done we will configure it to collect system logs and deliver
them to the Lab
 - open syslog-ng configuration file


```
nano /etc/syslog-ng/syslog-ng.conf
```
 - Remove the text in it, and copy-paste this configuration. Don't forget
to modify the token by yours


```
@version: 3.5
@include "scl.conf"
@include "`scl-root`/system/tty10.conf"


# Syslog-ng configuration file, compatible with default Debian syslogd
# installation.


# First, set some global options.
options { chain_hostnames(off); flush_lines(0); use_dns(no); use_fqdn(no);
          owner("root"); group("adm"); perm(0640); stats_freq(0);
          bad_hostname("^gconfd$");
};


########################
# Sources
########################
# This is the default behavior of syslogd package
# Logs may come from unix stream, but not from another machine.
#
source s_src { unix-dgram("/dev/log"); internal();
             file("/proc/kmsg" program_override("kernel"));
};




########################
# TEMPLATES
########################
template ovhTemplate {
    # important:
    ## Bracket [] no space between inside (opening/closing), space outside.
    ## sid_id (exampleSDID@32473), flowgger need an id for structured data as specified by the RFC 5424.
    ## change X-OVH-TOKEN=\"xxxxxxxxxxxxxx\" by your X-OVH-TOKEN
    #flowgger RFC5424 example:
    #<23>1 2015-08-05T15:53:45.637824Z hostname appname 69 42 [origin@123 software="test script" swVersion="0.0.1"] test message
    #pri timestamp hostname appname pid msgid [sd_id sd_field=sd_value] message

    template("<${LEVEL_NUM}>1 ${ISODATE} ${HOST} ${PROGRAM} ${PID} - [sdid@32473 X-OVH-TOKEN=\"xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx\" pid=\"${PID}\" facility=\"${FACILITY}\" priority=\"${PRIORITY}\"] ${MSG}\n");
    template_escape(no);
};


########################
# Destinations
########################
# First some standard logfile
#
destination ovhPaaSLogs {
    tcp("laas.runabove.com"
        port(6514),
        template(ovhTemplate),
        ts_format("iso"),
        tls(peer-verify("require-trusted") ca_dir("/etc/ssl/certs/")),
        keep-alive(yes),
        so_keepalive(yes),
    );
};


destination localfile {
    file("/var/log/temporaryfiletochecklogs.log");
};




log {
    source(s_src);
    destination(ovhPaaSLogs);
};

log {
    source(s_src);
    destination(localfile);
};


###
# Include all config files in /etc/syslog-ng/conf.d/
###
@include "/etc/syslog-ng/conf.d/"
```


Let's review this configuration.


`SOURCES` : this is the logs sources to collect. So here, we collect System
and Internal. More sources can be added of course !


`TEMPLATE` : we will deliver logs to the Lab based on this template, it will
bring more comprehension for Graylog


`DESTINATION` : This is were we will deliver logs in nearly real time. Here,
we have to destinations : The first is the remote Lab, the second one is
local. I create a new log file locally in order to check if the logs are properly sent.
It's optional of course, and you can safely remove it once everything is fine.
as you can see, the remote destination will use the template, the local
destination will not.




- Save the file, close nano and restart syslog


```
sudo service syslog-ng restart
sudo syslog-ng
```


- Open the temporary local file, check if there is something inside


```
nano /var/log/temporaryfiletochecklogs.log
```

If It's empty, that's not normal. check your syslog configuration again.
In the best case, we should have something like this :



```
Jan 27 12:21:15 bastiengraphana syslog-ng[29512]: syslog-ng starting up;
version='3.3.5'
Jan 27 12:21:15 bastiengraphana syslog-ng[29512]: Syslog connection
established; fd='10', server='AF_INET(5.196.84.225:6514)',
local='AF_INET(0.0.0.0:0)'
```
It means syslog-ng has started up, and connection to remote Lab is fine.


# 5. Let's play with Graylog Dashboards
Let's recap : you have a linux instance, and it's sending log locally and
remotely, thanks to a log collector.
We send 2 flows : internal() and system()


The last step is to create a dashboard displaying the result :


- Connect to the lab manager, ensure you that you have a Stream and that the token in the syslog configuration file is OK. Ensure that you have a
Dashboard created.
- Connect to https://laas.runabove.com
- Go in Stream Tab, click on your stream. In the Left top corner, chose a 1
Day range and click on the green button to search.
- You should have some results like this : 

![Graylog search view](/kb/images/2016-02-24-how-to-log-your-linux/search.png)

- On the top right corner of the histogram, click on "Add to dashboard".


Alright, you just created the first Widget in you dashboard.
Now, let's create a PIE chart :


- On the left, click on the small blue triangle before "facility"
- click on "Quick Values"
- A pie chart will appear, you can also add it to your dashboard


Well done, second Widget added !


The best feature is to mix criteria, based on what is important to you :
for example ```facility:auth AND level:6```
Also you can create Alerts in Runabove Lab manager (Stream / Alerts /
Conditions).


Tutorial is done, have a good monitoring :-)



#Getting Help

- Getting Started : [Quick Start](/kb/en/logs/quick-start.html)
- Documentation : [Guides](/kb/en/logs)
- Mailing List : [paas.logs-subscribe@ml.ovh.net](mailto:paas.logs-subscribe@ml.ovh.net)
- Visit our community: [community.runabove.com](https://community.runabove.com)
- Create an account: [PaaS Logs Beta](https://cloud.runabove.com/signup/?launch=paas-logs)

