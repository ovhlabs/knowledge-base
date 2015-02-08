---
layout: post
title: "How to use S3QL with Runabove?"
categories: Object-Storage
lang: en
author: pbtrung
---

S3QL is a file system that can be mounted locally and stores its data using cloud storage providers like Google Storage, Amazon S3, or OpenStack Swift. Some nice features are transparent compression, encryption, data de-duplication, and snapshotting, which makes it particularly appropriate for backup purposes. More information on the file system can be found on its author' [website](http://www.rath.org/s3ql-docs).

Since Openstack Swift is one of available backends of S3QL, we can use S3QL to save your data on Runabove object storage.

# 1. Set up

## Install S3QL 

The recommended version is 2.x or newer. Guides to install precompiled packages for popular Linux distributions are available on [S3QL wiki](https://bitbucket.org/nikratio/s3ql/wiki/Installation).

## Get account information

The required credentials are your login (email), password and tenant name, which can be accessed in `Openstack Horizon` under `Current Project`.

## A container to hold the file system

S3QL assumes you already has a working container. You can follow tutorials on Runabove Knowledge Base to create new container, e.g. [this one](https://community.runabove.com/kb/en/object-storage/upload-your-first-object-inside-swift.html).

# 2. Usage

Initialize the file system and associate it with your chosen container using keystore (v2) authentication

```
mkfs.s3ql swiftks://auth.runabove.io/<region name>:<container name>
```

The region name must be BHS-1 or SBG-1, e.g.

```
mkfs.s3ql swiftks://auth.runabove.io/BHS-1:myContainer
```

The above command will ask for your backend login, backend password and file system encryption passphrase. The backend login should be `<tenant>:<account email>`, e.g. `12345678:me@example.com`. The backend password is your Runabove account password and the encryption passphrase is to encrypt your data, which is therefore extremely important. You should choose a long, complex passphrase and keep it secret. 

Mount the S3QL file system to a directory

```
mount.s3ql swiftks://auth.runabove.io/BHS-1:myContainer /path/to/mount/point
```

Now the mounted directory will behave like a normal directory on your hard drive, e.g. copy, rename, move files. Do whatever you want with it.

After finishing your stuffs, you has to unmount the file system to make sure everything will be committed to your Runabove container.

```
umount.s3ql /path/to/mount/point
```

# 3. Advanced usage

`mount.s3ql` needs your credentials on every time it is called. An authentication file can facilitate the process. Create a text file `mycred` 

```
[myContainer]
storage-url: swiftks://auth.runabove.io/BHS-1:myContainer
backend-login: <tenant>:<account email>
backend-password: <your Runabove account password>
fs-passphrase: <file system encryption passphrase>
```

It is your responsibility to protect the `mycred` file. Remember to change its permission so that `mount.s3ql` does not complain

```
chmod 600 mycred
```

Now you can use `mount.s3ql` without entering your credentials

```
mount.s3ql --authfile /path/to/mycred swiftks://auth.runabove.io/BHS-1:myContainer /path/to/mount/point
```