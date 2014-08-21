---
layout: post
title:  "How to use RunAbove API?"
categories: Instances
author: VincentCasse
lang: en
---
RunAbove has been designed to help developers in building scalable software faster. To create applications with our product, we provide an API for each of our products. But, how do you use our api ?

# API capabilities

To discover all possibilities of our APIs, you could use the automated console available here : [https://api.runabove.com/console/](https://api.runabove.com/console/). In the  console, you can see the documentation of APIs and you can test each of the calls available .

__Note__ : The RunAbove API is designed to be very simple. If you want to deal directly with Openstack API, you can authenticate with Keystone in [https://auth.runabove.io/](https://auth.runabove.io/).

More information about how to use Openstack APIs for [Object Storage](http://developer.openstack.org/api-ref-objectstorage-v1.html), [Instances](http://developer.openstack.org/api-ref-compute-v2.html) and [Authentication](http://developer.openstack.org/api-ref-identity-v2.html)

# How to authenticate a user?

First, you have  to declare your application in the API to be authorized to communicate with RunAbove API. To declare a new application, you can fill  in the form found at the following page : [https://api.runabove.com/createApp/]( https://api.runabove.com/createApp/). This application will be linked to your account with a specific name and description. You need to save your _application key_ and _application secret_ to identify your requests.

If you want to develop an application with RunAbove API, you have to use a token, called a  _consumer key_ for each API's request. To get this token, you must go to this url [https://api.runabove.com/1.0/auth/credential](https://api.runabove.com/1.0/auth/credential) with some data  inside the body of the request:

```bash
curl    -X POST \
        -H 'X-Ra-Application: z5czlUfqJL6HsYKj' \
        -H 'Content-Type: application/json' \
        -d '{ \
            "accessRules": \
                [ \
                    { "method":"GET","path":"/me"} \
                ], \
                "redirection":"http://runabove.com" \
            }' \
        "https://api.runabove.com/1.0/auth/credential"
```

This request contains your application key included in metadata and requires that the access rules be listed inside the body.

Access rules define which call will be authorized when the consumer key is used. For example, here, the application can only call /me but you can add requests as required. You can precisely define which calls each app has access to: you can use regex to declare with request will be authorize in the consumer key. If you want get vnc console of all your instances, you could authorize your application with this accessRules :

```bash
{ "method":"GET","path":"/instance/*/vnc"}
```

In return to this request, you will get the consumer key and a url. In this url, a user can validate the consumer key with their authentication.

# How to call the API?

Now that you have the  application's credentials and consumer key validated, by user login, you can call our API. For example to get a list of your instances.
To do this, you need to send a request to  [https://api.runabove.com/1.0/instance](https://api.runabove.com/1.0/instance) with the the following.

```bash
$ curl  -XGET
        -H 'X-Ra-Application:your_application_key' \
        -H 'X-Ra-Timestamp:current_timestamp'   \
        -H 'X-Ra-Signature:generated_signature' \
        -H 'X-Ra-Consumer:the_consumer_key'  \
        https://api.runabove.com/1.0/instance
```

To reduce differences between your local timestamp and timestamp inside API's servers, you can get the current timestamp of our servers with a call on [https://api.runabove.com/1.0/auth/time](https://api.runabove.com/1.0/auth/time).

```bash
$ curl https://api.runabove.com/1.0/auth/time
  1400000000
```

With this information, you can calculate the difference between timestamps and add it on your local timestamp on each request.

Signature is a sha1, in hexadecimal format, composed by a string with some information separated by _+_ character: your application secret, the consumer key, HTTP verb, query, body of the request and timestamp.

```bash
$ echo -n "your_application_key+GET+https://api.runabove.com/1.0/instance/++1400000000" | openssl dgst -sha1
d33fced42c337a8dfc15d6b7a8e0c588d3a0f62f
```

# Congratulations!

You have your first request on RunAbove API! Now you can create applications on object storage or automate your infrastructure with some creation of new instances!