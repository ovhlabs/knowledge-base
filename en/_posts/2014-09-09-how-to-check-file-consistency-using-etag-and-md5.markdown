---
layout: post
title: "How to check file consistency using ETag and md5"
categories: Object-Storage
lang: en
author: ArnaudJost
---

When you store lot of objects on Object Storage, it can be very useful to compare local files and remote objects. Sometimes, just to ensure that the object is up to date, but also to check data consistency. Object Storage use md5 as internal control method, but also expose md5 to users, allowing them to control their objects themselves.


__MD5:__ is a "message digest" algorithm used as a hash function to validate the integrity of a file. A file will always give the same md5 (for example, using md5sum command on Linux).

# Prerequistes:

 * Python installed on your computer (https://www.python.org/)
 * md5sum installed
 * Openstack Object Storage client (https://github.com/openstack/python-swiftclient)
 * Curl on linux

# Upload an object with integrity check with curl

You can specify the md5 of the file you currently upload using curl and a special header named  "ETag". If this header exist in your PUT request, Object Storage will compare the md5 on remote object and given md5 in the header. If they are not identical, Object Storage will return a HTTP 422 (Unprocessable entity) error. This is very useful to ensure that there was no corruption during upload.
Using a md5 tool, like md5sum on linux, get the md5 of your file, locally:

```bash
md5sum file
b6d81b360a5672d80c27430f39153e2c  file
```

Add the special header "Etag" to your post request which contain the md5:

```bash
curl -X PUT\
     -T file \
     -H "X-Auth-Token: abcd" \
     -H "Etag: b6d81b360a5672d80c27430f39153e2c" \
     https://storage.bhs-1.runabove.io/v1/AUTH_1234/default/file
```

If curl returns an http 201, your file was successfully written on Object Storage. If curl answers with an http 422, it means something went wrong during upload you should try again, check your local file, or check your internet connectivity.

# Download only modified files using special headers

Object Storage also support another great headers : 'If-None-Match' and 'If-Match'. These headers allow Object Storage to check the md5 of an object and compare it to a given md5 in header to ensure that a local file is still the same as a remote object, or not. If needed, Swift will download the object, but if md5 are the same, Swift will pass it, to save time and bandwidth while downloading severals files.
This system is a very easy way to create a cache system because browsers use natively Etag system. You can imagine storing your website on Object Storage for instance !

__If-None-Match:__ download the remote object if it's md5 is different that the one you give in header
__If-Match:__ download the remote object if it's md5 is the samethat the one you give in header

Using a md5 tool, like md5sum on linux, get the md5 of your file, locally:

```bash
md5sum file
b6d81b360a5672d80c27430f39153e2c  file
```

Add the md5 in special header:

```bash
curl -H "X-Auth-Token: abcd" \
     -H 'If-None-Match: d41d8cd98f00b204e9800998ecf8427e' \
     https://storage.bhs-1.runabove.io/v1/AUTH_1234/default/file
curl -H "X-Auth-Token: abcd" \
     -H 'If-Match: d41d8cd98f00b204e9800998ecf8427e' \
     https://storage.bhs-1.runabove.io/v1/AUTH_1234/default/file
```

# Compare local file and remote object using curl

On Object Storage, it's possible to get the ETag of an object using HEAD with curl. For example:

```bash
curl -i \
     -X HEAD \
     -H "X-Auth-Token: abcd" \
     https://storage.bhs-1.runabove.io/v1/AUTH_1234/default/file

Last-Modified: Tue, 22 Jul 2014 15:35:38 GMT[/li][li]Etag: b6d81b360a5672d80c27430f39153e2c
```

Then, using md5sum on Linux, or other md5 command on other operating system, you can manually check if the md5 is the same between your local file and remote object.

```bash
md5sum file
b6d81b360a5672d80c27430f39153e2c  file
```

# Compare local file and remote object using Swift Client

It's possible to get the ETag of an object using the 'stat' command available in Object Storage Client. For instance:

```bash
swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U tenant:login -K password stat container/file
Last-Modified: Tue, 22 Jul 2014 15:12:29 GMT
Etag: b6d81b360a5672d80c27430f39153e2c
```

Then, using md5sum on Linux, or other md5 command on other operating system, you can manually check if the md5 is the same between your local file and remote object.

```bash
md5sum file
b6d81b360a5672d80c27430f39153e2c  file
```

You have learned how to use md5/ETag on Object Storage to check if a file is up to date. But do you know that md5 is used almost everywhere in Object Storage ? md5 is compared to known md5 while uploading, downloading, stored near an object, allowing Object Storage internal process to continually check again and again if every object are consistent or if they need to be replicated from other replicat.
