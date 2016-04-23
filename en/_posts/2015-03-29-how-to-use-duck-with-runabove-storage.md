---
layout: post
title: "How to use Duck with RunAbove Storage?"
categories: Object Storage
author: michaelforge
lang: en
---

__Duck__ - is a CLI version of a GUI storage browser named __Cyberduck__.  
It's compatible with RunAbove Storage and available for Windows, Linux and Mac OS.

Use cases:
* Upload/download one file/directory
* Mass-upload whole directories recursively
* Edit files by your favorite editor
* Synchronize folders
* Backup to remote container
* Copy between servers (ex: migrate S3 to RunAbove)

# Installation

## Linux

### DEB (apt)

```bash
echo -e "deb https://s3.amazonaws.com/repo.deb.cyberduck.io stable main" | sudo tee -a /etc/apt/sources.list > /dev/null
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys FE7097963FEFBE72
sudo apt-get update
sudo apt-get install duck
```

### RPM (yum)

```bash
echo -e "[duck-stable]\nname=duck-stable\nbaseurl=https://repo.cyberduck.io/stable/\$basearch/\nenabled=1\ngpgcheck=0" | sudo tee /etc/yum.repos.d/duck-stable.repo
sudo yum install duck
```

## Mac OS

```bash
brew install duck
```
Requires [Homebrew](http://brew.sh/).

Or you can manually download PKG here: [https://dist.duck.sh/](https://dist.duck.sh/)

## Windows

### Chocolatey

```bash
choco install duck
```
Requires [Chocolatey](https://chocolatey.org/).

Or you can manually download MSI here: [https://dist.duck.sh/](https://dist.duck.sh/)


# Usage

```
duck [options] swift://auth.runabove.io/<container_name>/
```

It will ask to promt some information in this order:

| Ask | Input |
| --- | --- |
| Tenant ID:Access Key: | RunAbove account email |
| Secret Access Key: | RunAbove account password |
| Provide Additional login credentials. Tenant Name.  | Tenant name, can be found as project number at [Horizon](https://cloud.runabove.com/horizon/) |

## List objects

```
duck -l swift://auth.runabove.io/<container_name>
```
or, more detailed (with modification date and permission mask):
```
duck -L swift://auth.runabove.io/<container_name>
```

## Upload a file or directory

```
duck -u swift://auth.runabove.io/<container_name>/ <local_path>
```

Local path can be `~/*.jpg`.

## Edit a file

```
duck --edit swift://auth.runabove.io/<container_name>/<remote_path>
```

It would open remote file in editor, that associated as default in your system.  
Just save your edits and __duck__ would upload it automatically.

A nice and quick way to make some change in your static site.

## Syncronize a folder

```
duck --synchronize swift://auth.runabove.io/<container_name>/ <local_path>
```

## Copy from S3 to RunAbove

```
duck --copy s3://<access_key>@<bucket_name>/ swift://auth.runabove.io/<container_name>
```

It will ask for username/password for both ends.

Currently __duck__ can't use different options for both URL, ex: you can't use two different --username/--password or --region in one line. Instead, you can put `<access_key>` like in this example, and enter everything else in appeared promt.

## Other options

You can use `duck -h` to check what it's capable of, but here is some quick review:

| Option | What does it do |
| --- | --- |
| --region `<arg>` | Location of bucket or container |
| --parallel `<connections>` | Number of concurrent connections to use for transfers |
| --retry `<count>` | Retry failed connection attempts |
| --existing `<action>` | Transfer action for existing files (Resume, Compare, Rename, Overwrite or Cancel, check -h for more details) |
| -y or --assumeyes | Assume yes for all prompts |
| -q | Assume yes for all prompts |
| -v | Shows all HTTP requests and answers |