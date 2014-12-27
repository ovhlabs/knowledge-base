---
layout: post
title:  "How to use Object Storage as media server for your website"
categories: Object-Storage
author: Tobiaqs
lang: en
---

Regular cheap web hosts normally don't offer a lot of space and more often limit data traffic. When you do need to serve large video files to your visitors, an external *Content Delivery Network* can come in handy. RunAbove is well-suited for this job.

# Part 1: Uploading your files #
Before integrating RunAbove in your website, you'll need to upload some files to the cloud. You can do this using the RunAbove control panel (Expert Mode). Once you're in, go to containers.

![Control panel screenshot](http://i.imgur.com/ZAIobgM.png)

Here you can create a container for your website. Let's call it *test* for now, and we'll set it to be a public container. You can now upload files to it. I'll upload a file called *video.mp4*. Object Storage doesn't support folders, but you can create pseudo-folders, which act similarly.

**Note: once you upload a file to a container, its name cannot be changed, nor can the file be moved to another container. That's how it works. But there's a way around: you can make a copy of the file that has a different name and/or parent container, and then remove the original file from its container.**

Now that we've got our files uploaded, let's go to the Access & Security page, tab API Access. Here you'll see the Object Storage endpoint associated with your account. In this tutorial we'll assume that the following is our Object Storage endpoint:

https://storage.sbg-1.runabove.io/v1/AUTH_tenant

We can now access our file *video.mp4* in our container *test*:

**https**://storage.sbg-1.runabove.io/v1/AUTH_tenant/**test**/**video.mp4**

Keep the Object Storage endpoint handy somewhere. You'll need it in the next part.

# Part 2: Expiring URLs #
When uploading videos to your website, it's desirable that people actually watch that video on your website. There are multiple legitimate reasons for this, e.g. displaying advertisements, tracking user sessions and allowing the user to select a video resolution. How can we prevent people from sharing direct links to your video files? OpenStack provides support for temporary URLs. These URLs expire after a while. I'll explain how you can generate these URLs in PHP - the most commonly supported scripting language on web hosts - and how to set up your container.

Head off to the containers page. To the right of the *test* container, click *Make Private*:

![Making a container private](http://i.imgur.com/y4JIVR7.png)

Now files can't be accessed without a temporary signature. Let's set up our website!

Before we can create our temporary signatures, we have to configure a secret key, so that other people can't create signatures on their own. This tutorial makes use of a PHP script to take care of that, since we're already in a PHP-friendly environment. Check out the script and its ReadMe [here](https://github.com/Tobiaqs/runabove-set-tempurl-key).

Here comes the actual coding. To create a temporary signature, we'll need the following parameters: the method of which use will be allowed, the timestamp on which the signature will expire, and the path of the URL we want to share. All of these parameters will be passed to a hashing function, as well as our secret key. Here's an example:

    $expireAt = time() + 60; // Users will be able to use the URL for 60 seconds

    $secretKey = "HeyNSA";

	$url = "https://storage.sbg-1.runabove.io/v1/AUTH_tenant/test/video.mp4";
	$urlParts = parse_url($url);
	$path = $urlParts['path']; // /v1/AUTH_tenant/test/video.mp4

	$hash = hash_hmac('sha1', sprintf("%s\n%d\n%s", "GET", $expireAt, $path));
	$url .= "?temp_url_sig={$hash}&temp_url_expires={$expireAt}";

Seems easy, right? $url now contains a signed URL, which will no longer be usable after 60 seconds. You can use this URL in your HTML.

# Part 3: Using your own domain #
RunAbove allows you to bind a subdomain of your own domain name to a container. Here's how it works:


*test.auth-tenant.storage.sbg-1.runabove.io* is the subdomain that is automatically bound to the container test of your tenant ID (the long array of characters after AUTH_). You can create a CNAME record in your domain's DNS settings that points to this subdomain.

Files in the container can be accessed like this:

**http**://test.auth-tenant.storage.sbg-1.runabove.io/video.mp4

or

**http**://files.mydomain.com/video.mp4

So when creating a temporary signature for this file, I'd use the path... /video.mp4, right? Wrong. You have to use the path you would use without making use of the subdomain technique. In this case, you would use /v1/AUTH_tenant/test/video.mp4 as path when creating the signature. Here's how you could do it:
	
	$file = "video.mp4";

	$url = "https://storage.sbg-1.runabove.io/v1/AUTH_tenant/test/{$file}";
	$urlParts = parse_url($url);
	$path = $urlParts['path']; // /v1/AUTH_tenant/test/video.mp4

	$hash = hash_hmac('sha1', sprintf("%s\n%d\n%s", "GET", $expireAt, $path));
	$url = "http://files.mydomain.com/{$file}?temp_url_sig={$hash}&temp_url_expires={$expireAt}";