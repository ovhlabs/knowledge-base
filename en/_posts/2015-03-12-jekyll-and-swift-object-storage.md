---
layout: post
title: "Jekyll and Runabove Swift Object Storage"
categories: Object Storage
author: e-ravel
lang: en
---

#Jekyll and Runabove Swift Object Storage.

Generally when it comes to maintaining an online presence your options are: Fast, Good, and Cheap. The caveat being that you can only pick any two.

By moving away from dynamically generated content one can benefit from blazing fast delivery, highly available replicated storage, at minimal cost.

##Services and Tools.

- [Runabove](https://www.runabove.com/) Swift Object Storage
- [Jekyll](http://jekyllrb.com/) Simple Static Blog-aware Static Sites
- [Rclone](http://rclone.org/) Rsync for Cloud Storage

##Prerequisites.

Things you will need:

- a clean (Ubuntu) Linux installation.
- a domain name.
- a Runabove account.

##Local Setup.

To install the packages and the dependencies you will need:

```bash
sudo apt-get install ruby-dev golang nodejs git mercurial python-swiftclient
```

Finally install Jekyll:

```bash
sudo gem install jekyll
```

If you fancy using Sass CSS preprocessing (optional):

```bash
sudo gem install sass
```

#Runabove Object Storage.

The easiest way to communicate with the Swift Object Storage on Runabove (GUI asside) is with the swiftclient. To export the information you need to authenticate with the Swift API you can run tenantid-openrc.sh.

##To get this file [[1]](https://community.runabove.com/kb/en/object-storage/upload-your-first-object-inside-swift.html):

Log in on runabove, select OpenStack Horizon, go into Access & Security panel, then into API Access tab. Once there you can click on: Download OpenStack RC File.


##It should look something like this:

[runabove-openstack-rc]:/images/2015-03-12-jekyll-and-swift-object-storage/runabove-openstack-rc.png "openstack.rc" 

```bash
source *-openrc.sh
export OS_REGION_NAME="SBG-1"
```

##Runabove Object Storage Container Setup.

First we want to check if swiftclient can communicate with the Object Storage.

```bash
swift stat
```

It should return something along the lines of:

```bash
$ swift stat
       Account: AUTH_11111111111111111111111111111111
    Containers: 0
       Objects: 0
         Bytes: 0
 Accept-Ranges: bytes
    Connection: close
   X-Timestamp:
    X-Trans-Id:
  Content-Type: text/plain; charset=utf-8
```

Please make a note of the Account: AUTH_, you will need it later.

##Creating Object Storage Containers.

Why create one container when you can have two? You will want to have one container to redirect your (www.example.com) subdomain to your (example.com) main domain.

```bash
swift post "redirect"
swift post "example_com"
```

Lets put the container ACL to public this being the internet after all.

```bash
swift post --header "X-Container-Read: .r:*" redirect
swift post --header "X-Container-Read: .r:*" example_com
```


#Setting up a redirect.

The merit of using Meta Refresh for redirections with regards to SEO have long been debated, it is by all means not the most optimal or elegant of solutions, however since we can't return HTTP 301 using static pages the below will have to do.

Create an `index.html` file with containing:

{% highlight html %}
<!DOCTYPE HTML>
<html lang="en-US">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="refresh" content="1;url=http://example.com">
        <script type="text/javascript">
            window.location.href = "http://example.com"
        </script>
        <title>Page Redirection</title>
    </head>
    <body>
        <!-- Note: don't tell people to `click` the link, just tell them that it is a link. -->
        If you are not redirected automatically, follow the link to: <a href='http://example.com'>Example.com</a>.
    </body>
</html>
{% endhighlight %}

Now that this is saved as index.html, lets upload it to Object Storage.

```bash
swift upload redirect index.html
```

#Domain and DNS [[2]](https://community.runabove.com/kb/en/object-storage/how-to-put-object-storage-behind-your-domain-name.html)
.

We want to put our static website on a domain (example.com), now we're going to assume that you can already manage your domains DNS-zone and that all that is left to be done is getting your domain to use the Runabove Object Storage as origin.

You will want to have the following records:

```
@ A	5.196.247.208
@ A	5.196.247.192
CNAME: www storage.sbg-1.runabove.io.
TXT: _swift-remap example_com.AUTH-111111111111.storage.sbg-1.runabove.io.
TXT: _swift-remap.www redirect.AUTH-111111111111.storage.sbg-1.runabove.io.
```

Where @ represents your domain root.

#Jekyll.

Jekyll is a simple, blog-aware, static site generator. It takes a template directory containing raw text files in various formats, runs it through a converter (like Markdown) and its Liquid renderer, and spits out a complete, ready-to-publish static website suitable for serving with your favourite web server.

#Setting up a Jekyll Site.

We want to create a simple site with Jekyll, all it takes is the following:

```bash
jekyll new example_com
cd example_com
jekyll serve
```

Using your favourite browser and navigating to `http://localhost:4000` will now display a stock Jekyll Site.

We're going to skip customizing the Jekyll pages itself, if you're curious on how to go about this the [Jekyll Documentation](http://jekyllrb.com/docs/home/) is extensive and contains all you will need to know.

#Rclone.

Rclone is a command line program to sync files and directories to and from cloudstorage solutions.

We want to use Rclone as it offers an easy way to sync our Jekyll _site to Runabove Object Storage. Whilst the same could be achieved with swiftclient, Rclone shines in being able to list the files on the Object Storage and only upload the files that have either been modified or newly created. To top it off, it will take care of removing files that are no longer there, saving us from the headache of manually removing these files with the swiftclient.

##Setting up Rclone.

Rclone is written in Golang, which means we need to tell GO where to download and build packages.

```bash
export GOPATH="$HOME/dev/go/"
```

We can now build Rclone

```bash
go get github.com/ncw/rclone
```

Lastly we copy Rclone to our /usr/bin/ so that we can easily launch it in a terminal.

```bash
cd $GOPATH/bin
sudo cp rclone /usr/bin/
```

##Rclone Configuration.

Rclone will do us no good if not configured for use with Runabove Object Storage.

You will need the following information:

- your Runabove account (email address)
- your Runabove key (password)
- your Runabove tenant name (1234568)
- the Runabove AUTH url (https://auth.runabove.io/v2.0)
- the Runabove Region you're using (we have used SBG-1)

Lets run:

```bash
rclone config
```

```bash
Failed to load config file /home/example/.rclone.conf - using defaults
No remotes found - make a new one
n) New remote
q) Quit config
n/q> n
name> runabove
What type of source is it?
Choose a number from below
 1) swift
 2) s3
 3) local
 4) google cloud storage
 5) dropbox
 6) drive
type> 1
User name to log in.
user> runabove-account@example.com
API key or password.
key> ****
Authentication URL for server.
Choose a number from below, or type in your own value
 * Rackspace US
 1) https://auth.api.rackspacecloud.com/v1.0
 * Rackspace UK
 2) https://lon.auth.api.rackspacecloud.com/v1.0
 * Rackspace v2
 3) https://identity.api.rackspacecloud.com/v2.0
 * Memset Memstore UK
 4) https://auth.storage.memset.com/v1.0
 * Memset Memstore UK v2
 5) https://auth.storage.memset.com/v2.0
auth> https://auth.runabove.io/v2.0
Tenant name - optional
tenant> 12345678
Region name - optional
region> SBG-1
Remote config
--------------------
[runabove]
user = runabove-account@example.com
key = ****
auth = https://auth.runabove.io/v2.0
tenant = 12345678
region = SBG-1
--------------------
y) Yes this is OK
e) Edit this remote
d) Delete this remote
y/e/d> y
Current remotes:

Name                 Type
====                 ====
runabove             swift

e) Edit existing remote
n) New remote
d) Delete remote
q) Quit config
e/n/d/q>
```

Lets double check the Rclone configuration for good measure.

```bash
cat ~/.rclone.conf
[runabove]
type = swift
user = runabove-account@example.com
key = ****
auth = https://auth.runabove.io/v2.0
tenant = 12345678
region = SBG-1
```

#Sync a Jekyll Site to Runabove Object Storage.

You have entered a bunch of commands and so far you have little to show for exempt a blank page on your domain. It is time to build the Jekyll Site and get it online.

You could of course run `jekyll build` in your `example_com` folder, or you could write a bash script to do it for you.

{% highlight sh %}
#! /bin/bash

# _sync.sh

echo "Building site."
jekyll build --source example_com --destination example_com/_site
echo "Build complete!"

echo "Deploying to Object Storage."
rclone -v sync example_com/_site/ runabove:example_com
echo "Deploy complete!"

{% endhighlight %}

Place `sync.sh` below the `example_com` folder and make it executable `chmod +x sync.sh`.

#You're good to go!

Launch `./sync.sh` and Jekyll will build your site and place the static documents in `_site`, Rclone will then sync `_site` with your Object Storage and place your files in the example_com Container.


-----
Sources:

*1 [Upload your first object inside Openstack Swift - Runabove](https://community.runabove.com/kb/en/object-storage/upload-your-first-object-inside-swift.html)

*2 [How to put Object Storage behind your domain name? - Runabove](https://community.runabove.com/kb/en/object-storage/how-to-put-object-storage-behind-your-domain-name.html)

