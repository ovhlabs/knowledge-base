---
layout: post
title:  "How to get a serial console on your arm instance"
categories: Labs
author: xXraphXx
lang: en
---

As you may have seen it, there is currently no vnc console available for arm instances, this can be disturbing if at some point your guest
lose network connectivity. However, we will show you how to access to the serial console of your machine 
(currently only available for arm, others have vnc)

# What you don't have with arm instances

Once you have spawned your arm virtual machine in the main manager (by any other way like the Openstack dashboard itself, the novaclient or curl, you can skip this step), you can go to the Openstack Dashboard

![goto_dashboard.png](/kb/images/2015-10-16-how-to-serial-console-arm-instance/goto_dashboard.png)

Once there, as stated above you can see that there is no vnc available

![no_vnc](/kb/images/2015-10-16-how-to-serial-console-arm-instance/no_vnc.png)

Please also note that there is no serial console dumpfile available either (for arm only). This is a direct consequence from the fact that the vm serial is exposed on the network instead. 
Both are exclusive. 
So if you see a console log file, it means that you won't have any Serial Over Lan access for your machine.
This is the case if your machine was created before we enabled this. 
If you want SOL access, stop your machine and start it again.

![no_console_log](/kb/images/2015-10-16-how-to-serial-console-arm-instance/no_console_log.png)

In short, what you do not have with arm instances:
    * vnc console
    * serial output log file because we instead propose the SOL access

# How to get the serial console url

## Fetch your openstack credentials

![openstack_creds](/kb/images/2015-10-16-how-to-serial-console-arm-instance/openstack_creds.png)


## Source creds and provide the correct region

```
$ source /tmp/67547959-openrc.sh 
Please enter your OpenStack Password: 
$ export OS_REGION_NAME=HZ1
```

## Get the serial console url

### Option 1: python-novaclient 

Your novaclient must be recent enough for this (>= 2.20.0)

One example to get one compatible version (debian/ubuntu) of the novaclient

```
$ apt-get install ubuntu-cloud-keyring
$ echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu " \
    "trusty-updates/kilo main" > /etc/apt/sources.list.d/cloudarchive-kilo.list
$ apt-get update && apt-get install python-novaclient
```

Then get the serial console url

<pre>
~$ nova get-serial-console test1 
+--------+--------------------------------------------------------------------------------+
| Type   | Url                                                                            |
+--------+--------------------------------------------------------------------------------+
| serial | wss://compute.hz1.runabove.io:6083/?token=fe5f19a3-a926-446f-9c1d-5d6d651c9a57 |
+--------+--------------------------------------------------------------------------------+
</pre>

### Option 2: curl

If you have no compatible novaclient at hand or just don't want to install it: get your instance uuid (in the Openstack Dashboard)

```
#!/bin/bash
set -e
server_id=$1
[[ $DEBUG == 1 ]] && echo Authenticating
curl -s -d "{\"auth\": {\"tenantName\": \"${OS_TENANT_NAME}\", 
    \"passwordCredentials\": {\"username\": \"${OS_USERNAME}\", 
    \"password\": \"$(python -c "import json; print json.dumps('${OS_PASSWORD}')" \
    | sed -e 's,",,g')\"}}}" \
    -H "Content-type: application/json" \
    ${OS_AUTH_URL}/tokens > /tmp/body
[[ $DEBUG == 1 ]] && cat /tmp/body
auth_token=$(cat /tmp/body | \
    python -c 'import json; import sys; print json.loads(sys.stdin.read())["access"]["token"]["id"]')
[[ $DEBUG == 1 ]] && echo Getting url
curl -s -X POST https://compute.hz1.runabove.io/v2/${OS_TENANT_ID}/servers/${server_id}/action \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -H "X-Auth-Token: ${auth_token}" \
    -d '{"os-getSerialConsole": {"type": "serial"}}' > /tmp/body
[[ $DEBUG == 1 ]] && cat /tmp/body
link=$(cat /tmp/body | \
    python -c 'import json; import sys; print json.loads(sys.stdin.read())["console"]["url"]')
echo $link
```

Copy this in /tmp/get_console_url.sh then

```
chmod +x /tmp/get_console_url.sh
DEBUG=0 /tmp/get_console_url.sh <YOUR INSTANCE ID>
```

if any issue you can still switch on debugging (DEBUG=1)

# Connect to your serial console


Nice references about this:

* [blog](http://blog.oddbit.com/2014/12/22/accessing-the-serial-console-of-your-nova-servers/)

* [websocket client](https://github.com/larsks/novaconsole/)


The novaconsole project is quite cool. You can discover it, but we'll use only one file here

```
$ wget https://github.com/larsks/novaconsole/blob/2.0.1/console-client-poll.py -O /tmp/console-client-poll.py
```

## Copy the following content to /tmp/patch

```
--- novaconsole/console-client-poll.py	2015-10-16 18:47:11.745588999 +0000
+++ console-client-poll.py	2015-10-16 18:47:43.105588999 +0000
@@ -31,6 +31,7 @@
     ws = websocket.create_connection(args.url,
                                      header={
                                          'Sec-WebSocket-Protocol: binary',
+                                         'Origin: %s' % args.url
                                      })
 
     poll = select.poll()
```

## Patch the websocket client

```
$ cd /tmp
$ patch -p1 < /tmp/patch
$ chmod +x /tmp/console-client-poll.py
```

## Install dependency

```
$ apt-get install python-websocket
```

## Enjoy your serial console

```
/tmp/console-client-poll.py -e [ wss://compute.hz1.runabove.io:6083/?token=fe5f19a3-a926-446f-9c1d-5d6d651c9a57
```

![console](/kb/images/2015-10-16-how-to-serial-console-arm-instance/serial_console.png)

