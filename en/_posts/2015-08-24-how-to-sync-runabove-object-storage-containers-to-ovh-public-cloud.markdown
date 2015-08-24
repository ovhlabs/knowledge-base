---
layout: post
title:  "How to synchronize RunAbove container to OVH Public Cloud?"
categories: Object-Storage
author: pilgrimstack
lang: en
---

Swift provides a very simple way to synchronise different containers even if the source and the destination are not in the same infrastructure. That is our case here with RunAbove Object Storage and OVH Public Cloud.

A job runs on the RunAbove Swift server every 5 minutes. It will push all objects in the container on RunAbove to an other on OVH Public Cloud, moreover Swift will check modifications and will synchronise objects with a different date of modification and different md5sum. 

# Prerequistes :

 * Python installed on your computer ([https://www.python.org/](https://www.python.org/)
 * Openstack swift client ([https://github.com/openstack/python-swiftclient](https://github.com/openstack/python-swiftclient) or curl (Unix)

# How it works :

The authentication will be done by using a shared key.

The source container should have two specials metadata:

 * X-Container-Sync-To: the destination of the container on the other infrastructure
 * X-Container-Sync-Key: the shared key between containers

The destination container should have one special metadata:

 * X-Container-Sync-Key: the shared key between containers

# Generate the shared key :

```sharedKey=$(openssl rand -base64 32)
```

# With Python client :

Assuming you have sourced your environnement with OVH Public Cloud credentials, you have to add the key to the destiantion container.

```swift post --sync-key "$sharedKey" myContainer
```

Then you have to get the public address of this container.

```destContainer=$(swift --debug stat myContainer 2>&1 | grep 'curl -i.*storage' | awk '{ print $4 }')
```

Now you can tell to the source container which destination it should pushed the data with the shared key.

Start by sourcing the RunAbove credentials, then: 

```swift post --sync-key "$sharedKey" --sync-to "$destContainer" myContainer
```

# With cURL :

On the destiantion:

```curl -i https://storage.sbg1.cloud.ovh.net/v1/AUTH_YYYYYYYYY/myContainer
        -X POST -H "X-Container-Sync-Key: $sharedKey" -H "Content-Length: 0" 
        -H "X-Auth-Token: abcd1234" 
```

On the source:

```curl -i https://storage.gra1.cloud.ovh.net/v1/AUTH_XXXXXXX/myContainer 
        -X POST -H "X-Container-Sync-Key: $sharedKey" -H "Content-Length: 0" 
        -H "X-Auth-Token: abcd1234" 
        -H "X-Container-Sync-To: https://storage.sbg1.cloud.ovh.net/v1/AUTH_YYYYYYYYY/myContainer"
```
