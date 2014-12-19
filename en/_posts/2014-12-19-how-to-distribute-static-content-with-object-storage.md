---
layout: post
title:  "How to distribute static content with Object Storage"
categories: Object-Storage
author: ArnaudJost
lang: en
---

Maybe you have a website with big files (images, movies...) and it is difficult to store and serve them efficiently because of files size or traffic. In this guide, you will discover how to configure RunAbove Object Storage to serve static websites.

Runabove Object Storage is very scalable and efficient to store content. You can use the static-web feature to serve files from it exactly like a web-server, but without having to manage a server, Runabove Object Storage will handle the traffic and the load for you.

Prerequisites
-------------

* [Python](https://www.python.org) installed on your computer and OpenStack [Object Storage client](https://github.com/openstack/python-swiftclient)

or

* Curl on Unix

CNAME
-----

To keep both OpenStack and static-web mode working together on the Object Storage, you must use a valid [CNAME](/kb/en/object-storage/how-to-put-object-storage-behind-your-domain-name.html) in your request to use static-web features. If you use an OpenStack Object Storage URL directly (like `http://storage.bhs-1.runabove.io/v1/AUTH_ABCD/container/object`), RunAbove Object Storage will consider that you want to use Object Storage mode instead of static-web mode. Once you configured your `CNAME` or `TXT` field, you can continue with this guide.

Create your container
---------------------

First create the container that will store your files, it will be called `web` (curl usage):

```curl -X PUT -H "X-Auth-Token: $TOKEN" https://storage.sbg-1.runabove.io/v1/AUTH_ACBD/web/```

First create the container that will store your files, it will be called `web` (swift-client usage):

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U login:tenant -K pass post web```

Configure your container for static-web hosting
-----------------------------------------------

You have to set some specific headers on your container to enable static-web features.

First, you have to choose between `web-index` or `listing` mode. If you make a request to your container without any object, the first one will redirect you to the page given in the headers, exactly like a web-server, the second one will list the container content.

If you prefer web-index (curl usage):

```curl -X POST -H "X-Container-Meta-Web-Index: index.html" -H "X-Auth-Token: $TOKEN" https://storage.sbg-1.runabove.io/v1/AUTH_ACBD/web/```

If you prefer web-index (swift-client usage):

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U login:tenant -K pass post --header "X-Container-Meta-Web-Index: index.html" web```

If you prefer listing (curl usage):

```curl -X POST -H "X-Container-Meta-Web-Listings: true" -H "X-Auth-Token: $TOKEN" https://storage.sbg-1.runabove.io/v1/AUTH_ACBD/web/```

If you prefer listing (swift-client usage):

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U login:tenant -K pass post --header "X-Container-Meta-Web-Listings: true" web```

When using listing, you can upload a CSS file, which will be used to display files listing. In this case, upload the CSS, then add the specific header.

Add specific header for CSS (curl usage):

```curl -X POST -H "X-Container-Meta-Web-Listings-CSS: listing.css" -H "X-Auth-Token: $TOKEN" https://storage.sbg-1.runabove.io/v1/AUTH_ACBD/web/```

Add specific header for CSS (swift-client usage) :

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U login:tenant -K pass post --header "X-Container-Meta-Web-Listings-CSS: listing.css" web```

You can also configure your own error pages. Upload your page, with this name pattern (another pattern will not work) : ```{ERR}{FILENAME}.html```.
For example : 404error.html, 503error.html.

Put the specific header (curl usage):

```curl -X POST -H "X-Container-Meta-Web-Error: error.html"  -H "X-Auth-Token: $TOKEN" https://storage.sbg-1.runabove.io/v1/AUTH_ACBD/web/```

Put the specific header (swift-client usage):

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U login:tenant -K pass post --header "X-Container-Meta-Web-Error: error.html" web```

You can change error.html with another page name.  
Now, you should probably allow everyone to access to this container (like a web-server). That's time to set up container ACLs.

Configure ACL to allow public access to your container
------------------------------------------------------

If you have enabled listing (curl usage):

```curl -X POST -v -H "X-Container-Read: .r:*,.rlistings" -H "X-Auth-Token: $TOKEN" https://storage.sbg-1.runabove.io/v1/AUTH_ACBD/web/```

If you have enabled listing (swift-client usage):

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U login:tenant -K pass post --header  "X-Container-Read: .r:*,.rlistings" web```

If you  have not enabled listing, and prefer ""X-Container-Meta-Web-Index" header (curl usage):

```curl -X POST -v -H "X-Container-Read: .r:*" -H "X-Auth-Token: $TOKEN" https://storage.sbg-1.runabove.io/v1/AUTH_ACBD/web/```

If you  have not enabled listing, and prefer ""X-Container-Meta-Web-Index" header (swift-client usage):

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U login:tenant -K pass post --header  "X-Container-Read: .r:*" web```

Conclusion
----------

You can now serve files from RunAbove Object Storage like from a traditional web server. Your website can grow to an unlimited size and absorb very high traffic loads. Of course you can only serve static files, but with recent web technologies, it is common to find static website. For instance, this knowledge base is a fully static website generated by [Jekyll](http://jekyllrb.com).
