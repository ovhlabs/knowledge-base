---
layout: post
title:  "How to create a MySQL Managed Stack using the API"
categories: Labs
author: popawu
lang: en
---

In this guide you will learn how to create your Managed Stacks MySQL cluster using the API.

Requirements
============

- applicationKey, consumerKey and signature generated for OVH API access. You will also need to manage timestamps. You can find details on the [first step with the OVH API page.][1]

For the sake of command lines' brevity you can define this helpful aliases to interact with Managed Stacks API.

```bash
user@desk:~$ MANAGEDSTACKS_LAB=https://api.runabove.com/1.0
user@desk:~$ alias auth_curl='curl --include -H "X-Ovh-Application:$applicationKey" -H "X-Ovh-Timestamp:$time" -H "X-Ovh-Signature:$signature" -H "X-Ovh-Consumer:$consumerKey" -H "Content-Type: application/json"'
```

Create MySQL Managed Stack
===========================

- CALL
```bash
user@desk:~$ auth_curl -X POST ${MANAGEDSTACKS_LAB}/stackMysql
```

- RETURN
```json
{
    "msg": "cluster created"
}
```

Get your cluster's id
=====================

- CALL
```bash
user@desk:~$ auth_curl -X GET ${MANAGEDSTACKS_LAB}/stackMysql
```

- RETURN
```json
{
  "products": [
    {
      "id": <clusterId>
    }
  ]
}
```

Get informations about your cluster
===================================

- CALL
```bash
user@desk:~$ auth_curl -X GET ${MANAGEDSTACKS_LAB}/stackMysql/<clusterId>
```

- RETURN
```json
{
  "active": <true|false>,
  "nodes": [
    {
      "addr": "<ipAddressNode1>",
      "product_id": <productId>
    },
    {
      "addr": "<ipAddressNode2>",
      "product_id": <productId>
    }
  ],
  "product_id": <productId>
}
```

Get monitoring status information about your cluster
====================================================


- CALL
```bash
user@desk:~$ auth_curl -X GET ${MANAGEDSTACKS_LAB}/stackMysql/<clusterId>/status
```

- RETURN
Json object, list of probes for each node. The object key is the probe name, object value is the result.

Delete your cluster
===================

- CALL
```bash
user@desk:~$ auth_curl -X DELETE ${MANAGEDSTACKS_LAB}/stackMysql/<clusterId>
```

- RETURN
```json
{
  "msg": "cluster deleted"
}
```

Go further
==========

You may have a look at:

- Guide: [Create MySQL Managed Stack from RunAbove manager][2]

[1]: https://api.ovh.com/g934.first_step_with_api
[2]: create-mysql-managed-stack.html
