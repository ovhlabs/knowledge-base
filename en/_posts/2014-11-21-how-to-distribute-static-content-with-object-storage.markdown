---
layout: post
title:  "How to distribute static content with Object Storage"
categories: Object-Storage
author: ArnaudJost
lang: en
---

You could have a nice website with big files (like images, movies..) and it's difficult to store them and serve them efficiently, because of files size, or because a lot of people like your website! Runabove Object Storage is very scalable and efficient to store content. How to get the best from both worlds? You can use Runabove Object Storage static-web feature to serve files from Runabove Object Storage exactly like a web-server, but without anxiety about your server management, Runabove Object Storage will handle the traffic and the load for you.

In this guide, you'll discover how to configure a container to be used in static-web mode.

Prerequistes:
--------------

* Python installed on your computer (https://www.python.org/)
* Openstack Object Storage client (https://github.com/openstack/python-swiftclient) or Curl on linux

Important:
-----------

To keep both openstack and static-web mode working together on Runabove Object Storage, you must use a valid cname in your request to use static-web features. If you use an Openstack Object Storage url directly (like http://storage.bhs-1.runabove.io/v1/AUTH_ABCD/container/object), Runabove Object Storage will consider that you want to use Object Storage mode instead of static-web mode. When you had configure your CNAME or TXT field, you can continue this how-to!

Configure your container for static-web:
-----------------------------------------

You have to set some specific headers on your container to enable static-web features.
First, you have to choose between 'web-index' or 'listing' mode. If you make a request to your container without any object, the first one will redirect you to the page given in the headers(like an web-server), the second one will list the container content.

If you prefer web-index (curl usage):

```curl -X POST -H "X-Container-Meta-Web-Index: index.html" -H "X-Auth-Token: $TOKEN" https://storage.sbg-1.runabove.io/v1/AUTH_ACBD/web/```

If you prefer web-index (swift-client usage):

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U login:tenant -K pass post --header "X-Container-Meta-Web-Index: index.html" web```

If you prefer listing (curl usage):

```curl -X POST -H "X-Container-Meta-Web-Listings: true" -H "X-Auth-Token: $TOKEN" https://storage.sbg-1.runabove.io/v1/AUTH_ACBD/web/```

If you prefer listing (swift-client usage):

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U login:tenant -K pass post --header "X-Container-Meta-Web-Listings: true" web```

When using listing, you can upload a css, which will be used to display files listing. 
In this case, upload the css, then add the specific header.

Add specific header for css (curl usage):

```curl -X POST -H "X-Container-Meta-Web-Listings-CSS: listing.css" -H "X-Auth-Token: $TOKEN" https://storage.sbg-1.runabove.io/v1/AUTH_ACBD/web/```

Add specific header for css (swift-client usage) :

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U login:tenant -K pass post --header "X-Container-Meta-Web-Listings-CSS: listing.css" web```

You can also configure your own error pages. Upload your page, with this name pattern (another pattern will not work) : ```{ERR}{FILENAME}.html```.
For example : 404error.html, 503error.html..

Put the specific header (curl usage):

```curl -X POST -H "X-Container-Meta-Web-Error: error.html"  -H "X-Auth-Token: $TOKEN" https://storage.sbg-1.runabove.io/v1/AUTH_ACBD/web/```

Put the specific header (swift-client usage):

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U login:tenant -K pass post --header "X-Container-Meta-Web-Error: error.html" web```

You can change error.html with another page name. 
Now, you should probably allow everyone to access to this container (like a web-server). That's time to set up container ACLs!

Configure acl to allow public access to your container:
--------------------------------------------------------

If you have enabled listing (curl usage):

```curl -X POST -v -H "X-Container-Read: .r:*,.rlistings" -H "X-Auth-Token: $TOKEN" https://storage.sbg-1.runabove.io/v1/AUTH_ACBD/web/```

If you have enabled listing (swift-client usage):

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U login:tenant -K pass post --header  "X-Container-Read: .r:*,.rlistings" web```

If you  have not enabled listing, and prefer ""X-Container-Meta-Web-Index" header (curl usage):

```curl -X POST -v -H "X-Container-Read: .r:*" -H "X-Auth-Token: $TOKEN" https://storage.sbg-1.runabove.io/v1/AUTH_ACBD/web/```

If you  have not enabled listing, and prefer ""X-Container-Meta-Web-Index" header (swift-client usage):

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U login:tenant -K pass post --header  "X-Container-Read: .r:*" web```

Conclusion:
------------
You can now serve files from Runabove object Storage exactly like from another web server. Of course, you can use only static files. But with recent web technologies, it's common to find static website. For instance, this knowledge base is fully static website generated from markdown by Jekyll!
