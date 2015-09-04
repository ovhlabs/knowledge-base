---
layout: post
title:  "How to manage applications using RunAbove API"
categories: iot
author: DavidTONeill
lang: en
---

# Introduction

In this tutorial we assume you already have a RunAbove Account and have subscribed to the IoT lab.
We also assume that you have read the first documentation [How to manage applications using manager](how-to-manage-applications-using-runabove-manager.html).
We use the curl command to illustrate examples.
To use the RunAbove API, your application must be authenticated with it. To do so you can read the
 [How to use RunAbove API?](https://community.runabove.com/kb/en/instances/how-to-use-runabove-api.html) tutorial.

# How to create a new application

```bash
$ curl  -X POST
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp' \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key' \
        -H 'Content-Type: application/json' \
        -d '{"cluster":"the cluster name",
            "description":"application_description",
            "name":"application_name"}' \
        https://api.runabove.com/1.0/iot/app
```

  * cluster: The cluster is the location where your data is stored, please note that you cannot change the cluster after creation.
  * description: the description you want to assign to your application.
  * name: the name you want to assign to your new application. It can contain letters, numbers and dash '-' characters only.

# How to modify an application

```bash
$ curl  -X PUT
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp' \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key' \
        -H 'Content-Type: application/json' \
        -d '{"description":"the application description"}' \
        https://api.runabove.com/1.0/iot/app/application_name
```

  * description: the description you want to assign to your application.
  * application_name: the name you want to assign to your new application. It can contain letters, numbers and dash '-' characters only.

# How to delete an application

```bash
$ curl  -X DELETE
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp' \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key' \
        https://api.runabove.com/1.0/iot/app/application_name
```

  * application_name: the name of the application you want to delete.


# How to create a new Token

```bash
$ curl  -X POST
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp' \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key' \
        -d '{"description":"a description","endDate":"the expiration date"}' \
        https://api.runabove.com/1.0/iot/app/your_application_name/token
```

  * your_application_name: application_name in which will reside the token.
  * description: the description of the token.
  * endDate: endDate format is a unix timestamp based on seconds since standard epoch of 01/01/1970.
  * tagList: the tags of your token.

# How to modify a token

```bash
$ curl  -X PUT
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp' \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key' \
        -H 'Content-Type: application/json' \
        -d '{"description":"the application description",
        "tagList":[{"name":"a tag key","value":"a tag value"},{"name":"another tag key","value":"another tag value"}]}' \
        https://api.runabove.com/1.0/iot/app/application_name/token/token_name
```

  * application_name: the name of the application hosting the token. This value cannot be changed
  * token_name: the name of the token you want to modify.
  * description: the description of the token.
  * tagList: the tags of your token. If you don't enter old tags they will be dropped during the update. IT is an array on name/value pair.

# How to delete a token

```bash
$ curl  -X DELETE
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp' \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key' \
        https://api.runabove.com/1.0/iot/app/your_application_name/token/your_token_name
```

  * your_application_name: the name of the application you want to delete.
  * your_token_name: the name of the token you want to modify.

# How to retrieve my tokens

```bash
$ curl  -X GET
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp' \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key' \
        https://api.runabove.com/1.0/iot/app/your_application_name/token
```

* your_application_name: application_name in which resides the tokens you want to retrieve.
