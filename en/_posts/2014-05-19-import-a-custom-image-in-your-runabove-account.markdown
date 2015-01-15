---
layout: post
title:  "Import a custom image in your RunAbove Account"
categories: Instances
author: NicolasLM
lang: en
---
By default, RunAbove proposes different operating systems. If you need to launch an instance of a particular operating system, you can add an image very easily to your RunAbove account.

# How do you add a custom operation system?

You just need to go to [OpenStack Horizon](https://cloud.runabove.com/horizon), in the "__Image__" tab and then, click on "__Create Image__". A pop-up will ask you for a few details about the system that you want to create and where to find the image itself.

![Control panel screenshot](https://community.runabove.com/public/files/r84vLoKPpLjvd9uHnjBp.png)

 * The __name__ and __description__ should describe the system you want to upload.
 * The __image source__ can be a public location on the web or a local file on your computer.
 * The __format__ describes the virtual disk type of the image. The most common ones are Raw and Qcow2.
 * The others parameters are optional.

Just click on "__Create Image__", if you create an image from a local file it will be uploaded, otherwise it will be fetched from the location you specified.

You can now find your custom system in the “__Image__” field when you launch instances. If you need a customized image you can [easily create it for RunAbove](/kb/en/instances/how-to-create-a-custom-image-for-runabove.html).
