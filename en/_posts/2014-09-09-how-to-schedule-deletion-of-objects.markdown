---
layout: post
title: "How to schedule deletion of objects"
categories: Object-Storage
lang: en
author: ArnaudJost
---

Sometimes, you need to delete one ore more object at a specific time.

For example, if you want to manage backups and delete them when older than X month, if  you want to create a cache for an application, or just because the data itself has a specific lifetime. It's very difficult to do this by hand : you have to list objects, check dates, and delete if needed...

Openstack Swift includes a very cool feature which is a nice solution to this problem : X-Delete-* header. You just have to push this header associated with a date on your object, and swift will do the job for you. Simple & Efficient.

# Prerequisites :

 * Python installed on your computer (https://www.python.org/)
 * Openstack swift client (https://github.com/openstack/python-swiftclient) or curl on unix.

# How it works :

An internal process parses objects on your account, and checks if the header X-Delete-At exists. If the header exists, it deletes the object if it's time, without any other intervention.


Please note that you'll always find the same header on your object: X-Delete-At, but you can push another header on your object : X-Delete-After (delete in X seconds). X-Delete-After is converted in X-Delete-At when you push it on your object.

```
X-Delete-After: delete in X seconds
X-Delete-At: delete at this date, in unix epoch format
```

# Let's delete an object automatically

First, get epoch time (or get the number of seconds that you need, if using X-Delete-After):

* Using http://www.epochconverter.com/
* On linux : date +%s

Then, post the header on your object.

With curl :

```bash
curl -X POST \
     -H 'X-Delete-After: 3600'\
     -H 'X-Auth-Token: 123' \
     https://storage.bhs-1.runabove.io/default/image.jpg

curl -X POST\
     -H 'X-Delete-At: 1401268563'\
     -H 'X-Auth-Token: 123'\
     https://storage.bhs-1.runabove.io/default/image.jpg
```

With swift client :

```bash
swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U tenant:login -K pass post --header "X-Delete-After: 3600" container object
swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U tenant:login -K pass post --header "X-Delete-At: 1401268563" container object
```

You can check if the header is correctly applied using swift client :

```bash
swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U tenant:login -K pass stat container object
```

Or with curl :

```bash
curl -X HEAD -H 'X-Auth-Token: 123' https://storage.bhs-1.runabove.io/default/image.jpg
```

You should see something like :

```
X-Delete-At: 1402647646
```

And it's already done ! You have nothing more to do, swift will delete the object on the chosen date.

# Conclusion :

With Openstack swift, it's very easy to create objects based on lifetime duration. With very few requests, you can set a destroy date and not be bothered with the deletion of old object.
You can also easily develop a scalable cache without management of deletion.
