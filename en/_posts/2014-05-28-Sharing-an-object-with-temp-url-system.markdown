---
layout: post
title: "Sharing an object with temp url system"
categories: Object-Storage
lang: en
author: ArnaudJost
---

Openstack Swift can store a large amount of files. To manage a file (read, write..) you need to be authenticated with a token, for each api request. This is used to confirm your permissions on Swift. This token comes from the authentication system, with your login and password.

So, let's think you want to share a file with a friend or a colleague, but of course, you don't want to give a personal token or your credentials ! You can use ACL (Access Control List), but there is a simpler way which perfectly fits your need : "temp url" !

Temp url is a usefull feature : you can control which file you want to share and how much time the link is available using an extra parameter (more information below).

# Prerequistes :

 * Python installed on your computer ([https://www.python.org/](https://www.python.org/)
 * Openstack swift client ([https://github.com/openstack/python-swiftclient](https://github.com/openstack/python-swiftclient) or curl (Unix)
 * swift-temp-url python script (https://raw.githubusercontent.com/openstack/swift/master/bin/swift-temp-url](https://raw.githubusercontent.com/openstack/swift/master/bin/swift-temp-url)

# How it works :

Temp url generates a temporary url which contains :

 * Url of your swift endpoint (as usual). Example : "https://storage-bhs-1.runabove.io/"
 * The object in your account and container (as usual). Example : "v1/AUTH_tenant/default/file"
 * A first extra parameter, temp_url_sign, it's a cryptographic signature, generated with a secret key, the http method, the path of your file, and the expire date (hash).
 * A second extra parameter, url_expires, the expiration time of your link. When this date is expired, the link does not work anymore.

You do not need to add any settings, permissions or anything else. Just add your account's secret key and generate the url, It is that simple. Share the url with anyone that you would like to be able to download the file.

When the link is used, openstack checks the signature and the expiration date. If valid, openstack allows the user to download the file, if not, the user  is not able to download the object.

Ok so it look like a nice feature, right ?
Let's go !

# Generate your temp url :

First, you have to generate a key. This key is available for all files in your account, it's generated one time for all future temp url, so, choose a secure and long key. Please note that you can change the key when you want.  To generate your key. Please use a string which contain at least 20 character.

You can use :
 * http://www.random.org/strings/
 * /dev/urandom (on linux)
 * Just a simple "date +%s | md5sum"

It's time to set your secret key on your account. Using swift client (please replace 12345 with your own secure generated key), add the necessary header. Please note that the real header is named "X-Account-Meta-Temp-Url-Key" but swift client use "Temp-URL-Key" and add "X-Account" prefix automatically :

Using swift client :

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U tenant:login -K password post -m "Temp-URL-Key: 12345"
```

Using curl :

```curl -i  -X POST \
            -H "X-Account-Meta-Temp-URL-Key: 12345" \
            -H "X-Auth-Token: abcdef12345" \
            https://storage.bhs-1.runabove.io/v1/AUTH_tenant/
```

Your key is now set on your account, and openstack can use it to check if a temp url is valid . To verify that the header was correctly applied, use swift client :

```swift -v -V 2.0 -A https://auth.runabove.io/v2.0 -U tenant:login -K password stat
```

Or curl :

```curl -i  -X HEAD \
            -H "X-Auth-Token: abcdef12345" \
            https://storage.bhs-1.runabove.io/v1/AUTH_tenant/
```

Now, you don't need to be online to generate temp url.

Let's generate a temp url offline using swift-temp-url tool:

```
python swift-temp-url GET 60 /v1/AUTH_tenant/default/file 12345
```

 * __GET__: http method. Usually you want to use GET.
 * __60__: available for 60 secondes, set your own limit.
 * __12345__: replace with your own secret key, set on previous step.
 * __/v1/AUTH_tenant/default/file__: it's the path to your file. Please note that you do not need the endpoint (but you'll add it to the result in the next step).

It will give you the temp url, for example :
```
/v1/AUTH_tenant/default/file?temp_url_sig=8016dsdf3122d526afds60911cde59fds3&temp_url_expires=1401548543
```

You can see the path of your file, the signature, and the expiration date, as explained before.

To have a working url, you need to add the endpoint first. The final url could be :

```
https://storage.bhs-1.runabove.io/v1/AUTH_tenant/default/file?temp_url_sig=8016dsdf3122d526afds60911cde59fds3&temp_url_expires=1401548543
```

In our example, this url permits the download of file named "file" in "default" container, for 60 seconds, for everyone, without authentication. After 60 seconds, the url is no longer valid.

# Conclusion :

Openstack is secured by using login/password and token. But you can also share files simply using temp url.

For advanced user who want to generate temp url without swift-temp-url tool : [http://docs.openstack.org/trunk/config-reference/content/object-storage-tempurl.html](http://docs.openstack.org/trunk/config-reference/content/object-storage-tempurl.html)

## Nota :

swift-temp-url is just a python script to generate temp url. You can generate temp url in your own language (check swift-temp-url content).

### Example of code in python :

```python
import hmac
from hashlib import sha1
from time import time


method = 'GET'
duration_in_seconds = 60*60*24
expires = int(time() + duration_in_seconds)
path = '/v1/AUTH_a422b2-91f3-2f46-74b7-d7c9e8958f5d30/container/object'
key = 'mykey'
hmac_body = '%s\n%s\n%s' % (method, expires, path)
sig = hmac.new(key, hmac_body, sha1).hexdigest()
s = 'https://{host}/{path}?temp_url_sig={sig}&temp_url_expires={expires}'
url = s.format(host='swift-cluster.example.com', path=path, sig=sig, expires=expires)
```
