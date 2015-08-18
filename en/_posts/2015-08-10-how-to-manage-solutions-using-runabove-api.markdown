---
layout: post
title:  "How to manage solutions using RunAbove API"
categories: iot
author: DavidTONeill
lang: en
---

# Introduction

In this tutorial we assume you already have a RunAbove Account and have subscribed to the IoT lab.
We use the curl command to illustrate examples.
To use the RunAbove API, your application must be authenticated with it. To do so you can read the 
 [How to use RunAbove API?](https://community.runabove.com/kb/en/instances/how-to-use-runabove-api.html) tutorial.
 
## What is a solution?
 
A solution is a container for your data and has a set of tokens to manage this data. 
You can separate your data in different solutions or keep it in a single container depending on your need. 
As example, you could create a solution named 'house-temperature' that contains one token per sensor. 
You can also create a solution named 'Cellar' that will contain one token for humidity and temperature respectively.
 
## What is a token?
 
Tokens are used for authentication and authorization. 
They have a write key (used to push data) and a read key (used to retrieve data). 
Each token belong to a specific solution.

# How to create a new solution
 
```bash
$ curl  -X POST
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp'   \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key'  \
        -d '{"cluster":"the cluster name",
            "description":"the_solution_description",
            "name":"the_solution_name"}' \
        https://api.runabove.com/1.0/iot/app
```

  * cluster: The cluster is the location where your data is stored, please note that you cannot change the cluster after creation.
  * description: the description you want to assign to your solution.
  * name: the name you want to assign to your new solution. It can contain letters, numbers and dash '-' characters only.
  
# How to modify a solution

```bash
$ curl  -X PUT
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp'   \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key'  \
        -d '{"description":"the solution description"}' \
        https://api.runabove.com/1.0/iot/app/your_solution_name
```

  * description: the description you want to assign to your solution.
  * your_solution_name: the name you want to assign to your new solution. It can contain letters, numbers and dash '-' characters only.
  
# How to delete a solution

```bash
$ curl  -X DELETE
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp'   \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key'  \
        https://api.runabove.com/1.0/iot/app/your_solution_name
```

  * your_solution_name: the name of the solution you want to delete.


# How to create a new Token
 
```bash
$ curl  -X POST
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp'   \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key'  \
        -d '{"description":"a description","endDate":"the expiration date"}' \
        https://api.runabove.com/1.0/iot/app/your_solution_name/token
```

  * your_solution_name: the_solution_name which will reside the token.
  * description: the description of the token.
  * endDate: endDate format is a unix timestamp based on seconds since standard epoch of 01/01/1970.
  * tagList: the tags of your token.

# How to modify a token

```bash
$ curl  -X PUT
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp'   \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key'  \
        -d '{"description":"the solution description",
        "tagList":[{"name":"a tag key","value":"a tag value"},{"name":"another tag key","value":"another tag value"}]}' \
        https://api.runabove.com/1.0/iot/app/the_solution_name/token/the token name
```

  * the_solution_name: the name of the solution hosting the token. This value cannot be changed
  * the token name: the name of the token you want to modify.
  * description: the description of the token.
  * tagList: the tags of your token. If you don't enter old tags they will be dropped during the update. IT is an array on name/value pair.
  
# How to delete a token

```bash
$ curl  -X DELETE
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp'   \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key'  \
        https://api.runabove.com/1.0/iot/app/your_solution_name/token/your token name
```

  * your_solution_name: the name of the solution you want to delete.
  * your token name: the name of the token you want to modify.
  
# How to retrieve my tokens

```bash
$ curl  -X GET
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp'   \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key'  \
        https://api.runabove.com/1.0/iot/app/your_solution_name/token
```

* your_solution_name: the_solution_name which reside the tokens you want to retrieve.
